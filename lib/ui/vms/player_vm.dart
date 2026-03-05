import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcasks/repository/history_repo.dart';
import 'package:podcasks/repository/queue_repo.dart';
import 'package:podcasks/locator.dart';
import 'package:podcasks/manager/audio_handler.dart';
import 'package:podcasks/ui/vms/vm.dart';

final playerViewmodel = ChangeNotifierProvider((ref) => PlayerViewmodel(ref));

class PlayerViewmodel extends Vm {
  Episode? get playing => _playing;
  Episode? _playing;

  Duration get position => audioHandler?.position ?? Duration.zero;

  Duration get duration => audioHandler?.duration ?? Duration.zero;

  Duration get buffered => audioHandler?.buffered ?? Duration.zero;

  double get speed => audioHandler?.speed ?? 1;

  bool get isReady => audioHandler?.processingState == ProcessingState.ready;

  double get percent => (duration != Duration.zero && duration >= position)
      ? position.inSeconds / duration.inSeconds
      : 0.0;

  double get bufferedPercent => (duration != Duration.zero && duration >= buffered)
      ? buffered.inSeconds / duration.inSeconds
      : 0.0;

  Timer? _positionTimer;
  Timer? _saveTimer;

  final HistoryRepo _historyRepo = locator.get<HistoryRepo>();
  final QueueRepo _queueRepo = locator.get<QueueRepo>();

  Future<List<MediaItem>> get queue async => await _queueRepo.getAll();

  Ref<Object?> ref;

  PlayerViewmodel(this.ref);

  @override
  void dispose() {
    audioHandler?.dispose();
    _positionTimer?.cancel();
    _saveTimer?.cancel();
    super.dispose();
  }

  Future<void> play({Episode? track, Podcast? pod, bool seekPos = false}) async {
    _stopSaveTimers();
    loading();
    if (pod != null) {
      if (track!.contentUrl != _playing?.contentUrl) {
        await setupPlayer(track, pod);
      }
    }

    if (track != null && seekPos) {
      final (remaining, total, finished) =
          _historyRepo.getPosition(track) ?? (null, null, null);
      if (remaining != null && finished == false) {
        if (remaining > const Duration(seconds: 2)) {
          final totalDuration = (total != null && total != Duration.zero)
              ? total
              : (track.duration ?? duration);
          if (totalDuration != Duration.zero) {
            await seekPosition(totalDuration - remaining);
          }
        }
      }
    }

    audioHandler?.play();
    _startSaveTimers();
    success();
  }

  Future<void> setupPlayer(Episode track, Podcast pod) async {
    _playingPodcast = pod;
    _playing = track;
    await audioHandler?.setMediaUrl(
      MediaItem(
        id: track.contentUrl ?? '',
        title: track.title,
        artist: pod.title,
        artUri: Uri.parse(image ?? ''),
        duration: track.duration,
      ),
      (playbackState) async {
        if (playbackState.playing) {
          await _startSaveTimers();
        } else {
          _stopSaveTimers();
        }
      },
    );
  }

  Future<void> _startSaveTimers() async {
    _stopSaveTimers();
    print("STARTED");
    _positionTimer = Timer.periodic(
        Duration(milliseconds: ((1 / speed) * 1000).toInt()),
        (timer) => updatePosition());
    _saveTimer =
        Timer.periodic(const Duration(seconds: 1), (timer) => saveTrack());
  }

  void _stopSaveTimers() {
    print("STOPPED");
    _positionTimer?.cancel();
    _saveTimer?.cancel();
  }

  Future<void> pause() async {
    loading();
    _stopSaveTimers();
    await audioHandler?.pause();
    success();
  }

  bool isPlaying({String? url}) {
    if (url != null) {
      return (audioHandler?.playing == true && playing?.contentUrl == url);
    }
    return (audioHandler?.playing == true);
  }

  Podcast? get playingPodcast => _playingPodcast;
  Podcast? _playingPodcast;

  String? get image => _playing?.imageUrl ?? _playingPodcast?.image;

  Future<void> updatePosition() async {
    if (audioHandler != null) {
      if (duration != Duration.zero) {
        notifyListeners();
      }

      // finished episode
      if (position.inSeconds == duration.inSeconds &&
          duration != Duration.zero) {
        await saveTrack();
        // if there is something in queue
        final next = (await queue).firstOrNull;
        if (next != null) {
          final podcastUrl = next.extras?["podcast_url"];
          if (podcastUrl != null) {
            final pod = await Feed.loadFeed(url: podcastUrl);
            final ep = pod.episodes.firstWhereOrNull((e) => e.contentUrl == next.id);
            if (ep != null) {
              _queueRepo.removeItem(next);
              await saveTrack();
              await setupPlayer(ep, pod);
              await play();
              notifyListeners();
              return;
            }
          }
        }

        // check next episode
        int? i = playingPodcast?.episodes.indexWhere(
          (e) => e.contentUrl == playing?.contentUrl,
        );

        if (i != null && playingPodcast != null) {
          Episode? ep;
          if ((i != 0)) {
            ep = playingPodcast?.episodes[i - 1];
          } else {
            ep = null;
          } 

          if (ep != null) {
            await saveTrack();
            await setupPlayer(ep, playingPodcast!);
            await play();
            notifyListeners();
            return;
          }
        }

        // empty queue
        await seekPosition(Duration.zero);
        await saveTrack();
        await pause();
        notifyListeners();
      }
    }
  }

  Future<void> forward(Duration time) async {
    if (audioHandler != null) {
      if (position + time < Duration.zero) {
        await audioHandler!.seek(Duration.zero);
      } else if (position + time > duration) {
        await audioHandler!.seek(duration);
      } else {
        await audioHandler!.seek(position + time);
      }
      if (!isPlaying()) {
        notifyListeners();
      }
    }
  }

  Future<void> seek(double timePerc) async {
    final d = Duration(seconds: (timePerc * duration.inSeconds).toInt());
    if (audioHandler != null) {
      await audioHandler!.seek(d);
      if (!isPlaying()) {
        notifyListeners();
      }
    }
  }

  Future<void> seekPosition(Duration pos) async {
    if (audioHandler != null) {
      await audioHandler!.seek(pos);
      if (!isPlaying()) {
        notifyListeners();
      }
    }
  }

  Future<void> saveTrack() async {
    if (audioHandler != null && playing != null && playingPodcast != null) {
      final d = duration;
      final p = position;
      if (d == Duration.zero) return;
      print("SAVETRACK");
      final remaining = d - p;
      await _historyRepo.setPosition(
          playing!, playingPodcast!, remaining, d);
    }
  }

  Future<void> setSpeed(double speed) async {
    await audioHandler?.setSpeed(speed);
    await saveTrack();
    await _startSaveTimers();
    notifyListeners();
  }

  void share(Episode? episode) {
    if (episode?.link != null) {
      Clipboard.setData(ClipboardData(text: episode!.link!));
    }
  }

  Duration? getEnlapsed(Episode? episode) {
    if (episode == null) return null;
    final (rem, total, _) =
        _historyRepo.getPosition(episode) ?? (Duration.zero, Duration.zero, false);
    final d = (episode.duration != null && episode.duration != Duration.zero)
        ? episode.duration!
        : total;
    if (d == Duration.zero) return null;
    return d - rem;
  }
}

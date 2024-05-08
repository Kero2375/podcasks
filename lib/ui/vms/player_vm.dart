// ignore_for_file: avoid_print

import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/data/entities/queue/queue_track.dart';
import 'package:podcasks/repository/history_repo.dart';
import 'package:podcasks/repository/queue_repo.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcasks/data/podcast_episode.dart';
import 'package:podcasks/locator.dart';
import 'package:podcasks/manager/audio_handler.dart';
// import 'package:podcasks/repository/search_repo.dart';
import 'package:podcasks/ui/vms/vm.dart';

final playerViewmodel = ChangeNotifierProvider((ref) => PlayerViewmodel());

class PlayerViewmodel extends Vm {
  // final SearchRepo _searchRepo = locator.get<SearchRepo>();
  ScrollController scrollController = ScrollController();

  final int _scrollOffset = 300;

  PodcastEpisode? get playing => _playing;
  PodcastEpisode? _playing;

  Duration get position => audioHandler?.position ?? Duration.zero;

  Duration get duration => audioHandler?.duration ?? Duration.zero;

  double get speed => audioHandler?.speed ?? 1;

  double get percent => (duration != Duration.zero && duration >= position)
      ? position.inSeconds / duration.inSeconds
      : 0.0;

  Timer? _positionTimer;
  Timer? _saveTimer;

  final HistoryRepo _historyRepo = locator.get<HistoryRepo>();
  final QueueRepo _queueRepo = locator.get<QueueRepo>();

  Future<List<QueueTrack>> get queue async => await _queueRepo.getAll();

  @override
  void dispose() {
    audioHandler?.dispose();
    _positionTimer?.cancel();
    _saveTimer?.cancel();
    super.dispose();
  }

  Future<void> play({PodcastEpisode? track, bool seekPos = false}) async {
    loading();
    if (track?.podcast != null) {
      if (track!.contentUrl != _playing?.contentUrl) {
        await setupPlayer(track);
      }
    }

    if (track != null && seekPos) {
      final (pos, _) = _historyRepo.getPosition(track) ?? (null, null);
      if (pos != null) {
        await seekPosition(duration - pos);
      }
    }

    audioHandler?.play();
    saveTrack();
    _startSaveTimers();
    success();
  }

  Future<void> setupPlayer(PodcastEpisode track) async {
    // loading();
    _playing = track;
    await audioHandler?.setMediaUrl(
      MediaItem(
        id: track.contentUrl ?? '',
        title: track.title,
        artist: track.podcast?.title,
        artUri: Uri.parse(image ?? ''),
        duration: track.duration,
      ),
      (playbackState) async {
        if (playbackState.playing) {
          await _startSaveTimers();
        } else {
          _stopSaveTimers();
        }
        // success();
      },
    );
    // success();
  }

  Future<void> _startSaveTimers() async {
    _stopSaveTimers();
    print("STARTED");
    _positionTimer = Timer.periodic(
        Duration(milliseconds: ((1 / speed) * 1000).toInt()),
        (timer) => updatePosition());
    _saveTimer =
        Timer.periodic(const Duration(seconds: 10), (timer) => saveTrack());
    // await saveTrack();
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

  Podcast? get playingPodcast => _playing?.podcast;

  String? get image => _playing?.imageUrl ?? _playing?.podcast?.image;

  Future<void> updatePosition() async {
    if (audioHandler != null) {
      if (duration != Duration.zero) {
        notifyListeners();
      }

      // finished episode
      if (position.inSeconds == duration.inSeconds &&
          duration != Duration.zero) {
        // if there is something in queue
        final next = (await queue).firstOrNull;
        if (next != null) {
          final ep = await PodcastEpisode.fromUrl(
            podcastUrl: next.podcastUrl,
            episodeUrl: next.url,
          );
          if (ep != null) {
            _queueRepo.removeItem(next);
            await saveTrack(true);
            await setupPlayer(ep);
            await play();
            notifyListeners();
            return;
          }
        }
        // empty queue
        await seekPosition(Duration.zero);
        await saveTrack(true);
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

  Future<void> saveTrack([bool finished = false]) async {
    if (audioHandler != null && playing != null) {
      print("SAVETRACK");
      await _historyRepo.setPosition(playing!, duration - position, finished);
    }
  }

  bool isScrollToInitialPosition() =>
      scrollController.offset <=
      scrollController.initialScrollOffset + _scrollOffset;

  scrollDown() async {
    if (isScrollToInitialPosition()) {
      await scrollController.animateTo(
        scrollController.initialScrollOffset + _scrollOffset,
        duration: const Duration(milliseconds: 200),
        curve: Curves.decelerate,
      );
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
}

import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:ppp2/data/track.dart';
import 'package:ppp2/locator.dart';
import 'package:ppp2/manager/audio_handler.dart';
import 'package:ppp2/repository/history_repo.dart';
import 'package:ppp2/ui/vms/vm.dart';

final playerViewmodel = ChangeNotifierProvider((ref) => PlayerViewmodel());

class PlayerViewmodel extends Vm {
  Track? get playing => _playing;
  Track? _playing;

  Duration get position => audioHandler?.position ?? Duration.zero;

  Duration get duration => audioHandler?.duration ?? Duration.zero;

  double get percent => (duration != Duration.zero) ? position.inSeconds / duration.inSeconds : 0.0;

  Timer? _positionTimer;
  Timer? _saveTimer;

  final HistoryRepo _historyRepo = locator.get<HistoryRepo>();

  @override
  void dispose() {
    _positionTimer?.cancel();
    _saveTimer?.cancel();
    super.dispose();
  }

  Future<void> play({Track? track}) async {
    loading();
    if (track != null) {
      if (track.url != _playing?.url) {
        await setPlaying(track);
      }
    }
    audioHandler?.play();
    _positionTimer = Timer.periodic(const Duration(seconds: 1), (timer) => updatePosition());
    saveTrack();
    _saveTimer = Timer.periodic(const Duration(seconds: 10), (timer) => saveTrack());
    success();
  }

  Future<void> setPlaying(Track track) async {
    _playing = track;
    await audioHandler?.setMediaUrl(MediaItem(
      id: track.url ?? '',
      title: track.episode?.title ?? '',
      artist: track.podcast?.title,
      artUri: Uri.parse(image ?? ''),
      duration: track.episode?.duration,
    ));
  }

  Future<void> pause() async {
    loading();
    await audioHandler?.pause();
    _positionTimer?.cancel();
    _saveTimer?.cancel();
    success();
  }

  bool isPlaying({String? url}) {
    if (url != null) {
      return (audioHandler?.playing == true && playingEpisode?.contentUrl == url);
    }
    return (audioHandler?.playing == true);
  }

  Episode? get playingEpisode => _playing?.episode;

  Podcast? get playingPodcast => _playing?.podcast;

  String? get image => _playing?.episode?.imageUrl ?? _playing?.podcast?.image;

  void updatePosition() {
    if (audioHandler != null) {
      if (duration != Duration.zero) {
        notifyListeners();
      }

      if (position.inSeconds == duration.inSeconds && duration != Duration.zero) {
        seekPosition(Duration.zero);
        pause();
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

  saveTrack() {
    if (audioHandler != null) {
      _historyRepo.setPlaying(playing);
      _historyRepo.setPosition(position);
    }
  }
}

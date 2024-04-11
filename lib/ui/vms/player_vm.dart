import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:ppp2/data/track.dart';
import 'package:ppp2/manager/audio_handler.dart';
import 'package:ppp2/ui/vms/vm.dart';

final playerViewmodel = ChangeNotifierProvider((ref) => PlayerViewmodel());

class PlayerViewmodel extends Vm {
  Track? _playing;

  double get trackPosition => _trackPosition;
  double _trackPosition = 0.0;
  Timer? _positionTimer;

  Future<void> play({Track? track}) async {
    loading();
    if (track != null) {
      if (track.url != _playing?.url) {
        await audioHandler?.setMediaUrl(MediaItem(
          id: track.url ?? '',
          title: track.episode?.title ?? '',
          artist: track.podcast?.title,
          artUri: Uri.parse(track.episode?.imageUrl ?? ''),
          duration: track.episode?.duration,
        ));
        _playing = track;
      }
    }
    audioHandler?.play();
    _positionTimer = Timer.periodic(const Duration(seconds: 1), (timer) => updatePosition());
    success();
  }

  Future<void> pause() async {
    loading();
    await audioHandler?.pause();
    _positionTimer?.cancel();
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

  void updatePosition() {
    if (audioHandler != null) {
      final duration = audioHandler!.duration;
      final position = audioHandler!.position;
      if (duration != Duration.zero) {
        _trackPosition = position.inSeconds / duration.inSeconds;
        notifyListeners();
      }
    }
  }
}

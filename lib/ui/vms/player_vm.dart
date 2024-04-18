import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/repository/history_repo.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcasks/data/podcast_episode.dart';
import 'package:podcasks/locator.dart';
import 'package:podcasks/manager/audio_handler.dart';
import 'package:podcasks/repository/last_playing_repo.dart';
import 'package:podcasks/repository/search_repo.dart';
import 'package:podcasks/ui/vms/vm.dart';

final playerViewmodel = ChangeNotifierProvider((ref) => PlayerViewmodel());

class PlayerViewmodel extends Vm {
  final SearchRepo _searchRepo = locator.get<SearchRepo>();
  ScrollController scrollController = ScrollController();

  final int _scrollOffset = 300;

  PodcastEpisode? get playing => _playing;
  PodcastEpisode? _playing;

  Duration get position => audioHandler?.position ?? Duration.zero;

  Duration get duration => audioHandler?.duration ?? Duration.zero;

  double get percent => (duration != Duration.zero)
      ? position.inSeconds / duration.inSeconds
      : 0.0;

  Timer? _positionTimer;
  Timer? _saveTimer;

  final LastPlayingRepo _lastPlayingRepo = locator.get<LastPlayingRepo>();
  final HistoryRepo _historyRepo = locator.get<HistoryRepo>();

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
        await setPlaying(track);
      }
    }

    if (track != null && seekPos) {
      final pos = await _historyRepo.getPosition(track);
      if (pos != null) {
        await seekPosition(pos);
      }
    }

    audioHandler?.play();

    _positionTimer =
        Timer.periodic(const Duration(seconds: 1), (timer) => updatePosition());
    saveTrack();
    _saveTimer =
        Timer.periodic(const Duration(seconds: 10), (timer) => saveTrack());
    success();
  }

  Future<void> setPlaying(PodcastEpisode track) async {
    _playing = track;
    await audioHandler?.setMediaUrl(
      MediaItem(
        id: track.contentUrl ?? '',
        title: track.title,
        artist: track.podcast?.title,
        artUri: Uri.parse(image ?? ''),
        duration: track.duration,
      ),
    );

    _lastPlayingRepo.setLastPlaying(playing);
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
    if (audioHandler != null && playing != null) {
      await _historyRepo.setPosition(playing!, position);
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

  download(Episode? episode) => _searchRepo.download(episode);
}

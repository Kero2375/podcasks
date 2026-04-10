import 'package:audio_service/audio_service.dart';
import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:podcasks/l10n/app_localizations.dart';
import 'package:podcasks/repository/favourites_repo.dart';
import 'package:podcast_search/podcast_search.dart';
import 'dart:developer';

MyAudioHandler? audioHandler;

class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  late final AudioPlayer _player;
  final _favRepo = FavouriteRepoIsar();

  Future<AppLocalizations> get _l10n async => await AppLocalizations.delegate.load(
        WidgetsBinding.instance.platformDispatcher.locale,
      );

  dispose() {
    _player.dispose();
  }

  MyAudioHandler() {
    _player = AudioPlayer(
      audioLoadConfiguration: const AudioLoadConfiguration(
        darwinLoadControl: DarwinLoadControl(
          preferredForwardBufferDuration: Duration(minutes: 20),
          canUseNetworkResourcesForLiveStreamingWhilePaused: true,
        ),
        androidLoadControl: AndroidLoadControl(
          maxBufferDuration: Duration(minutes: 20),
        )
      )
    );
    _player.setCanUseNetworkResourcesForLiveStreamingWhilePaused(true);
    _player.durationStream.listen((d) {
      if (mediaItem.value != null) {
        mediaItem.add(
          mediaItem.value!.copyWith(duration: d),
        );
      }
    });

    _player.playbackEventStream.listen(_broadcastState, onError: (Object e, StackTrace st) {
      _handleError(e);
    });
    _player.playerStateStream.listen((_) => _broadcastState(_player.playbackEvent));
  }

  void _handleError(Object e) {
    log('Audio player error: $e');
    playbackState.add(playbackState.value.copyWith(
      processingState: AudioProcessingState.error,
      errorMessage: e.toString(),
    ));
  }

  void _broadcastState(PlaybackEvent event) {
    final playing = _player.playing;
    playbackState.add(playbackState.value.copyWith(
      controls: [
        if (playing) MediaControl.pause else MediaControl.play,
        MediaControl.rewind,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    ));
  }

  @override
  Future<List<MediaItem>> getChildren(String parentMediaId,
      [Map<String, dynamic>? options]) async {
    if (parentMediaId == AudioService.browsableRootId) {
      final favourites = await _favRepo.getAllFavourites();
      final list = <(Episode, Podcast)>[];

      for (Podcast p in favourites) {
        list.addAll(p.episodes.map((e) => (e, p)));
      }
      list.sort((a, b) => b.$1.publicationDate != null
          ? b.$1.publicationDate?.compareTo(a.$1.publicationDate ?? DateTime.fromMillisecondsSinceEpoch(0)) ?? 0
          : 0);

      final recent = list.take(30).toList();
      return recent.map((item) {
        final (episode, podcast) = item;
        return MediaItem(
          id: episode.contentUrl ?? '',
          album: podcast.title,
          title: episode.title,
          artist: podcast.title,
          duration: episode.duration,
          artUri: episode.imageUrl == null && podcast.image == null
              ? null
              : Uri.tryParse(episode.imageUrl ?? podcast.image ?? ''),
          extras: {"podcast_url": podcast.url},
        );
      }).toList();
    }
    return [];
  }

  @override
  Future<void> playFromMediaId(String mediaId, [Map<String, dynamic>? extras]) async {
    final List<MediaItem> children = await getChildren(AudioService.browsableRootId);
    final MediaItem? item = children.firstWhereOrNull((i) => i.id == mediaId);
    if (item != null) {
      return await playMediaItem(item);
    } else {
      return super.playFromMediaId(mediaId);
    }
  }

  @override
  Future<void> playMediaItem(MediaItem mediaItem) async {
    await setMediaUrl(mediaItem);
    return await play();
  }

  setMediaUrl(MediaItem? item) async {
    final l10n = await _l10n;
    try {
      if (item?.id != null) {
        mediaItem.add(item!);
        if (item.id.startsWith('/') || item.id.startsWith('file://')) {
          await _player.setFilePath(item.id.replaceFirst('file://', ''));
        } else {
          await _player.setUrl(item.id, preload: true);
        }
        await _player.load();
      }
    } on PlayerException catch (e) {
      _handleError(e.message ?? l10n.unknownPlayerError);
    } on PlayerInterruptedException catch (e) {
      _handleError(e.message ?? l10n.playbackInterrupted);
    } catch (e) {
      _handleError(l10n.anErrorOccurred(e.toString()));
    }
  }

  @override
  Future<void> play() async {
    await _player.play();
  }

  @override
  Future<void> pause() async {
    _player.pause();
  }

  @override
  Future<void> stop() async {
    return _player.stop();
  }

  @override
  Future<void> seek(Duration position) {
    playbackState.add(playbackState.value.copyWith(updatePosition: position));
    return _player.seek(position);
  }

  bool get playing => _player.playing;

  Duration get position => _player.position;

  Duration get duration => _player.duration ?? Duration.zero;

  Duration get buffered => _player.bufferedPosition;

  double get speed => _player.speed;

  ProcessingState get processingState => _player.processingState;

  @override
  Future<void> setSpeed(double speed) {
    playbackState.add(playbackState.value.copyWith(speed: speed));
    return _player.setSpeed(speed);
  }
}

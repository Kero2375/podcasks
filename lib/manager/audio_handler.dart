import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

MyAudioHandler? audioHandler;

class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  late final AudioPlayer _player;

  dispose() {
    _player.dispose();
  }

  MyAudioHandler() {
    _player = AudioPlayer();
    _player.durationStream.listen((d) {
      mediaItem.add(
        mediaItem.value?.copyWith(duration: d),
      );
    });
  }

  setMediaUrl(MediaItem? item) async {
    if (item?.id != null) {
      mediaItem.add(item!);
      playbackState.add(
        PlaybackState(
          controls: [
            MediaControl.pause,
            MediaControl.play,
          ],
          systemActions: const {
            MediaAction.seek,
            MediaAction.seekForward,
            MediaAction.seekBackward,
          },
          processingState: AudioProcessingState.ready,
          playing: false,
        ),
      );
      _player.setUrl(item.id);
      await _player.load();
    }
  }

  // Future<Duration?> getDurationFromUrl(String url) async {
  //   final ap = AudioPlayer();
  //   await ap.setUrl(url);
  //   final d = ap.duration;
  //   await ap.dispose();
  //   return d;
  //   return null;
  // }

  @override
  Future<void> play() async {
    playbackState.add(
      playbackState.value.copyWith(
        playing: true,
        updatePosition: position,
      ),
    );
    await _player.play();
  }

  @override
  Future<void> pause() async {
    playbackState.add(
      playbackState.value.copyWith(
        playing: false,
        updatePosition: _player.position,
      ),
    );
    _player.pause();
  }

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> seek(Duration position) {
    playbackState.add(playbackState.value.copyWith(updatePosition: position));
    return _player.seek(position);
  }

  bool get playing => _player.playing;

  Duration get position => _player.position;

  Duration get duration => _player.duration ?? Duration.zero;

// Future<void> skipToQueueItem(int i) => _player.seek(Duration.zero, index: i);
}

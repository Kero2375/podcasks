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

  setMediaUrl(
      MediaItem? item, Function(PlaybackState) playbackStateListener) async {
    if (item?.id != null) {
      mediaItem.add(item!);
      playbackState.add(
        PlaybackState(
          controls: [
            MediaControl.pause,
            MediaControl.play,
            MediaControl.rewind,
            MediaControl.fastForward,
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
      await _player.setUrl(item.id);
      await _player.load();
      // playbackState.listen(playbackStateListener);
    }
  }

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

  double get speed => _player.speed;

  ProcessingState get processingState => _player.processingState;

  @override
  Future<void> setSpeed(double speed) {
    playbackState.add(playbackState.value.copyWith(speed: speed));
    return _player.setSpeed(speed);
  }

// Future<void> skipToQueueItem(int i) => _player.seek(Duration.zero, index: i);
}

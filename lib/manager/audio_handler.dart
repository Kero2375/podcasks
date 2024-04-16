import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

MyAudioHandler? audioHandler;

class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final _player = AudioPlayer();

  dispose() {
    _player.dispose();
  }

  setMediaUrl(MediaItem? item) {
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
    }
  }

  Future<Duration?> getDuration(String url, [AudioPlayer? player]) async {
    if (player == null) {
      return _player.duration;
    }
    final p1 = player;
    await p1.setUrl(url);
    final duration = p1.duration;
    p1.dispose();
    return duration;
  }

  @override
  Future<void> play() async {
    playbackState.add(
      playbackState.value.copyWith(
        playing: true,
        updatePosition: _player.position,
      ),
    );
    _player.play();
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

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podcasks/data/entities/save_track.dart';
import 'package:podcasks/data/podcast_episode.dart';
import 'package:podcast_search/podcast_search.dart';

abstract class HistoryRepo {
  Future<void> setPosition(PodcastEpisode episode, Duration? position);

  Future<Duration?> getPosition(Episode episode);
}

class HistoryRepoIsar extends HistoryRepo {
  Isar? isar;

  HistoryRepoIsar() {
    init();
  }

  Future<void> init() async {
    final dir = await getApplicationSupportDirectory();
    isar = await Isar.open(
      [SaveTrackSchema],
      directory: dir.path,
    );
  }

  @override
  Future<Duration?> getPosition(Episode episode) async {
    final id = episode.contentUrl?.hashCode;
    if (id != null) {
      final saved = await isar?.saveTracks.get(id);
      if (saved != null && saved.position != null) {
        return Duration(seconds: saved.position!);
      }
    }
    return null;
  }

  @override
  Future<void> setPosition(PodcastEpisode episode, Duration? position) async {
    final id = episode.contentUrl?.hashCode;
    if (id != null && position != null) {
      await isar?.writeTxn(
        () async => await isar?.saveTracks.put(SaveTrack(
          id: id,
          url: episode.contentUrl,
          position: position.inSeconds,
        )),
      );
    }
  }
}

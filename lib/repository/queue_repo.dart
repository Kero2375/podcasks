import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podcasks/data/entities/queue_track.dart';
import 'package:podcasks/data/podcast_episode.dart';

abstract class QueueRepo {
  Future<void> addItem(PodcastEpisode episode);

  Future<QueueTrack?> getItem(int id);

  Future<List<QueueTrack>> getAll();
}

class QueueRepoIsar extends QueueRepo {
  Isar? isar;

  QueueRepoIsar() {
    init();
  }

  Future<void> init() async {
    final dir = await getApplicationSupportDirectory();
    isar = await Isar.open(
      [QueueTrackSchema],
      directory: dir.path,
    );
  }

  @override
  Future<void> addItem(PodcastEpisode episode) async {
    await isar?.writeTxn(() async => isar?.queueTracks.put(QueueTrack(
          id: episode.hashCode,
          url: episode.contentUrl,
          podcastUrl: episode.podcast?.url,
          title: episode.title,
          image: episode.imageUrl ?? episode.podcast?.image,
          next: null,
        )));
  }

  @override
  Future<List<QueueTrack>> getAll() async {
    return await isar?.queueTracks.where().findAll() ?? [];
  }

  @override
  Future<QueueTrack?> getItem(int id) async {
    return await isar?.queueTracks.get(id);
  }
}

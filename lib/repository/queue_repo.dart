import 'package:isar/isar.dart';
import 'package:podcasks/data/entities/podcast/podcast_entity.dart';
import 'package:podcasks/data/entities/queue/queue_track.dart';
import 'package:podcasks/data/entities/episode/podcast_episode.dart';

abstract class QueueRepo {
  Future<void> addItem(MEpisode episode, MPodcast podcast);

  Future<QueueTrack?> getItem(int id);

  Future<void> removeItem(QueueTrack track);

  Future<List<QueueTrack>> getAll();

  Future<void> clearAll();
}

class QueueRepoIsar extends QueueRepo {
  Isar? get isar => Isar.getInstance();

  @override
  Future<void> addItem(MEpisode episode, MPodcast podcast) async {
    await isar?.writeTxn(
      () async => isar?.queueTracks.put(
        QueueTrack(
          url: episode.contentUrl,
          podcastUrl: podcast.url,
          title: episode.title,
          image: episode.imageUrl ?? podcast.image,
          next: null,
        ),
      ),
    );
  }

  @override
  Future<List<QueueTrack>> getAll() async {
    return await isar?.queueTracks.where().findAll() ?? [];
  }

  @override
  Future<QueueTrack?> getItem(int id) async {
    return await isar?.queueTracks.get(id);
  }

  @override
  Future<void> removeItem(QueueTrack track) async {
    await isar?.writeTxn(() async => isar?.queueTracks.delete(track.id));
  }

  @override
  Future<void> clearAll() async {
    await isar?.writeTxn(() async => isar?.queueTracks.clear());
  }
}

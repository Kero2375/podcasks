import 'package:audio_service/audio_service.dart';
import 'package:podcasks/data/entities/podcast/podcast_entity.dart';
import 'package:podcasks/data/entities/episode/podcast_episode.dart';
import 'package:podcasks/manager/audio_handler.dart';

abstract class QueueRepo {
  Future<void> addItem(MEpisode episode, MPodcast podcast);

  Future<MediaItem?> getItem(int id);

  Future<void> removeItem(MediaItem track);

  Future<List<MediaItem>> getAll();

  Future<void> clearAll();
}

class QueueRepoAudioHandler extends QueueRepo {
  @override
  Future<void> addItem(MEpisode episode, MPodcast podcast) async {
    await audioHandler?.addQueueItem(
      MediaItem(
          id: episode.contentUrl ?? '',
          title: episode.title,
          artist: podcast.title,
          artUri: Uri.parse(episode.imageUrl ?? podcast.image ?? ''),
          duration: episode.duration,
          extras: {"podcast_url": podcast.url}),
    );
  }

  @override
  Future<void> clearAll() async {
    while ((audioHandler?.queue.value.length ?? 0) > 0) {
      audioHandler?.queue.value.removeLast();
    }
  }

  @override
  Future<List<MediaItem>> getAll() async {
    return Future.value(audioHandler?.queue.value.toList());
  }

  @override
  Future<MediaItem?> getItem(int id) {
    return Future.value(audioHandler?.queue.value[id]);
  }

  @override
  Future<void> removeItem(MediaItem track) async {
    await audioHandler?.removeQueueItem(track);
  }
}

// class QueueRepoIsar extends QueueRepo {
//   Isar? get isar => Isar.getInstance();

//   @override
//   Future<void> addItem(MEpisode episode, MPodcast podcast) async {
//     await isar?.writeTxn(
//       () async => isar?.queueTracks.put(
//         QueueTrack(
//           url: episode.contentUrl,
//           podcastUrl: podcast.url,
//           title: episode.title,
//           image: episode.imageUrl ?? podcast.image,
//           next: null,
//         ),
//       ),
//     );
//   }

//   @override
//   Future<List<QueueTrack>> getAll() async {
//     return await isar?.queueTracks.where().findAll() ?? [];
//   }

//   @override
//   Future<QueueTrack?> getItem(int id) async {
//     return await isar?.queueTracks.get(id);
//   }

//   @override
//   Future<int> removeItem(QueueTrack track) async {
//     var all = await getAll();
//     var index = all.indexWhere((t) => t.id == track.id);
//     await isar?.writeTxn(() async => isar?.queueTracks.delete(track.id));
//     return index;
//   }

//   @override
//   Future<void> clearAll() async {
//     await isar?.writeTxn(() async => isar?.queueTracks.clear());
//   }
// }

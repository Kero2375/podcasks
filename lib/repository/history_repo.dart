import 'package:collection/collection.dart';
import 'package:isar/isar.dart';
import 'package:podcasks/data/entities/podcast/podcast_entity.dart';
import 'package:podcasks/data/entities/save/save_track.dart';
import 'package:podcasks/data/entities/episode/podcast_episode.dart';
import 'package:podcast_search/podcast_search.dart';

abstract class HistoryRepo {
  Future<void> setPosition(
      MEpisode episode, MPodcast podcast, Duration? position, bool finished);

  Future<void> removeEpisode(MEpisode episode);

  (Duration, bool)? getPosition(MEpisode episode);

  // @Deprecated('Avoid fetching all saved episodes')
  Future<List<(MEpisode, MPodcast)>> getAllSaved();

  Future<(MEpisode, MPodcast)?> getLast();

  Future<void> setAllPositions(
      MPodcast podcast, Duration position, bool finished);

  Future<void> removeAll(MPodcast? podcast);
}

class HistoryRepoIsar extends HistoryRepo {
  Isar? get isar => Isar.getInstance();

  @override
  (Duration, bool)? getPosition(MEpisode episode) {
    final id = episode.contentUrl?.hashCode;
    if (id != null) {
      final saved = isar?.saveTracks.getSync(id);
      if (saved != null && saved.position != null) {
        return (Duration(seconds: saved.position!), saved.finished ?? false);
      }
    }
    return null;
  }

  @override
  Future<void> setPosition(
    MEpisode episode,
    MPodcast podcast,
    Duration? position,
    bool finished,
  ) async {
    final id = episode.contentUrl?.hashCode;
    if (id != null && position != null) {
      await isar?.writeTxn(
        () async => await isar?.saveTracks.put(
          SaveTrack(
            id: id,
            url: episode.contentUrl,
            position: position.inSeconds,
            podcastUrl: podcast.url,
            finished: finished,
            dateTime: DateTime.now(),
          ),
        ),
      );
    }
  }

  @override
  Future<List<(MEpisode, MPodcast)>> getAllSaved() async {
    final track = await isar?.saveTracks
        .where(sort: Sort.asc)
        .filter()
        .positionGreaterThan(0)
        .sortByDateTimeDesc()
        .findAll();
    List<(MEpisode, MPodcast)> episodes = [];

    for (SaveTrack t in track ?? []) {
      if (t.podcastUrl != null && t.url != null) {
        // FIXME
        final pod = await Podcast.loadFeed(url: t.podcastUrl!); //FIXME?
        final ep = pod.episodes.firstWhereOrNull((e) => e.contentUrl == t.url);
        if (ep != null) {
          episodes.add((MEpisode.fromEpisode(ep), MPodcast.fromPodcast(pod)));
        }
      }
    }
    return episodes;
  }

  @override
  Future<void> removeEpisode(MEpisode episode) async {
    final id = episode.contentUrl?.hashCode;
    if (id != null) {
      await isar?.writeTxn(
        () async => await isar?.saveTracks.delete(id),
      );
    }
  }

  @override
  Future<(MEpisode, MPodcast)?> getLast() async {
    final tracks =
        await isar?.saveTracks.where(sort: Sort.asc).sortByDateTime().findAll();
    final t = tracks?.last;
    return MEpisode.fromUrl(podcastUrl: t?.podcastUrl, episodeUrl: t?.url);
  }

  @override
  Future<void> removeAll(MPodcast? podcast) async {
    if (podcast != null) {
      await isar?.writeTxn(() async =>
          isar?.saveTracks.filter().podcastUrlEqualTo(podcast.url).deleteAll());
    }
  }

  @override
  Future<void> setAllPositions(
      MPodcast podcast, Duration position, bool finished) async {
    List<SaveTrack> tracks = [];
    final now = DateTime.now();
    for (var ep in podcast.episodes) {
      final id = ep.contentUrl?.hashCode;
      if (id != null) {
        tracks.add(SaveTrack(
          id: id,
          url: ep.contentUrl,
          position: position.inSeconds,
          podcastUrl: podcast.url,
          finished: finished,
          dateTime: now,
        ));
      }
    }

    await isar?.writeTxn(() async => isar?.saveTracks.putAll(tracks));
  }
}

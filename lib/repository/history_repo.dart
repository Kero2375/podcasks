import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podcasks/data/entities/save_track.dart';
import 'package:podcasks/data/podcast_episode.dart';
import 'package:podcast_search/podcast_search.dart';

abstract class HistoryRepo {
  Future<void> setPosition(
      PodcastEpisode episode, Duration? position, bool finished);

  Future<void> removeEpisode(PodcastEpisode episode);

  (Duration, bool)? getPosition(Episode episode);

  // @Deprecated('Avoid fetching all saved episodes')
  Future<List<PodcastEpisode>> getAllSaved();

  Future<PodcastEpisode?> getLast();

  Future<void> setAllPositions(
      Podcast podcast, Duration position, bool finished);

  Future<void> removeAll(Podcast? podcast);
}

class HistoryRepoIsar extends HistoryRepo {
  Isar? get isar => Isar.getInstance();

  @override
  (Duration, bool)? getPosition(Episode episode) {
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
      PodcastEpisode episode, Duration? position, bool finished) async {
    final id = episode.contentUrl?.hashCode;
    if (id != null && position != null) {
      await isar?.writeTxn(
        () async => await isar?.saveTracks.put(
          SaveTrack(
            id: id,
            url: episode.contentUrl,
            position: position.inSeconds,
            podcastUrl: episode.podcast?.url,
            finished: finished,
            dateTime: DateTime.now(),
          ),
        ),
      );
    }
  }

  @override
  Future<List<PodcastEpisode>> getAllSaved() async {
    final track = await isar?.saveTracks
        .where(sort: Sort.asc)
        .filter()
        .positionGreaterThan(0)
        .sortByDateTimeDesc()
        .findAll();
    List<PodcastEpisode> episodes = [];

    for (SaveTrack t in track ?? []) {
      if (t.podcastUrl != null && t.url != null) {
        final pod = await Podcast.loadFeed(url: t.podcastUrl!);
        final ep = pod.episodes.firstWhere((e) => e.contentUrl == t.url);
        episodes.add(PodcastEpisode.fromEpisode(ep, podcast: pod));
      }
    }
    return episodes;
  }

  @override
  Future<void> removeEpisode(PodcastEpisode episode) async {
    final id = episode.contentUrl?.hashCode;
    if (id != null) {
      await isar?.writeTxn(
        () async => await isar?.saveTracks.delete(id),
      );
    }
  }

  @override
  Future<PodcastEpisode?> getLast() async {
    final tracks =
        await isar?.saveTracks.where(sort: Sort.asc).sortByDateTime().findAll();
    final t = tracks?.last;
    return PodcastEpisode.fromUrl(
      podcastUrl: t?.podcastUrl,
      episodeUrl: t?.url,
    );
  }

  @override
  Future<void> removeAll(Podcast? podcast) async {
    if (podcast != null) {
      await isar?.writeTxn(() async =>
          isar?.saveTracks.filter().podcastUrlEqualTo(podcast.url).deleteAll());
    }
  }

  @override
  Future<void> setAllPositions(
      Podcast podcast, Duration position, bool finished) async {
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

import 'package:collection/collection.dart';
import 'package:isar/isar.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcasks/data/entities/save/save_track.dart';
import 'package:podcasks/locator.dart';
import 'package:podcasks/repository/favourites_repo.dart';
import 'package:podcasks/utils.dart';

abstract class HistoryRepo {
  Future<void> setPosition(
      Episode episode, Podcast podcast, Duration? remaining, Duration? duration);

  Future<void> removeEpisode(Episode episode);

  (Duration, Duration, bool)? getPosition(Episode episode);

  // @Deprecated('Avoid fetching all saved episodes')
  Future<List<(Episode, Podcast)>> getAllSaved();

  Future<(Episode, Podcast)?> getLast();

  Future<void> setAllPositions(
      Podcast podcast, Duration remaining);

  Future<void> removeAll(Podcast? podcast);
}

class HistoryRepoIsar extends HistoryRepo {
  Isar? get isar => Isar.getInstance();
  Future<List<Podcast>> get savedPod async =>
      await locator.get<FavouriteRepo>().getAllFavourites();

  int _generateId(Episode episode) {
    return (episode.guid.isNotEmpty
            ? episode.guid
            : (episode.contentUrl ?? episode.title))
        .hashCode;
  }

  @override
  (Duration, Duration, bool)? getPosition(Episode episode) {
    final id = _generateId(episode);
    final saved = isar?.saveTracks.getSync(id);
    if (saved != null && saved.position != null) {
      final remaining = Duration(seconds: saved.position!);
      final total = Duration(seconds: saved.duration ?? 0);
      // If stored position is 0, it was explicitly marked as finished
      final finished = (saved.position == 0) || isFinished(remaining);
      return (remaining, total, finished);
    }
    return null;
  }

  @override
  Future<void> setPosition(
    Episode episode,
    Podcast podcast,
    Duration? remaining,
    Duration? duration,
  ) async {
    final id = _generateId(episode);
    if (remaining != null) {
      // Use 0 to indicate it is finished
      final int pos = isFinished(remaining) ? 0 : remaining.inSeconds;
      await isar?.writeTxn(
        () async => await isar?.saveTracks.put(
          SaveTrack(
              id: id,
              url: episode.contentUrl,
              title: episode.title,
              position: pos,
              duration: duration?.inSeconds,
              podcastUrl: podcast.url,
              dateTime: DateTime.now(),
              podcast: (await savedPod)
                          .firstWhereOrNull((p) => p.title == podcast.title) !=
                      null
                  ? null
                  : podcast),
        ),
      );
    }
  }

  @override
  Future<List<(Episode, Podcast)>> getAllSaved() async {
    final track = await isar?.saveTracks
        .where(sort: Sort.asc)
        .filter()
        .positionGreaterThan(0)
        .sortByDateTimeDesc()
        .findAll();
    List<(Episode, Podcast)> episodes = [];

    for (SaveTrack t in track ?? []) {
      if (t.podcastUrl != null && t.url != null) {
        final Podcast pod =
            (await savedPod).firstWhereOrNull((p) => p.url == t.podcastUrl) ??
                t.podcast ??
                await Feed.loadFeed(url: t.podcastUrl!);

        final ep =
            pod.episodes.firstWhereOrNull((e) => e.contentUrl == t.url) ??
                pod.episodes.firstWhereOrNull((e) => e.title == t.title);

        if (ep != null) {
          episodes.add((ep, pod));
        }
      }
    }

    return episodes;
  }

  @override
  Future<void> removeEpisode(Episode episode) async {
    final id = _generateId(episode);
    await isar?.writeTxn(
      () async => await isar?.saveTracks.delete(id),
    );
  }

  @override
  Future<(Episode, Podcast)?> getLast() async {
    final tracks =
        await isar?.saveTracks.where(sort: Sort.asc).sortByDateTime().findAll();
    final t = tracks?.last;
    if (t?.podcastUrl != null && t?.url != null) {
      final pod = await Feed.loadFeed(url: t!.podcastUrl!);
      final ep = pod.episodes.firstWhereOrNull((e) => e.contentUrl == t.url);
      if (ep != null) {
        return (ep, pod);
      }
    }
    return null;
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
      Podcast podcast, Duration remaining) async {
    List<SaveTrack> tracks = [];
    final now = DateTime.now();
    final int pos = isFinished(remaining) ? 0 : remaining.inSeconds;
    for (var ep in podcast.episodes) {
      final id = _generateId(ep);
      tracks.add(SaveTrack(
          id: id,
          url: ep.contentUrl,
          title: ep.title,
          position: pos,
          duration: ep.duration?.inSeconds,
          podcastUrl: podcast.url,
          dateTime: now,
          podcast: (await savedPod)
                      .firstWhereOrNull((p) => p.title == podcast.title) !=
                  null
              ? null
              : podcast));
    }

    await isar?.writeTxn(() async => isar?.saveTracks.putAll(tracks));
  }
}

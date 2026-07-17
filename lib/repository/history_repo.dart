import 'package:collection/collection.dart';
import 'package:isar_community/isar.dart';
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
  Future<List<(Episode, Podcast)>> getAllSaved({int? limit});

  Future<(Episode, Podcast)?> getLast();

  Future<void> setAllPositions(
      Podcast podcast, Duration remaining);

  Future<void> removeAll(Podcast? podcast);

  Future<List<int>> getFinishedIds(String podcastUrl);
}

class HistoryRepoIsar extends HistoryRepo {
  Isar? get isar => Isar.getInstance();
  Future<List<Podcast>> get savedPod async =>
      await locator.get<FavouriteRepo>().getAllFavourites();

  @override
  Future<List<int>> getFinishedIds(String podcastUrl) async {
    final finished = await isar?.saveTracks
        .filter()
        .podcastUrlEqualTo(podcastUrl)
        .positionEqualTo(0)
        .findAll();
    return finished?.map((e) => e.id).toList() ?? [];
  }

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
  Future<List<(Episode, Podcast)>> getAllSaved({int? limit}) async {
    final trackQuery = isar?.saveTracks
        .where(sort: Sort.asc)
        .filter()
        .positionGreaterThan(0)
        .sortByDateTimeDesc();
    
    final track = limit != null 
        ? await trackQuery?.limit(limit).findAll()
        : await trackQuery?.findAll();

    List<(Episode, Podcast)> episodes = [];
    final allSavedPod = await savedPod;
    final Map<String, Podcast> cachedFeeds = {};

    for (SaveTrack t in track ?? []) {
      if (t.podcastUrl != null && t.url != null) {
        Podcast? finalPod =
            allSavedPod.firstWhereOrNull((p) => p.url == t.podcastUrl) ??
                t.podcast ??
                cachedFeeds[t.podcastUrl!];

        // If not in favorites or stored in track or cache, we need to load it
        if (finalPod == null) {
          try {
            finalPod = await Feed.loadFeed(url: t.podcastUrl!);
            cachedFeeds[t.podcastUrl!] = finalPod;
          } catch (e) {
            continue;
          }
        }

        final ep =
            finalPod.episodes.firstWhereOrNull((e) => e.contentUrl == t.url) ??
                finalPod.episodes.firstWhereOrNull((e) => e.title == t.title);

        if (ep != null) {
          episodes.add((ep, finalPod));
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
    final t = tracks?.lastOrNull;
    if (t?.podcastUrl != null && t?.url != null) {
      final allSavedPod = await savedPod;
      final pod = allSavedPod.firstWhereOrNull((p) => p.url == t!.podcastUrl) ?? 
                  t!.podcast ?? 
                  await Feed.loadFeed(url: t!.podcastUrl!);
                  
      final ep = pod.episodes.firstWhereOrNull((e) => e.contentUrl == t!.url) ??
                 pod.episodes.firstWhereOrNull((e) => e.title == t!.title);
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
    final allSavedPod = await savedPod;
    final bool isPodcastSaved = allSavedPod.any((p) => p.title == podcast.title);

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
          podcast: isPodcastSaved ? null : podcast));
    }

    await isar?.writeTxn(() async => isar?.saveTracks.putAll(tracks));
  }
}

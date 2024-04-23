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

  @Deprecated('Avoid fetching all saved episodes')
  Future<List<PodcastEpisode>> getAllSaved();
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
              finished: finished),
        ),
      );
    }
  }

  @override
  Future<List<PodcastEpisode>> getAllSaved() async {
    final track =
        await isar?.saveTracks.filter().positionGreaterThan(0).findAll();
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
}

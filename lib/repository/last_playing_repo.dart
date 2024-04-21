import 'package:collection/collection.dart';
import 'package:podcasks/data/podcast_episode.dart';
import 'package:podcasks/locator.dart';
import 'package:podcasks/repository/search_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LastPlayingRepo {
  Future<void> setLastPlaying(PodcastEpisode? episode);

  Future<PodcastEpisode?> getLastPlaying();
}

class LastPlayingRepoSharedPrefs extends LastPlayingRepo {
  static const String lastPlayingPodcastKey = 'playing_podcast_sp_key';
  static const String lastPlayingEpisodeKey = 'playing_episode_sp_key';
  // static const String positionsKey = 'positions_sp_key';
  // static const String episodesKey = 'episodes_sp_key';

  Future<SharedPreferences> get _getSp async =>
      await SharedPreferences.getInstance();
  final SearchRepo _searchRepo = locator.get<SearchRepo>();

  @override
  Future<PodcastEpisode?> getLastPlaying() async {
    final sp = await _getSp;
    final episodeUrl = sp.getString(lastPlayingEpisodeKey);
    final podcastUrl = sp.getString(lastPlayingPodcastKey);

    if (episodeUrl != null && podcastUrl != null ) {
      final podcast = await _searchRepo.fetchPodcast(podcastUrl);
      final episode = podcast?.episodes
          .firstWhereOrNull((element) => element.contentUrl == episodeUrl);
      if (episode != null) {
        return PodcastEpisode.fromEpisode(episode, podcast: podcast);
      }
    }
    return null;
  }

  @override
  Future<void> setLastPlaying(PodcastEpisode? episode) async {
    final sp = await _getSp;
    if (episode?.contentUrl != null) {
      await sp.setString(lastPlayingEpisodeKey, episode!.contentUrl!);
      await sp.setString(lastPlayingPodcastKey, episode.podcast!.url ?? '');
    }
  }

  // _removeFromList(SharedPreferences sp, String key, String value) async {
  //   //todo
  //   final list = sp.getStringList(key) ?? [];
  //   if (list.remove(value)) {
  //     sp.setStringList(key, list);
  //   }
  // }

  // @override
  // Future<Duration?> getLastPositionByEpisode(Episode episode) async {
  //   final sp = await _getSp;
  //   final episodes = sp.getStringList(episodesKey);
  //   final position = sp.getStringList(positionsKey);
  //   if (episodes?.contains(episode.contentUrl) == true) {
  //     final index = episodes!.lastIndexOf(episode.contentUrl!);
  //     final sec = int.tryParse(position?[index] ?? '');
  //     if (sec != null) return Duration(seconds: sec);
  //   }
  //   return null;
  // }

  // @override
  // Future<void> setLastPlaying(PodcastEpisode? track, Duration? position) async {
  //   final sp = await _getSp;
  //   if (track?.contentUrl != null) {
  //     final eps = sp.getStringList(episodesKey) ?? [];
  //     final secs = sp.getStringList(positionsKey) ?? [];

  //     if (eps.contains(track!.contentUrl!) == true) {
  //       secs[eps.indexOf(track.contentUrl!)] =
  //           position?.inSeconds.toString() ?? '';
  //       await sp.setStringList(positionsKey, secs);
  //     } else {
  //       eps.add(track.contentUrl!);
  //       secs.add(position?.inSeconds.toString() ?? '');
  //       await sp.setStringList(episodesKey, eps);
  //       await sp.setStringList(positionsKey, secs);
  //     }
  //     await sp.setString(lastPlayingEpisodeKey, track.contentUrl!);
  //     await sp.setString(lastPlayingPodcastKey, track.podcast?.url ?? '');
  //   }
  // }

  // @override
  // Future<(PodcastEpisode, Duration)?> getLastPlaying() async {
  //   final sp = await _getSp;
  //   String? episodeId = sp.getString(lastPlayingEpisodeKey);
  //   String? podcastUrl = sp.getString(lastPlayingPodcastKey);

  //   if (episodeId != null && podcastUrl != null) {
  //     final podcast = await _searchRepo.fetchPodcast(podcastUrl);
  //     final episode = podcast?.episodes
  //         .firstWhereOrNull((element) => element.contentUrl == episodeId);
  //     if (episode == null) return null;
  //     final track = PodcastEpisode.fromEpisode(episode, podcast: podcast);
  //     final eps = sp.getStringList(episodesKey);
  //     final secs = sp.getStringList(positionsKey);

  //     String? sec;
  //     if (eps?.contains(track.contentUrl) == true) {
  //       sec = secs?[eps?.lastIndexOf(track.contentUrl!) ?? 0];
  //     }

  //     print("SEC $sec ============> $secs");

  //     final position = sec != null
  //         ? Duration(seconds: int.tryParse(sec) ?? 0)
  //         : Duration.zero;
  //     return (track, position);
  //   }
  //   return null;
  // }
}

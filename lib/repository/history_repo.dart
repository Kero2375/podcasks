import 'package:collection/collection.dart';
import 'package:podcasks/data/podcast_episode.dart';
import 'package:podcasks/data/track.dart';
import 'package:podcasks/locator.dart';
import 'package:podcasks/repository/search_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class HistoryRepo {
  Future<void> setPlaying(Track? track);

  Future<Track?> getPlaying();

  Future<void> setPosition(Duration? position);

  Future<Duration?> getPosition();
}

class HistoryRepoSharedPrefs extends HistoryRepo {
  static const String playingPodcastKey = 'playing_podcast_sp_key';
  static const String playingEpisodeKey = 'playing_episode_sp_key';
  static const String positionKey = 'position_sp_key';

  Future<SharedPreferences> get _getSp async =>
      await SharedPreferences.getInstance();
  final SearchRepo _searchRepo = locator.get<SearchRepo>();

  @override
  Future<Track?> getPlaying() async {
    final sp = await _getSp;
    String? episodeId = sp.getString(playingEpisodeKey);
    String? podcastUrl = sp.getString(playingPodcastKey);
    if (episodeId != null && podcastUrl != null) {
      final podcast = await _searchRepo.fetchPodcast(podcastUrl);
      final episode = podcast?.episodes
          .firstWhereOrNull((element) => element.guid == episodeId);
      if (episode == null) return null;
      return Track(
          url: episode.contentUrl,
          episode: PodcastEpisode.fromEpisode(episode, podcast: podcast),
          podcast: podcast);
    }
    return null;
  }

  @override
  Future<Duration?> getPosition() async {
    final sp = await _getSp;
    final pos = sp.getInt(positionKey);
    return pos != null ? Duration(seconds: pos) : null;
  }

  @override
  Future<void> setPlaying(Track? track) async {
    final sp = await _getSp;
    if (track?.episode?.guid != null && track?.podcast?.url != null) {
      await sp.setString(playingEpisodeKey, track!.episode!.guid);
      await sp.setString(playingPodcastKey, track.podcast!.url!);
    }
  }

  @override
  Future<void> setPosition(Duration? position) async {
    final sp = await _getSp;
    if (position != null) {
      await sp.setInt(positionKey, position.inSeconds);
    }
  }
}

import 'package:podcast_search/podcast_search.dart';
import 'package:podcasks/data/podcast_episode.dart';

class Track {
  final Podcast? podcast;
  final String? url;
  final PodcastEpisode? episode;

  Track({
    required this.url,
    required this.episode,
    required this.podcast,
  });
}

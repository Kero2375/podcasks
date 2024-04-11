import 'package:podcast_search/podcast_search.dart';

class Track {
  final Podcast? podcast;
  final String? url;
  final Episode? episode;

  Track({
    required this.url,
    required this.episode,
    required this.podcast,
  });
}

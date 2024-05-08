import 'package:isar/isar.dart';
import 'package:podcast_search/podcast_search.dart';

part 'podcast_entity.g.dart';

@embedded
class PodcastEntity {
  final String? title;
  final String? image;
  final String? url;

  PodcastEntity({
    this.title,
    this.image,
    this.url,
  });

  factory PodcastEntity.fromPodcast(Podcast? podcast) {
    if (podcast != null && podcast.url != null) {
      return PodcastEntity(
        title: podcast.title,
        image: podcast.image,
        url: podcast.url!,
      );
    } else {
      return PodcastEntity();
    }
  }

  Future<Podcast?> getPodcast() async => url != null
      ? Podcast.loadFeed(url: url!) // FIXME: slow! -> cache items!
      : null;

  static Future<PodcastEntity> fromUrl(String feedUrl) async {
    final podcast = await Podcast.loadFeed(url: feedUrl);
    return PodcastEntity.fromPodcast(podcast);
  }
}

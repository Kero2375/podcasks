// ignore_for_file: implementation_imports

import 'package:isar/isar.dart';
import 'package:podcasks/data/entities/episode/podcast_episode.dart';
import 'package:podcast_search/podcast_search.dart';
part 'podcast_entity.g.dart';

@embedded
class MPodcast {
  final String? guid;
  final String? url;
  final String? link;
  final String? title;
  final String? description;
  final String? image;
  final String? copyright;
  // final Locked? locked;
  // final List<Funding> funding;
  // final List<Person> persons;
  final List<MEpisode> episodes;

  const MPodcast({
    this.guid,
    this.url,
    this.link,
    this.title,
    this.description,
    this.image,
    this.copyright,
    // this.locked,
    // this.funding = const <Funding>[],
    // this.persons = const <Person>[],
    this.episodes = const <MEpisode>[],
  });

  factory MPodcast.fromPodcast(Podcast? podcast) {
    return MPodcast(
      guid: podcast?.guid,
      url: podcast?.url,
      link: podcast?.link,
      title: podcast?.title,
      description: podcast?.description,
      image: podcast?.image,
      copyright: podcast?.copyright,
      // locked: podcast?.locked,
      // funding: podcast?.funding ?? const <Funding>[],
      // persons: podcast?.persons ?? const <Person>[],
      episodes:
          podcast?.episodes.map((e) => MEpisode.fromEpisode(e)).toList() ??
              const <MEpisode>[],
    );
  }

  Future<Podcast?> getPodcast() async =>
      url != null ? Podcast.loadFeed(url: url!) : null;

  static Future<MPodcast> fromUrl(String feedUrl) async {
    final podcast = await Podcast.loadFeed(url: feedUrl);
    return MPodcast.fromPodcast(podcast);
  }
}

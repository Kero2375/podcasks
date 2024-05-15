import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:podcasks/data/entities/podcast/podcast_entity.dart';
import 'package:podcasks/utils.dart';
import 'package:podcast_search/podcast_search.dart';

part 'podcast_episode.g.dart';

@embedded
class MEpisode {
  // MPodcast? podcast;
  final String guid;
  final String title;
  final String description;
  String? link;
  final DateTime? publicationDate;
  String? contentUrl;
  String? imageUrl;
  String? author;
  int? season;
  int? episode;
  String? content;
  final int? durationSec;
  // final Chapters? chapters;
  // final List<TranscriptUrl> transcripts;
  // final List<Person> persons;

  @ignore
  Duration get duration => Duration(seconds: durationSec ?? 0);

  // MPodcast? podcast(List<MPodcast> choices) =>
  //     choices.firstWhereOrNull((e) => e.episodes.contains(this));

  MEpisode({
    this.guid = '',
    this.title = '',
    this.description = '',
    this.link = '',
    this.publicationDate,
    this.author = '',
    this.durationSec,
    this.contentUrl,
    this.imageUrl,
    this.season,
    this.episode,
    this.content,
    // this.chapters,
    // this.transcripts = const [],
    // this.persons = const [],
    // this.podcast,
  });

  factory MEpisode.fromEpisode(Episode ep) {
    return MEpisode(
      guid: ep.guid,
      title: ep.title,
      description: ep.description,
      link: ep.link,
      publicationDate: ep.publicationDate,
      author: ep.author,
      durationSec: ep.duration?.inSeconds ?? 0,
      contentUrl: ep.contentUrl,
      imageUrl: ep.imageUrl,
      season: ep.season,
      episode: ep.episode,
      content: ep.content,
      // chapters: ep.chapters,
      // transcripts: ep.transcripts,
      // persons: ep.persons,
      // podcast: podcast,
    );
  }

  Episode toEpisode() {
    return Episode(
      guid: guid,
      title: title,
      description: description,
      link: link,
      publicationDate: publicationDate,
      author: author,
      duration: duration,
      contentUrl: content,
      imageUrl: imageUrl,
      season: season,
      episode: episode,
      content: content,
      // chapters: chapters,
      // transcripts: transcripts,
      // persons: persons,
    );
  }

  @override
  bool operator ==(other) {
    return other is MEpisode && contentUrl == other.contentUrl;
  }

  @override
  int get hashCode => (contentUrl).hashCode;

  static Future<(MEpisode, MPodcast)?> fromUrl({
    String? podcastUrl,
    String? episodeUrl,
  }) async {
    if (podcastUrl != null && episodeUrl != null) {
      final pod = await Podcast.loadFeed(url: podcastUrl);
      final mPod = MPodcast.fromPodcast(pod);
      final ep =
          pod.episodes.firstWhereOrNull((e) => e.contentUrl == episodeUrl);
      if (ep != null) {
        return (MEpisode.fromEpisode(ep), mPod);
      }
    }
    return null;
  }
}

Map<String, String> itunesGenres(BuildContext context) => {
      'All': context.l10n!.all,
      'Arts': context.l10n!.arts,
      'Business': context.l10n!.business,
      'Comedy': context.l10n!.comedy,
      'Education': context.l10n!.education,
      'Fiction': context.l10n!.fiction,
      'Government': context.l10n!.government,
      'Health & Fitness': context.l10n!.healthFitness,
      'History': context.l10n!.history,
      'Kids & Family': context.l10n!.kidsFamily,
      'Leisure': context.l10n!.leisure,
      'Music': context.l10n!.music,
      'News': context.l10n!.news,
      'Religion & Spirituality': context.l10n!.religionSpirituality,
      'Science': context.l10n!.science,
      'Society & Culture': context.l10n!.societyCulture,
      'Sports': context.l10n!.sports,
      'TV & Film': context.l10n!.tvFilm,
      'Technology': context.l10n!.technology,
      'True Crime': context.l10n!.trueCrime,
    };

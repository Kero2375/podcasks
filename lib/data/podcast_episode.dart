import 'package:flutter/cupertino.dart';
import 'package:podcasks/utils.dart';
import 'package:podcast_search/podcast_search.dart';

class PodcastEpisode extends Episode {
  Podcast? podcast;

  PodcastEpisode({
    required super.guid,
    required super.title,
    required super.description,
    super.link = '',
    super.publicationDate,
    super.author = '',
    super.duration,
    super.contentUrl,
    super.imageUrl,
    super.season,
    super.episode,
    super.content,
    super.chapters,
    super.transcripts,
    super.persons,
    this.podcast,
  });

  factory PodcastEpisode.fromEpisode(Episode ep, {Podcast? podcast}) {
    return PodcastEpisode(
      guid: ep.guid,
      title: ep.title,
      description: ep.description,
      link: ep.link,
      publicationDate: ep.publicationDate,
      author: ep.author,
      duration: ep.duration,
      contentUrl: ep.contentUrl,
      imageUrl: ep.imageUrl,
      season: ep.season,
      episode: ep.episode,
      content: ep.content,
      chapters: ep.chapters,
      transcripts: ep.transcripts,
      persons: ep.persons,
      podcast: podcast,
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
      chapters: chapters,
      transcripts: transcripts,
      persons: persons,
    );
  }

  @override
  bool operator ==(other) {
    return other is PodcastEpisode && contentUrl == other.contentUrl;
  }

  @override
  int get hashCode => (contentUrl).hashCode;
}

Map<String, String> itunesGenres(BuildContext context) => {
  'All': context.l10n!.all,
  'Arts': context.l10n!.arts ,
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

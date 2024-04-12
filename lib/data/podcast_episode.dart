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
}

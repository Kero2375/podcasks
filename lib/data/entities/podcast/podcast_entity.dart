import 'dart:convert';
import 'package:podcast_search/podcast_search.dart';

class PodcastConverter {
  static String serialize(Podcast object) {
    return jsonEncode({
      'guid': object.guid,
      'url': object.url,
      'link': object.link,
      'title': object.title,
      'description': object.description,
      'image': object.image,
      'copyright': object.copyright,
      'episodes': object.episodes.map((e) => EpisodeConverter.toMap(e)).toList(),
    });
  }

  static Podcast deserialize(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return Podcast(
      guid: json['guid'],
      url: json['url'],
      link: json['link'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      copyright: json['copyright'],
      episodes: (json['episodes'] as List? ?? [])
          .map((e) => EpisodeConverter.fromMap(e))
          .toList(),
    );
  }
}

class EpisodeConverter {
  static Map<String, dynamic> toMap(Episode object) {
    return {
      'guid': object.guid,
      'title': object.title,
      'description': object.description,
      'link': object.link,
      'publicationDate': object.publicationDate?.toIso8601String(),
      'author': object.author,
      'duration': object.duration?.inSeconds,
      'contentUrl': object.contentUrl,
      'imageUrl': object.imageUrl,
      'season': object.season,
      'episode': object.episode,
      'content': object.content,
      'length': object.length,
    };
  }

  static Episode fromMap(Map<String, dynamic> json) {
    return Episode(
      guid: json['guid'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      link: json['link'] ?? '',
      publicationDate: json['publicationDate'] != null
          ? DateTime.parse(json['publicationDate'])
          : null,
      author: json['author'] ?? '',
      duration: json['duration'] != null
          ? Duration(seconds: json['duration'])
          : null,
      contentUrl: json['contentUrl'],
      imageUrl: json['imageUrl'],
      season: json['season'],
      episode: json['episode'],
      content: json['content'],
      length: json['length'] ?? 0,
    );
  }
}

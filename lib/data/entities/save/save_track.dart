import 'package:isar/isar.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcasks/data/entities/podcast/podcast_entity.dart';
part 'save_track.g.dart';

@collection
class SaveTrack {
  Id id = Isar.autoIncrement;
  String? url;
  String? title;
  String? podcastUrl;
  DateTime dateTime;
  int? position;
  int? duration;

  String? podcastJson;

  @ignore
  Podcast? _podcast;

  @ignore
  Podcast? get podcast {
    if (_podcast == null && podcastJson != null) {
      _podcast = PodcastConverter.deserialize(podcastJson!);
    }
    return _podcast;
  }

  set podcast(Podcast? p) {
    _podcast = p;
    podcastJson = p != null ? PodcastConverter.serialize(p) : null;
  }

  SaveTrack({
    this.id = Isar.autoIncrement,
    this.url,
    this.title,
    this.position,
    this.duration,
    this.podcastUrl,
    required this.dateTime,
    Podcast? podcast,
  }) {
    if (podcast != null) {
      this.podcast = podcast;
    }
  }
}

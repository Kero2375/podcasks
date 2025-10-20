import 'package:isar/isar.dart';
import 'package:podcasks/data/entities/episode/podcast_episode.dart';
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
  bool? finished;
  MPodcast? podcast;

  SaveTrack({
    required this.id,
    required this.url,
    required this.title,
    required this.position,
    required this.podcastUrl,
    required this.finished,
    required this.dateTime,
    required this.podcast,
  });
}

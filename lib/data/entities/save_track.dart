import 'package:isar/isar.dart';
part 'save_track.g.dart';

@collection
class SaveTrack {
  Id id = Isar.autoIncrement;
  String? url;
  String? podcastUrl;
  int? position;
  bool? finished;

  SaveTrack({
    required this.id,
    required this.url,
    required this.position,
    required this.podcastUrl,
    required this.finished,
  });
}

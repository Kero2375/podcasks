import 'package:isar/isar.dart';
part 'queue_track.g.dart';

@collection
class QueueTrack {
  Id id = Isar.autoIncrement;
  String? url;
  String? podcastUrl;
  String? title;
  String? image;
  int? next;

  QueueTrack({
    required this.id,
    required this.url,
    required this.podcastUrl,
    required this.title,
    this.image,
    this.next,
  });
}

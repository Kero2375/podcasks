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
    required this.url,
    required this.podcastUrl,
    required this.title,
    required this.image,
    required this.next,
  });
}

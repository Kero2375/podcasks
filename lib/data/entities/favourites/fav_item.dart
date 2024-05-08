import 'package:isar/isar.dart';
import 'package:podcasks/data/entities/podcast/podcast_entity.dart';
part 'fav_item.g.dart';

@collection
class Favourite {
  Id id = Isar.autoIncrement;
  PodcastEntity? podcast;

  Favourite({
    required this.id,
    required this.podcast,
  });
}

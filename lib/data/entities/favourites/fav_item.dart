import 'package:isar/isar.dart';
import 'package:podcasks/data/entities/episode/podcast_episode.dart';
import 'package:podcasks/data/entities/podcast/podcast_entity.dart';
part 'fav_item.g.dart';

@collection
class Favourite {
  Id id = Isar.autoIncrement;
  MPodcast podcast;

  Favourite({
    required this.id,
    required this.podcast,
  });
}

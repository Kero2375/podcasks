import 'package:isar/isar.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcasks/data/entities/podcast/podcast_entity.dart';
part 'fav_item.g.dart';

@collection
class Favourite {
  Id id = Isar.autoIncrement;

  late String podcastJson;

  @ignore
  Podcast get podcast => PodcastConverter.deserialize(podcastJson);
  set podcast(Podcast p) => podcastJson = PodcastConverter.serialize(p);

  Favourite({
    this.id = Isar.autoIncrement,
  });
}

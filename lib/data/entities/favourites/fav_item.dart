import 'package:isar_community/isar.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcasks/data/entities/podcast/podcast_entity.dart';
part 'fav_item.g.dart';

@collection
class Favourite {
  Id id = Isar.autoIncrement;

  late String podcastJson;

  String? lastModified;
  String? eTag;
  int? contentLength;

  @ignore
  Podcast? _podcast;

  @ignore
  Podcast get podcast {
    _podcast ??= PodcastConverter.deserialize(podcastJson);
    return _podcast!;
  }

  set podcast(Podcast p) {
    _podcast = p;
    podcastJson = PodcastConverter.serialize(p);
  }

  Favourite({
    this.id = Isar.autoIncrement,
  });
}

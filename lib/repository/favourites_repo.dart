import 'package:isar/isar.dart';
import 'package:podcasks/data/entities/favourites/fav_item.dart';
import 'package:podcasks/data/entities/podcast/podcast_entity.dart';

abstract class FavouriteRepo {
  Future<bool> addToFavourite(PodcastEntity podcast);

  Future<List<PodcastEntity>> getAllFavourites();

  Future<void> removeFromFavourite(String feedUrl);
}

// todo: replace with isar?
class FavouriteRepoIsar extends FavouriteRepo {
  Isar? get isar => Isar.getInstance();

  @override
  Future<bool> addToFavourite(PodcastEntity podcast) async {
    if (isar?.favourites.get(podcast.url.hashCode) != null) return false;
    await isar?.writeTxn(
      () async => isar?.favourites.put(
        Favourite(
          id: podcast.url.hashCode,
          podcast: podcast,
        ),
      ),
    );
    return true;
  }

  @override
  Future<List<PodcastEntity>> getAllFavourites() async {
    final all = await isar?.favourites.where().findAll();
    return all
            ?.where((e) => e.podcast != null)
            .map((e) => e.podcast!)
            .toList() ??
        [];
  }

  @override
  Future<void> removeFromFavourite(String feedUrl) async {
    await isar?.writeTxn(
      () async => isar?.favourites.delete(feedUrl.hashCode),
    );
  }
}

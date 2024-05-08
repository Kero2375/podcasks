import 'package:isar/isar.dart';
import 'package:podcasks/data/entities/fav_item.dart';

abstract class FavouriteRepo {
  Future<bool> addToFavourite(String feedUrl);

  Future<List<String>> getAllFavourites();

  Future<void> removeFromFavourite(String feedUrl);
}

// todo: replace with isar?
class FavouriteRepoIsar extends FavouriteRepo {
  Isar? get isar => Isar.getInstance();

  @override
  Future<bool> addToFavourite(String feedUrl) async {
    if (isar?.favourites.get(feedUrl.hashCode) != null) return false;
    isar?.writeTxn(
      () async => isar?.favourites.put(
        Favourite(id: feedUrl.hashCode, url: feedUrl),
      ),
    );
    return true;
  }

  @override
  Future<List<String>> getAllFavourites() async {
    final all = await isar?.favourites.where().findAll();
    return all?.where((e) => e.url != null).map((e) => e.url!).toList() ?? [];
  }

  @override
  Future<void> removeFromFavourite(String feedUrl) async {
    isar?.writeTxn(() async => isar?.favourites.delete(feedUrl.hashCode));
  }
}

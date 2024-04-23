import 'package:shared_preferences/shared_preferences.dart';

abstract class FavouriteRepo {
  Future<void> addToFavourite(String feedUrl);

  Future<List<String>> getAllFavourites();

  Future<void> removeFromFavourite(String feedUrl);
}

// todo: replace with isar?
class FavouriteRepoSharedPref extends FavouriteRepo {
  static const String favKey = 'favourites_sp_key';

  Future<SharedPreferences> get _getSp async =>
      await SharedPreferences.getInstance();

  @override
  Future<void> addToFavourite(String feedUrl) async {
    final sp = await _getSp;
    final list = ((sp.getStringList(favKey)) ?? []) + [feedUrl];
    await sp.setStringList(favKey, list);
  }

  @override
  Future<List<String>> getAllFavourites() async {
    final sp = await _getSp;
    return sp.getStringList(favKey) ?? [];
  }

  @override
  Future<void> removeFromFavourite(String feedUrl) async {
    final sp = await _getSp;
    final list = sp.getStringList(favKey) ?? [];
    list.remove(feedUrl);
    await sp.setStringList(favKey, list);
  }
}

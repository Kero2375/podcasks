
import 'package:get_it/get_it.dart';
import 'package:ppp2/repository/favourites_repo.dart';
import 'package:ppp2/repository/podcast_repo.dart';
import 'package:ppp2/repository/search_repo.dart';

final locator = GetIt.instance;

void setup() {
  // todo
  locator.registerSingleton<SearchRepo>(SearchRepoPodcastSearch());
  locator.registerSingleton<FavouriteRepo>(FavouriteRepoSharedPref());
}
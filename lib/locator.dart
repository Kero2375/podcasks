import 'package:get_it/get_it.dart';
import 'package:podcasks/repository/favourites_repo.dart';
import 'package:podcasks/repository/history_repo.dart';
import 'package:podcasks/repository/last_playing_repo.dart';
import 'package:podcasks/repository/prefs_repo.dart';
import 'package:podcasks/repository/search_repo.dart';

final locator = GetIt.instance;

void setup() {
  locator.registerSingleton<SearchRepo>(SearchRepoPodcastSearch());
  locator.registerSingleton<FavouriteRepo>(FavouriteRepoSharedPref());
  locator.registerSingleton<LastPlayingRepo>(LastPlayingRepoSharedPrefs());
  locator.registerSingleton<PrefsRepo>(PrefsRepoSharedPref());
  locator.registerSingleton<HistoryRepo>(HistoryRepoIsar());
}

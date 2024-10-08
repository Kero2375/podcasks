import 'package:get_it/get_it.dart';
import 'package:podcasks/repository/favourites_repo.dart';
import 'package:podcasks/repository/history_repo.dart';
import 'package:podcasks/repository/prefs_repo.dart';
import 'package:podcasks/repository/queue_repo.dart';
import 'package:podcasks/repository/search_repo.dart';

final locator = GetIt.instance;

void setup() {
  locator.registerSingleton<SearchRepo>(SearchRepoPodcastSearch());
  locator.registerSingleton<FavouriteRepo>(FavouriteRepoIsar());
  locator.registerSingleton<PrefsRepo>(PrefsRepoSharedPref());
  locator.registerSingleton<HistoryRepo>(HistoryRepoIsar());
  locator.registerSingleton<QueueRepo>(QueueRepoAudioHandler());
}

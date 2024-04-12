import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:ppp2/data/track.dart';
import 'package:ppp2/locator.dart';
import 'package:ppp2/repository/favourites_repo.dart';
import 'package:ppp2/repository/history_repo.dart';
import 'package:ppp2/ui/vms/vm.dart';

final homeViewmodel = ChangeNotifierProvider((ref) => HomeViewmodel());

class HomeViewmodel extends Vm {
  final _favRepo = locator.get<FavouriteRepo>();
  final _historyRepo = locator.get<HistoryRepo>();

  List<Podcast> get favourites => _favourites;
  List<Podcast> _favourites = [];

  HomeViewmodel() {
    fetchFavourites();
  }

  Future<List<Podcast>> fetchFavourites() async {
    loading();
    final favFeeds = await _favRepo.getAllFavourites();
    List<Podcast> list = [];
    for (var value in favFeeds) {
      list.add(await Podcast.loadFeed(url: value));
    }
    _favourites = list;
    success();
    return _favourites;
  }

  Future<void> setFavourite(Podcast podcast, bool setFavourite) async {
    loading();
    if (podcast.url != null) {
      if (setFavourite) {
        _favRepo.addToFavourite(podcast.url!);
      } else {
        _favRepo.removeFromFavourite(podcast.url!);
      }
    }
    await fetchFavourites();
  }

  bool isFavourite(Podcast? podcast) {
    return _favourites.firstWhereOrNull((element) => element.url == podcast?.url) != null;
  }

  Future<Track?> getLastSavedTrack() => _historyRepo.getPlaying();

  Future<Duration?> getLastSavedPosition() => _historyRepo.getPosition();

  Future<void> saveTrack(Track? track) => _historyRepo.setPlaying(track);

  Future<void> savePosition(Duration? position) => _historyRepo.setPosition(position);
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:ppp2/locator.dart';
import 'package:ppp2/repository/favourites_repo.dart';
import 'package:ppp2/ui/vms/vm.dart';
import 'package:collection/collection.dart';

final homeViewmodel = ChangeNotifierProvider((ref) => HomeViewmodel());

class HomeViewmodel extends Vm {
  final _favRepo = locator.get<FavouriteRepo>();

  List<Podcast> _favourites = [];

  List<Podcast> get favourites => _favourites;

  HomeViewmodel() {
    getFavourites();
  }

  Future<List<Podcast>> getFavourites() async {
    final favFeeds = await _favRepo.getAllFavourites();
    List<Podcast> list = [];
    for (var value in favFeeds) {
      list.add(await Podcast.loadFeed(url: value));
    }
    _favourites = list;
    notifyListeners();
    return _favourites;
  }

  Future<void> setFavourite(Podcast podcast, bool setFavourite) async {
    loading();
    if (podcast.url != null) {
      if (setFavourite) {
        await _favRepo.addToFavourite(podcast.url!);
      } else {
        await _favRepo.removeFromFavourite(podcast.url!);
      }
    }
    getFavourites();
    success();
  }

  bool isFavourite(Podcast? podcast) {
    return _favourites.firstWhereOrNull((element) => element.url == podcast?.url) != null;
  }
}

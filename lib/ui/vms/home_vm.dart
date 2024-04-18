import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/data/podcast_episode.dart';
import 'package:podcasks/repository/history_repo.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcasks/locator.dart';
import 'package:podcasks/repository/favourites_repo.dart';
import 'package:podcasks/repository/last_playing_repo.dart';
import 'package:podcasks/ui/vms/vm.dart';

final homeViewmodel = ChangeNotifierProvider((ref) => HomeViewmodel());

class HomeViewmodel extends Vm {
  final _favRepo = locator.get<FavouriteRepo>();
  final _lastPlayingRepo = locator.get<LastPlayingRepo>();
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
    return _favourites
            .firstWhereOrNull((element) => element.url == podcast?.url) !=
        null;
  }

  Future<(PodcastEpisode, Duration)?> getLastSaved() async {
    final ep = await _lastPlayingRepo.getLastPlaying();
    if (ep != null) {
      final pos = await _historyRepo.getPosition(ep);
      if (pos != null) {
        return (ep, pos);
      }
    }
    return null;
  }
}

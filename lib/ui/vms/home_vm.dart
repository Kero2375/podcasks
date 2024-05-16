import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/data/entities/podcast/podcast_entity.dart';
import 'package:podcasks/data/entities/episode/podcast_episode.dart';
import 'package:podcasks/repository/history_repo.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcasks/locator.dart';
import 'package:podcasks/repository/favourites_repo.dart';
import 'package:podcasks/ui/vms/vm.dart';

final homeViewmodel = ChangeNotifierProvider((ref) => HomeViewmodel());

enum Pages {
  home,
  search,
  listening,
  favourites,
}

class HomeViewmodel extends Vm {
  final _favRepo = locator.get<FavouriteRepo>();
  final _historyRepo = locator.get<HistoryRepo>();

  List<MPodcast> get favourites => _favourites.sorted(_sortPodcastsByEpisode);
  List<MPodcast> _favourites = [];

  List<(MEpisode, MPodcast)>? get saved => _saved;
  List<(MEpisode, MPodcast)>? _saved;

  HomeViewmodel() {
    init();
  }

  Pages get page => _page;
  Pages _page = Pages.home;

  init() async {
    loading();
    await fetchFavourites();
    await fetchListening();
    success();
  }

  Future<void> fetchFavourites() async {
    loading();
    _favourites = await _favRepo.getAllFavourites();
    success();
  }

  Future<void> setFavourite(MPodcast podcast, bool setFavourite) async {
    // loading();
    if (podcast.url != null) {
      if (setFavourite) {
        await _favRepo.addToFavourite(podcast);
      } else {
        await _favRepo.removeFromFavourite(podcast.url!);
      }
    }
    await fetchFavourites();
    success();
  }

  bool isFavourite(MPodcast? podcast) {
    return _favourites
            .firstWhereOrNull((element) => element.url == podcast?.url) !=
        null;
  }

  Future<(MEpisode, MPodcast, Duration)?> getLastSaved() async {
    // final ep = await _lastPlayingRepo.getLastPlaying();
    final (ep, pod) = await _historyRepo.getLast() ?? (null, null);
    if (ep != null && pod != null) {
      final (rem, _) = _historyRepo.getPosition(ep) ?? (null, null);
      if (rem != null) {
        return (ep, pod, rem);
      }
    }
    return null;
  }

  Future<void> fetchListening() async {
    final List<(MEpisode, MPodcast)> list = await _historyRepo.getAllSaved();
    _saved = list;
  }

  void setPage(Pages newPage) {
    _page = newPage;
    notifyListeners();
  }

  Future<void> syncFavourites() async {
    await _favRepo.syncFavourites();
  }
}

int _sortPodcastsByEpisode(MPodcast a, MPodcast b) =>
    a.episodes.isNotEmpty && b.episodes.isNotEmpty
        ? b.episodes.firstOrNull!.publicationDate!
            .compareTo(a.episodes.firstOrNull!.publicationDate!)
        : 0;
    // (a.title != null && b.title != null) ? a.title!.compareTo(b.title!) : 0;

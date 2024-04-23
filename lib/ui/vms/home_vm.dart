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

  List<Podcast> get favourites => _favourites.sorted(_sortPodcastsByEpisode);
  List<Podcast> _favourites = [];

  PodcastEpisode? get saved => _saved;
  PodcastEpisode? _saved;

  HomeViewmodel() {
    init();
  }

  init() async {
    loading();
    await fetchFavourites();
    await fetchListening();
    success();
  }

  Future<List<Podcast>> fetchFavourites() async {
    final favFeeds = await _favRepo.getAllFavourites();
    List<Podcast> list = [];
    for (var value in favFeeds) {
      list.add(await Podcast.loadFeed(url: value));
    }
    _favourites = list;
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
    success();
  }

  bool isFavourite(Podcast? podcast) {
    return _favourites
            .firstWhereOrNull((element) => element.url == podcast?.url) !=
        null;
  }

  Future<(PodcastEpisode, Duration)?> getLastSaved() async {
    final ep = await _lastPlayingRepo.getLastPlaying();
    if (ep != null) {
      final (rem, _) = _historyRepo.getPosition(ep) ?? (null, null);
      if (rem != null) {
        return (ep, rem);
      }
    }
    return null;
  }

  Future<void> fetchListening() async {
    final last = await _lastPlayingRepo.getLastPlaying();
    if (last != null) {
      final time = _historyRepo.getPosition(last);
      if (time?.$1.inSeconds != 0) _saved = last;
    }
    // _saved = [];
  }
}

int _sortPodcastsByEpisode(Podcast a, Podcast b) =>
    a.episodes.isNotEmpty && b.episodes.isNotEmpty
        ? b.episodes.firstOrNull!.publicationDate!
            .compareTo(a.episodes.firstOrNull!.publicationDate!)
        : 0;

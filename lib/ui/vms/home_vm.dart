import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/data/entities/podcast/podcast_entity.dart';
import 'package:podcasks/data/podcast_episode.dart';
import 'package:podcasks/repository/history_repo.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcasks/locator.dart';
import 'package:podcasks/repository/favourites_repo.dart';
import 'package:podcasks/ui/vms/vm.dart';

final homeViewmodel = ChangeNotifierProvider((ref) => HomeViewmodel());

class HomeViewmodel extends Vm {
  final _favRepo = locator.get<FavouriteRepo>();
  final _historyRepo = locator.get<HistoryRepo>();

  List<PodcastEntity> get favourites =>
      _favourites.sorted(_sortPodcastsByEpisode);
  List<PodcastEntity> _favourites = [];

  List<PodcastEpisode>? get saved => _saved;
  List<PodcastEpisode>? _saved;

  HomeViewmodel() {
    init();
  }

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

  Future<void> setFavourite(PodcastEntity podcast, bool setFavourite) async {
    loading();
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

  bool isFavourite(Podcast? podcast) {
    return _favourites
            .firstWhereOrNull((element) => element.url == podcast?.url) !=
        null;
  }

  Future<(PodcastEpisode, Duration)?> getLastSaved() async {
    // final ep = await _lastPlayingRepo.getLastPlaying();
    final ep = await _historyRepo.getLast();
    if (ep != null) {
      final (rem, _) = _historyRepo.getPosition(ep) ?? (null, null);
      if (rem != null) {
        return (ep, rem);
      }
    }
    return null;
  }

  Future<void> fetchListening() async {
    final List<PodcastEpisode> list = await _historyRepo.getAllSaved();
    _saved = list;
  }
}

int _sortPodcastsByEpisode(PodcastEntity a, PodcastEntity b) =>
    // a.episodes.isNotEmpty && b.episodes.isNotEmpty
    //     ? b.episodes.firstOrNull!.publicationDate!
    //         .compareTo(a.episodes.firstOrNull!.publicationDate!)
    //     : 0;
    (a.title != null && b.title != null) ? a.title!.compareTo(b.title!) : 0;

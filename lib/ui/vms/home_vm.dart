import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcasks/data/entities/favourites/fav_item.dart';
import 'package:podcasks/data/entities/save/save_track.dart';
import 'package:podcasks/repository/history_repo.dart';
import 'package:podcasks/ui/vms/episodes_home_vm.dart';
import 'package:podcasks/locator.dart';
import 'package:podcasks/repository/favourites_repo.dart';
import 'package:podcasks/ui/vms/vm.dart';

final homeViewmodel = ChangeNotifierProvider((ref) => HomeViewmodel(ref));

enum Pages {
  home,
  search,
  listening,
  downloads,
  favourites,
}

class HomeViewmodel extends Vm {
  final _favRepo = locator.get<FavouriteRepo>();
  final _historyRepo = locator.get<HistoryRepo>();

  Ref<Object?> ref;

  bool syncing = false;

  List<Podcast> get favourites {
    final unique = <String, Podcast>{};
    for (final p in _favourites) {
      if (p.url != null) {
        unique[p.url!] = p;
      }
    }
    return unique.values.toList().sorted(_sortPodcastsByEpisode);
  }
  List<Podcast> _favourites = [];

  List<(Episode, Podcast)>? get saved => _saved;
  List<(Episode, Podcast)>? _saved;

  HomeViewmodel(this.ref);

  Pages get page => _page;
  Pages _page = Pages.home;

  Future<void> init() async {
    if (state == UiState.loading) return;
    loading();
    // Parallelize both fetches for faster startup
    await Future.wait([
      _fetchFavourites(notify: false),
      _fetchListening(limit: 10, notify: false),
    ]);
    success();
  }

  Future<void> fetchFavourites() async {
    await _fetchFavourites(notify: true);
  }

  Future<void> _fetchFavourites({required bool notify}) async {
    _favourites = await _favRepo.getAllFavourites();
    if (notify) notifyListeners();
  }

  Future<void> setFavourite(Podcast podcast, bool setFavourite) async {
    loading();
    if (podcast.url != null) {
      if (setFavourite) {
        await _favRepo.addToFavourite(podcast);
      } else {
        await _favRepo.removeFromFavourite(podcast.url!);
      }
    }
    await _fetchFavourites(notify: false);
    success();
  }

  bool isFavourite(Podcast? podcast) {
    return _favourites
            .firstWhereOrNull((element) => element.url == podcast?.url) !=
        null;
  }

  Future<(Episode, Podcast, Duration)?> getLastSaved() async {
    try {
      // loading();
      // final ep = await _lastPlayingRepo.getLastPlaying();
      final (ep, pod) = await _historyRepo.getLast() ?? (null, null);
      if (ep != null && pod != null) {
        final (rem, _, _) = _historyRepo.getPosition(ep) ?? (null, null, null);
        if (rem != null) {
          success();
          return (ep, pod, rem);
        }
      }
    } catch (e) {
      log(e.toString());
    }
    // success();
    return null;
  }

  Future<void> fetchListening({int? limit}) async {
    await _fetchListening(limit: limit, notify: true);
  }

  Future<void> _fetchListening({int? limit, required bool notify}) async {
    final List<(Episode, Podcast)> list = await _historyRepo.getAllSaved(limit: limit);
    _saved = list;
    if (notify) notifyListeners();
  }

  void setPage(Pages newPage) {
    _page = newPage;
    notifyListeners();
  }

  Future<void> syncFavourites() async {
    final token = RootIsolateToken.instance;
    if (token == null) return;
    compute(_sync, token)
        .then((_) => _notifyAll());
    // _notifyAll();
  }

  static Future<void> _sync(RootIsolateToken token) async {
    BackgroundIsolateBinaryMessenger.ensureInitialized(token);
    final dir = await getApplicationSupportDirectory();
    await Isar.open(
      [SaveTrackSchema, FavouriteSchema],
      directory: dir.path,
    );
    await FavouriteRepoIsar().syncFavourites();
  }

  void _notifyAll() {
    update();
    ref.read(episodesHomeViewmodel).update();
    // ref.read(homeViewmodel).update();
    // ref.read(episodesHomeViewmodel).update();
    // ref.read(episodesHomeViewmodel).update();
  }
}

int _sortPodcastsByEpisode(Podcast a, Podcast b) =>
    a.episodes.isNotEmpty && b.episodes.isNotEmpty
        ? b.episodes.firstOrNull!.publicationDate!
            .compareTo(a.episodes.firstOrNull!.publicationDate!)
        : 0;
    // (a.title != null && b.title != null) ? a.title!.compareTo(b.title!) : 0;

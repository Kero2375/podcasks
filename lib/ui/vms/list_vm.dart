import 'dart:developer' as dev;
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:podcasks/data/podcast_episode.dart';
import 'package:podcasks/locator.dart';
import 'package:podcasks/repository/history_repo.dart';
import 'package:podcasks/ui/vms/vm.dart';
import 'package:podcast_search/podcast_search.dart';

class ListViewmodel extends Vm {
  final HistoryRepo historyRepo = locator.get<HistoryRepo>();
  int _maxItems = 10;
  int _page = 0;

  List<PodcastEpisode>? get episodes => _episodes;
  List<PodcastEpisode>? _episodes;

  List<PodcastEpisode> get displayingEpisodes => _displayingEpisodes;
  List<PodcastEpisode> _displayingEpisodes = [];

  ScrollController get controller => _controller;
  ScrollController _controller = ScrollController();

  ListViewmodel() {
    // _ref.watch(playerViewmodel);
  }

  init(List<PodcastEpisode>? eps, {int? maxItems}) {
    if (maxItems != null) _maxItems = maxItems;
    _episodes = eps;
    _page = 0;
    if (episodes?.isNotEmpty != null) {
      initEpisodesList();
    }
  }

  void initEpisodesList() {
    if (episodes == null) return;
    _page = 0;
    if (episodes!.length < _maxItems) {
      _displayingEpisodes = episodes!;
    } else {
      _displayingEpisodes = episodes!.sublist(0, _maxItems);
    }
    _controller = ScrollController();
    _controller.addListener(loadMoreData);
  }

  @override
  void dispose() {
    _controller.removeListener(loadMoreData);
    super.dispose();
  }

  void loadMoreData() {
    try {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        if (episodes != null) {
          _page += 1;
          _displayingEpisodes.addAll(episodes!.sublist(
            /*start*/
            _page * _maxItems,
            min(episodes!.length, (_page + 1) * _maxItems),
          ));
          notifyListeners();
        }
      }
    } catch (e) {
      dev.log(e.toString());
    }
  }

  (EpisodeState, Duration?) getEpisodeState(Episode? ep) {
    if (ep == null) return (EpisodeState.none, null);
    final (remaining, finished) = historyRepo.getPosition(ep) ?? (null, null);
    return finished == true
        ? (EpisodeState.finished, null)
        : (remaining != null && remaining.inSeconds != 0)
            ? (EpisodeState.started, remaining)
            : (EpisodeState.none, null);
  }

  Future<void> markAsFinished(PodcastEpisode? ep) async {
    if (ep != null) {
      await historyRepo.setPosition(ep, Duration.zero, true);
      initEpisodesList();
      update();
    }
  }

  Future<void> cancelProgress(PodcastEpisode? ep) async {
    if (ep != null) {
      await historyRepo.removeEpisode(ep);
      initEpisodesList();
      update();
    }
  }
}

enum EpisodeState {
  none,
  started,
  finished,
}

import 'dart:developer' as dev;
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/data/podcast_episode.dart';
import 'package:podcasks/locator.dart';
import 'package:podcasks/repository/history_repo.dart';
import 'package:podcasks/ui/vms/vm.dart';
import 'package:podcast_search/podcast_search.dart';

class ListViewmodel extends Vm {
  final HistoryRepo _historyRepo = locator.get<HistoryRepo>();
  int _maxItems = 10;
  int _page = 0;

  List<PodcastEpisode>? get episodes => _episodes;
  List<PodcastEpisode>? _episodes;

  List<PodcastEpisode> get displayingEpisodes => _displayingEpisodes;
  List<PodcastEpisode> _displayingEpisodes = [];

  ScrollController get controller => _controller;
  ScrollController _controller = ScrollController();

  final Ref _ref;

  ListViewmodel(this._ref) {
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

  Future<EpisodeState> getEpisodeState(Episode? ep) async {
    if (ep == null) return EpisodeState.none;
    final (pos, finished) = await _historyRepo.getPosition(ep) ?? (null, null);
    return finished == true
        ? EpisodeState.finished
        : (pos != null && pos.inSeconds != 0)
            ? EpisodeState.started
            : EpisodeState.none;
  }
}

enum EpisodeState {
  none,
  started,
  finished,
}

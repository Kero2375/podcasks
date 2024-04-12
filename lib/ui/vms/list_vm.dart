import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:ppp2/ui/vms/vm.dart';

class ListViewmodel extends Vm {
  int _maxItems = 10;
  int _page = 0;

  List<Episode>? get episodes => _episodes;
  List<Episode>? _episodes;

  List<Episode> get displayingEpisodes => _displayingEpisodes;
  List<Episode> _displayingEpisodes = [];

  ScrollController get controller => _controller;
  ScrollController _controller = ScrollController();

  init(List<Episode>? eps, {int? maxItems}) {
    if(maxItems != null) _maxItems = maxItems;
    _episodes = eps;
    _page = 0;
    if (episodes?.isNotEmpty != null) {
      initEpisodesList();
    }
  }

  void initEpisodesList() {
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
            /*end*/ (_page + 1) * _maxItems,
          ));
          notifyListeners();
        }
      }
    } catch (e) {
      log("Error");
    }
  }
}

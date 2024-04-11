import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:ppp2/ui/vms/vm.dart';

final podcastViewmodel = ChangeNotifierProvider((ref) => PodcastViewmodel());

class PodcastViewmodel extends Vm {
  static const int _maxItems = 10;
  int _page = 0;

  Podcast? get podcast => _podcast;
  Podcast? _podcast;

  List<Episode> get displayingEpisodes => _displayingEpisodes;
  List<Episode> _displayingEpisodes = [];

  ScrollController get controller => _controller;
  ScrollController _controller = ScrollController();

  init(Podcast? podcast) {
    _podcast = podcast;
    _page = 0;
    if (_podcast?.episodes.isNotEmpty != null) {
      if (_podcast!.episodes.length < _maxItems) {
        _displayingEpisodes = _podcast!.episodes;
      } else {
        _displayingEpisodes = _podcast!.episodes.sublist(0, _maxItems);
      }
      _controller = ScrollController();
      _controller.addListener(_loadMoreData);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMoreData);
    super.dispose();
  }

  void _loadMoreData() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      // User has reached the end of the list
      // Load more data or trigger pagination in flutter
      if (_podcast?.episodes != null) {
        _page += 1;
        _displayingEpisodes.addAll(_podcast!.episodes.sublist(
          /*start*/
          _page * _maxItems,
          /*end*/ (_page + 1) * _maxItems,
        ));
        notifyListeners();
      }
    }
  }
}

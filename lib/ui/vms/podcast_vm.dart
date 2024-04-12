import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:ppp2/ui/vms/vm.dart';

final podcastViewmodel = ChangeNotifierProvider((ref) => PodcastViewmodel());

class PodcastViewmodel extends Vm {
  static const int _maxItems = 10;
  int _page = 0;

  bool get newerFirst => _newerFirst;
  bool _newerFirst = true;

  List<Episode>? get episodes => newerFirst
      ? _episodes
      : _episodes
          ?.sorted((a, b) {
            final dateA = a.publicationDate;
            final dateB = b.publicationDate;
            return (dateA != null && dateB != null) ? dateA.compareTo(dateB) : 0;
          })
          .toList();
  List<Episode>? _episodes;

  List<Episode> get displayingEpisodes => _displayingEpisodes;
  List<Episode> _displayingEpisodes = [];

  ScrollController get controller => _controller;
  ScrollController _controller = ScrollController();

  init(Podcast? podcast) {
    _episodes = podcast?.episodes;
    _page = 0;
    if (episodes?.isNotEmpty != null) {
      _initEpisodesList();
    }
  }

  void _initEpisodesList() {
    if (episodes!.length < _maxItems) {
      _displayingEpisodes = episodes!;
    } else {
      _displayingEpisodes = episodes!.sublist(0, _maxItems);
    }
    _controller = ScrollController();
    _controller.addListener(_loadMoreData);
  }

  setNewerFirst(bool newFirst) {
    _newerFirst = newFirst;
    _initEpisodesList();
    notifyListeners();
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
  }
}

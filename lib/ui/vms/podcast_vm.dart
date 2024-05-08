import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/data/entities/podcast/podcast_entity.dart';
import 'package:podcasks/data/podcast_episode.dart';
import 'package:podcasks/ui/common/debouncer.dart';
import 'package:podcasks/ui/vms/list_vm.dart';
import 'package:podcast_search/podcast_search.dart';

final podcastViewmodel = ChangeNotifierProvider((ref) => PodcastViewmodel());

class PodcastViewmodel extends ListViewmodel {
  TextEditingController? get searchController => _searchController;
  TextEditingController? _searchController;

  bool get newerFirst => _newerFirst;
  bool _newerFirst = true;

  String? _filter;
  final _debouncer = Debouncer(milliseconds: 500);

  Podcast? get podcast => _podcast;
  Podcast? _podcast;

  initPodcast(Object? pod, {int? maxItems}) async {
    if (pod is Podcast?) {
      _podcast = pod;
    } else if (pod is PodcastEntity?) {
      _podcast = await (pod as PodcastEntity?)?.getPodcast();
    }
    final episodes = podcast?.episodes
        .map((e) => PodcastEpisode.fromEpisode(e, podcast: podcast))
        .toList();
    await super.init(episodes, maxItems: maxItems);
  }

  @override
  List<PodcastEpisode>? get episodes =>
      ((_newerFirst) ? super.episodes : super.episodes?.reversed.toList())
          ?.where(
            (e) => (_filter != null && _filter != '')
                ? e.title.toLowerCase().contains(_filter!.toLowerCase()) ||
                    e.description.toLowerCase().contains(_filter!.toLowerCase())
                : true,
          )
          .toList();

  // @override
  // init(List<PodcastEpisode>? eps, {int? maxItems}) {
  //   if (_searchController?.text.trim() == '') {
  //     _searchController?.dispose();
  //     _searchController = null;
  //   }
  //   super.init(eps, maxItems: maxItems);
  // }

  setNewerFirst(bool newFirst) {
    _newerFirst = newFirst;
    initEpisodesList();
    notifyListeners();
  }

  void showSearch() {
    _searchController = SearchController();
    // _searchController?.addListener(() => _debouncer.run(searchListener));
    notifyListeners();
  }

  void hideSearch() {
    _filter = null;
    _searchController?.dispose();
    _searchController = null;
    initEpisodesList();
    notifyListeners();
  }

  @override
  void dispose() {
    _searchController?.dispose();
    _searchController = null;
    super.dispose();
  }

  void search(String term) {
    _debouncer.run(() {
      _filter = term;
      initEpisodesList();
      notifyListeners();
    });
  }

  Future<void> markAllAsFinished(Podcast? p) async {
    loading();
    if (p != null) {
      await historyRepo.setAllPositions(p, Duration.zero, true);
      initEpisodesList();
    }
    success();
  }

  deleteAll(Podcast? p) async {
    loading();
    await historyRepo.removeAll(p);
    initEpisodesList();
    success();
  }
}

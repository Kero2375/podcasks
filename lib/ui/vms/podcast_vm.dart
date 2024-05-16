import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/data/entities/podcast/podcast_entity.dart';
import 'package:podcasks/data/entities/episode/podcast_episode.dart';
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

  MPodcast? get podcast => _podcast;
  MPodcast? _podcast;

  initPodcast(MPodcast? pod, {int? maxItems}) async {
    if (pod == null) return;
    _podcast = pod;
    final episodes = podcast?.episodes
        // .map((e) => MEpisode.fromEpisode(e, podcast: podcast))
        .toList();
    await super
        .init(episodes?.map((e) => (e, podcast!)).toList(), maxItems: maxItems);
  }

  @override
  List<(MEpisode, MPodcast)>? get episodes =>
      ((_newerFirst) ? super.episodes : super.episodes?.reversed.toList())
          ?.where(
            (e) => (_filter != null && _filter != '')
                ? e.$1.title.toLowerCase().contains(_filter!.toLowerCase()) ||
                    e.$1.description
                        .toLowerCase()
                        .contains(_filter!.toLowerCase())
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

  Future<void> markAllAsFinished(MPodcast? p) async {
    loading();
    if (p != null) {
      await historyRepo.setAllPositions(p, Duration.zero, true);
      initEpisodesList();
    }
    success();
  }

  deleteAll(MPodcast? p) async {
    loading();
    await historyRepo.removeAll(p);
    initEpisodesList();
    success();
  }

  clearText() {
    _searchController?.clear();
    notifyListeners();
  }
}

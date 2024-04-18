import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/ui/common/debouncer.dart';
import 'package:podcasks/ui/vms/list_vm.dart';

final podcastViewmodel = ChangeNotifierProvider((ref) => PodcastViewmodel(ref));

class PodcastViewmodel extends ListViewmodel {
  PodcastViewmodel(super.ref);

  TextEditingController? get searchController => _searchController;
  TextEditingController? _searchController;

  bool get newerFirst => _newerFirst;
  bool _newerFirst = true;

  String? _filter;
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  get episodes =>
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
}

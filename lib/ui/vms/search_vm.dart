import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:ppp2/locator.dart';
import 'package:ppp2/repository/search_repo.dart';
import 'package:ppp2/ui/vms/vm.dart';

final searchViewmodel = ChangeNotifierProvider((ref) => SearchViewmodel());

class SearchViewmodel extends Vm {
  final _searchRepo = locator.get<SearchRepo>();

  List<Item> _searched = [];

  Podcast? _selected;

  Podcast? get selected => _selected;

  get searched => _searched;

  SearchViewmodel() {
    success();
  }

  Future<void> search(String term) async {
    // todo: add debounce
    _searched = await _searchRepo.search(term);
    success();
  }

  Future<void> fetchPodcast(String? feedUrl) async {
    loading();
    _selected = await _searchRepo.fetchPodcast(feedUrl);
    success();
  }
}

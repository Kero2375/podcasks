import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/repository/prefs_repo.dart';
import 'package:podcasks/ui/common/debouncer.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcasks/locator.dart';
import 'package:podcasks/repository/search_repo.dart';
import 'package:podcasks/ui/vms/vm.dart';

final searchViewmodel = ChangeNotifierProvider((ref) => SearchViewmodel());

class SearchViewmodel extends Vm {
  final _searchRepo = locator.get<SearchRepo>();
  final _prefsRepo = locator.get<PrefsRepo>();

  final _debouncer = Debouncer(milliseconds: 500);

  List<Item> get searched => _searched;
  List<Item> _searched = [];

  Podcast? get selected => _selected;
  Podcast? _selected;

  Future<Country> get country async => await _prefsRepo.getCountry();

  SearchViewmodel() {
    init();
  }

  TextEditingController searchBarController = TextEditingController();

  Future<String> get genre async => await _prefsRepo.getGenre();

  List<String> get genres => _prefsRepo.getAllGenres();

  Future<void> init() async {
    loading();
    _searched = await _searchRepo.charts(await country, await genre);
    success();
  }

  Future<void> search(String term) async {
    loading();
    _debouncer.run(
      () async {
        if (term.startsWith("http")) {
          final pod = await _searchRepo.fetchPodcast(term);
          _searched = [
            Item(
              feedUrl: term,
              artworkUrl: pod?.image,
              collectionName: pod?.title,
              artistName: pod?.episodes.firstOrNull?.author ?? pod?.title,
            )
          ];
        } else {
          _searched = await _searchRepo.search(term, await country);
        }
        success();
      },
    );
  }

  Future<void> fetchPodcast(String? feedUrl) async {
    loading();
    _selected = await _searchRepo.fetchPodcast(feedUrl);
    success();
  }

  Future<void> setCountry(Country? c) async {
    if (c != null) {
      // _country = c;
      _prefsRepo.setCountry(c);
      await _updateSearch();
    }
  }

  Future<void> setGenre(String? g) async {
    if (g != null) {
      _prefsRepo.setGenre(g);
      _updateSearch();
    }
  }

  Future<void> _updateSearch() async {
    if (searchBarController.text == '') {
      await init();
    } else {
      await search(searchBarController.text);
    }
  }

  void clearText() {
    searchBarController.text = '';
    _updateSearch();
  }
}

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

  TextEditingController searchBarController = TextEditingController();
  ScrollController scrollController = ScrollController();

  int _limit = 20;
  bool _loadingMore = false;
  bool get loadingMore => _loadingMore;

  int _searchSession = 0;

  Future<Country> get country async => await _prefsRepo.getCountry();

  SearchViewmodel() {
    init();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        loadMore();
      }
    });
  }

  String _genre = 'All';
  String get genre => _genre;

  // <value, localized string>
  Map<String, String> genres(BuildContext context) =>
      _prefsRepo.getAllGenres(context);

  Future<void> init() async {
    _limit = 20;
    _searched = [];
    _genre = 'All';
    searchBarController.text = '';
    _searchSession++; // Cancel any pending search
    _loadingMore = false;
    if (scrollController.hasClients) {
      scrollController.jumpTo(0);
    }
    success();
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (state == UiState.loading || _loadingMore || _limit >= 200) return;
    if (_searched.isEmpty && searchBarController.text.isEmpty) return;
    _loadingMore = true;
    notifyListeners();
    _limit += 20;

    final currentSession = _searchSession;
    final results = searchBarController.text.isEmpty
        ? await _searchRepo.charts(await country, genre, limit: _limit)
        : await _searchRepo.search(searchBarController.text, await country, limit: _limit);

    if (currentSession == _searchSession) {
      _searched = results.where((item) => item.feedUrl != null).toList();
      _loadingMore = false;
      notifyListeners();
    } else {
      _loadingMore = false;
    }
  }

  Future<void> search(String term) async {
    _limit = 20;
    loading();
    _searchSession++;
    _loadingMore = false;
    final currentSession = _searchSession;

    _debouncer.run(
      () async {
        List<Item> resultsList = [];
        if (term.startsWith("http")) {
          final pod = await _searchRepo.fetchPodcast(term);
          if (currentSession != _searchSession) return;
          resultsList = [
            Item(
              feedUrl: term,
              artworkUrl: pod?.image,
              collectionName: pod?.title,
              artistName: pod?.episodes.firstOrNull?.author ?? pod?.title,
            )
          ];
        } else {
          final results = await _searchRepo.search(term, await country);
          if (currentSession != _searchSession) return;
          resultsList = results.where((item) => item.feedUrl != null).toList();
        }

        if (currentSession == _searchSession) {
          _searched = resultsList;
          success();
        }
      },
    );
  }

  Future<void> fetchPodcast(String? feedUrl) async {
    // loading();
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
      _genre = g;
      _updateSearch();
    }
  }

  Future<void> _updateSearch() async {
    if (scrollController.hasClients) {
      scrollController.jumpTo(0);
    }
    _searchSession++;
    final currentSession = _searchSession;
    
    if (searchBarController.text == '') {
      // if (_genre == 'All') {
      //   _searched = [];
      //   success();
      //   return;
      // }
      loading();
      final results = await _searchRepo.charts(await country, _genre, limit: _limit);
      if (currentSession == _searchSession) {
        _searched = results.where((item) => item.feedUrl != null).toList();
        success();
      }
    } else {
      await search(searchBarController.text);
    }
  }

  void clearText() {
    searchBarController.text = '';
    _updateSearch();
  }
}

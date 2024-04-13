import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:ppp2/locator.dart';
import 'package:ppp2/repository/search_repo.dart';
import 'package:ppp2/ui/vms/vm.dart';

final searchViewmodel = ChangeNotifierProvider((ref) => SearchViewmodel());

class SearchViewmodel extends Vm {
  final _searchRepo = locator.get<SearchRepo>();

  get searched => _searched;
  List<Item> _searched = [];

  Podcast? get selected => _selected;
  Podcast? _selected;

  Country get country => _country;
  Country _country = Country.none;

  SearchViewmodel() {
    charts();
  }

  Future<void> charts() async {
    loading();
    _searched = await _searchRepo.charts(country);
    success();
  }

  Future<void> search(String term) async {
    loading();
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
      // todo: add debounce
      _searched = await _searchRepo.search(term);
    }
    success();
  }

  Future<void> fetchPodcast(String? feedUrl) async {
    loading();
    _selected = await _searchRepo.fetchPodcast(feedUrl);
    success();
  }

  void setCountry() {
    _country = country == Country.none ? Country.italy : Country.none;
  }
}

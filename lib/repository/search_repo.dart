import 'package:podcast_search/podcast_search.dart';

abstract class SearchRepo {
  Future<List<Item>> search(String term);

  Future<Podcast?> fetchPodcast(String? feedUrl);

  Future<List<Item>> charts([Country country = Country.none]);
}

class SearchRepoPodcastSearch extends SearchRepo {
  @override
  Future<List<Item>> search(String term) async {
    final result = await Search().search(term, limit: 10);
    return result.items;
  }

  @override
  Future<Podcast?> fetchPodcast(String? feedUrl) async {
    return feedUrl != null ? await Podcast.loadFeed(url: feedUrl) : null;
  }

  @override
  Future<List<Item>> charts([Country country = Country.none]) async {
    final result = await Search().charts(
      limit: 10,
      country: country,
    );
    return result.items;
  }
}

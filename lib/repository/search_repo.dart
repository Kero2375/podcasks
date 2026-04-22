import 'package:podcast_search/podcast_search.dart';

abstract class SearchRepo {
  Future<List<Item>> search(String term, Country country, {int limit = 20});

  Future<Podcast?> fetchPodcast(String? feedUrl);

  Future<List<Item>> charts(Country country, String genre, {int limit = 20});
}

class SearchRepoPodcastSearch extends SearchRepo {
  @override
  Future<List<Item>> search(String term, Country country, {int limit = 20}) async {
    final result = await Search().search(term, limit: limit, country: country);
    return result.items;
  }

  @override
  Future<Podcast?> fetchPodcast(String? feedUrl) async {
    return feedUrl != null ? await Feed.loadFeed(url: feedUrl) : null;
  }

  @override
  Future<List<Item>> charts(Country country, String genre, {int limit = 20}) async {
    final result = await Search().charts(
      genre: genre,
      limit: limit,
      country: country,
    );
    return result.items;
  }
}

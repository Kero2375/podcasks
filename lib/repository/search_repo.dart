import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podcast_search/podcast_search.dart';

abstract class SearchRepo {
  Future<List<Item>> search(String term, Country country);

  Future<Podcast?> fetchPodcast(String? feedUrl);

  Future<List<Item>> charts(Country country, String genre);

  download(Episode? episode);
}

class SearchRepoPodcastSearch extends SearchRepo {
  @override
  Future<List<Item>> search(String term, Country country) async {
    final result = await Search().search(term, limit: 10, country: country);
    return result.items;
  }

  @override
  Future<Podcast?> fetchPodcast(String? feedUrl) async {
    return feedUrl != null ? await Podcast.loadFeed(url: feedUrl) : null;
  }

  @override
  Future<List<Item>> charts([Country country = Country.none, String genre = 'Any']) async {
    final result = await Search().charts(
      genre: genre,
      limit: 10,
      country: country,
    );
    return result.items;
  }

  @override
  download(Episode? episode) async {
    if (episode?.contentUrl != null) {
      await FlutterDownloader.enqueue(
        url: episode!.contentUrl!,
        headers: {},
        savedDir: (await getExternalStorageDirectory())?.path ?? '',
        showNotification: true,
        openFileFromNotification: true,
        saveInPublicStorage: true,
      );
    }
  }
}

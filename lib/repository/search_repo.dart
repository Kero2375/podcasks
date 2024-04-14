import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podcast_search/podcast_search.dart';

abstract class SearchRepo {
  Future<List<Item>> search(String term);

  Future<Podcast?> fetchPodcast(String? feedUrl);

  Future<List<Item>> charts([Country country = Country.none]);

  download(Episode? episode);
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

  @override
  download(Episode? episode) async {
    if (episode?.contentUrl != null) {
      await FlutterDownloader.enqueue(
        url: episode!.contentUrl!,
        headers: {},
        savedDir: (await getExternalStorageDirectory())?.path ?? '',
        showNotification:
            true, // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
        saveInPublicStorage: true,
      );
    }
  }
}

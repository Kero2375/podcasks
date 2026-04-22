import 'package:http/http.dart' as http;
import 'package:isar/isar.dart';
import 'package:podcasks/data/entities/favourites/fav_item.dart';
import 'package:podcast_search/podcast_search.dart';

abstract class FavouriteRepo {
  Future<bool> addToFavourite(Podcast podcast, {String? eTag, String? lastModified, int? contentLength});

  Future<List<Favourite>> getRawFavourites();

  Future<List<Podcast>> getAllFavourites();

  Future<void> removeFromFavourite(String feedUrl);

  Future<Set<Podcast>> syncFavourites();
}

class FavouriteRepoIsar extends FavouriteRepo {
  Isar? get isar => Isar.getInstance();

  @override
  Future<bool> addToFavourite(Podcast podcast, {String? eTag, String? lastModified, int? contentLength}) async {
    // if ((await isar?.favourites.get(podcast.url.hashCode)) != null) return false;
    await isar?.writeTxn(
      () async => isar?.favourites.put(
        Favourite(
          id: podcast.url?.hashCode ?? 0,
        )..podcast = podcast
         ..lastModified = lastModified
         ..contentLength = contentLength
         ..eTag = eTag,
      ),
    );
    return true;
  }

  @override
  Future<List<Favourite>> getRawFavourites() async {
    return await isar?.favourites.where().findAll() ?? [];
  }

  @override
  Future<List<Podcast>> getAllFavourites() async {
    final all = await getRawFavourites();
    return all.map((e) => e.podcast).toList();
  }

  @override
  Future<void> removeFromFavourite(String feedUrl) async {
    await isar?.writeTxn(
      () async => isar?.favourites.delete(feedUrl.hashCode),
    );
  }

  @override
  Future<Set<Podcast>> syncFavourites() async {
    final rawFavs = await getRawFavourites();

    final futures = rawFavs.map((f) async {
      final p = f.podcast;
      final url = p.url;
      if (url == null) return null;

      try {
        // Try optimization with HEAD request first
        final headResponse = await http.head(Uri.parse(url));
        if (headResponse.statusCode == 200) {
          final newLastModified = headResponse.headers['last-modified'];
          final newETag = headResponse.headers['etag'];
          final newContentLength =
              int.tryParse(headResponse.headers['content-length'] ?? '');

          // Skip full download if headers match (we prefer ETag if available)
          bool matches = false;
          if (newETag != null && newETag == f.eTag) {
            matches = true;
          } else if (newLastModified != null &&
              newLastModified == f.lastModified) {
            matches = true;
          } else if (newContentLength != null &&
              newContentLength == f.contentLength) {
            matches = true;
          }

          if (matches) return null;
        }

        final newPod = await Feed.loadFeed(url: url);
        if (newPod.episodes.length != p.episodes.length) {
          final fullResponse = await http.head(Uri.parse(url)); // Get fresh headers
          await addToFavourite(
            newPod,
            lastModified: fullResponse.headers['last-modified'],
            eTag: fullResponse.headers['etag'],
            contentLength:
                int.tryParse(fullResponse.headers['content-length'] ?? ''),
          );
          return newPod;
        } else {
          // Even if episode count is same, update headers to avoid future HEAD hits
          final fullResponse = await http.head(Uri.parse(url));
          await addToFavourite(
            p,
            lastModified: fullResponse.headers['last-modified'],
            eTag: fullResponse.headers['etag'],
            contentLength:
                int.tryParse(fullResponse.headers['content-length'] ?? ''),
          );
        }
      } catch (e) {

        print('Error syncing $url: $e');
      }
      return null;
    });

    final results = await Future.wait(futures);
    return results.whereType<Podcast>().toSet();
  }
}


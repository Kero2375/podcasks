import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcasks/ui/vms/home_vm.dart';
import 'package:podcasks/ui/vms/list_vm.dart';

final episodesHomeViewmodel =
    ChangeNotifierProvider((ref) => EpisodesHomeViewmodel());

class EpisodesHomeViewmodel extends ListViewmodel {
  EpisodesHomeViewmodel();

  Episode getFirstUnfinishedEpisode(Podcast podcast) {
    if (podcast.episodes.isEmpty) return Episode(guid: '', title: '', description: '', length: 0);

    // Sort by date ascending (oldest first)
    final sortedEpisodes = podcast.episodes.toList()
      ..sort((a, b) =>
          (a.publicationDate ?? DateTime.fromMillisecondsSinceEpoch(0)).compareTo(
              b.publicationDate ?? DateTime.fromMillisecondsSinceEpoch(0)));

    int latestFinishedIndex = -1;
    for (int i = 0; i < sortedEpisodes.length; i++) {
      final ep = sortedEpisodes[i];
      final (remaining, _, finished) =
          historyRepo.getPosition(ep) ?? (null, null, false);

      if (finished) {
        latestFinishedIndex = i;
      } else if (remaining != null && remaining.inSeconds > 0) {
        // This one is started but not finished. Return it!
        return ep;
      }
    }

    // If nothing is started, return the one after the latest finished
    if (latestFinishedIndex + 1 < sortedEpisodes.length) {
      return sortedEpisodes[latestFinishedIndex + 1];
    }

    // If all finished, return the latest one (which is the last in sorted list)
    return sortedEpisodes.last;
  }

  void refreshHomeList(HomeViewmodel homeVm) {
    final favourites = homeVm.favourites;
    final list = <(Episode, Podcast)>[];

    for (Podcast p in favourites) {
      if (p.episodes.isNotEmpty) {
        list.add((getFirstUnfinishedEpisode(p), p));
      }
    }

    init(list.toList(), maxItems: 30);
  }

  // List<PodcastEntity> get podcastFilter => _podcastFilter;
  // List<PodcastEntity> _podcastFilter = [];

  Podcast? tempPodcast;

  initPodcast(Podcast? podcast, {int? maxItems}) async {
    if (podcast == null) return;
    loading();
    tempPodcast = podcast;
    // final episodes = tempPodcast?.episodes
    //     .map((e) => (e, podcast))
    //     // .map((e) => MEpisode.fromEpisode(e, podcast: tempPodcast))
    //     .toList();
    await super.init(episodes, maxItems: maxItems);
    success();
  }

  @override
  List<(Episode, Podcast)>? get episodes {
    final raw = super.episodes;
    if (raw == null) return null;

    final filtered = raw.where(
      (e) => tempPodcast == null || e.$2.url == tempPodcast?.url,
    );

    final seenGuids = <String>{};
    final unique = <(Episode, Podcast)>[];

    for (final item in filtered) {
      if (!seenGuids.contains(item.$1.guid)) {
        seenGuids.add(item.$1.guid);
        unique.add(item);
      }
    }

    return unique;
  }

  showListening(HomeViewmodel homeVm) async {
    tempPodcast = null;
    // await homeVm.init();
    await super.init(episodes, maxItems: 30);
    // try {
    //   initEpisodesList();
    // } catch (_) {}
    notifyListeners();
  }

  // bool isInFilter(PodcastEntity p) {
  //   return _podcastFilter.contains(p);
  // }

  // bool isFilterEmpty() {
  //   return _podcastFilter.isEmpty;
  // }

  // bool isOfSize(int length) {
  //   return _podcastFilter.length == length;
  // }
}

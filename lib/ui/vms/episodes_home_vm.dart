import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/data/entities/podcast/podcast_entity.dart';
import 'package:podcasks/data/entities/episode/podcast_episode.dart';
import 'package:podcasks/ui/vms/home_vm.dart';
import 'package:podcasks/ui/vms/list_vm.dart';
import 'package:podcast_search/podcast_search.dart';

final episodesHomeViewmodel =
    ChangeNotifierProvider((ref) => EpisodesHomeViewmodel());

class EpisodesHomeViewmodel extends ListViewmodel {
  EpisodesHomeViewmodel();

  // List<PodcastEntity> get podcastFilter => _podcastFilter;
  // List<PodcastEntity> _podcastFilter = [];

  MPodcast? tempPodcast;

  initPodcast(MPodcast? podcastEntity, {int? maxItems}) async {
    loading();
    tempPodcast = podcastEntity;
    final episodes = tempPodcast?.episodes
        // .map((e) => MEpisode.fromEpisode(e, podcast: tempPodcast))
        .toList();
    await super.init(episodes, maxItems: maxItems);
    success();
  }

  @override
  List<MEpisode>? get episodes => super.episodes?.toSet().toList();

  showListening(HomeViewmodel homeVm) async {
    tempPodcast = null;
    await homeVm.fetchFavourites();
    await init(homeVm.saved, maxItems: 30);
    try {
      initEpisodesList();
    } catch (_) {}
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

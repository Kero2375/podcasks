import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/data/podcast_episode.dart';
import 'package:podcasks/ui/vms/list_vm.dart';
import 'package:podcast_search/podcast_search.dart';

final episodesHomeViewmodel =
    ChangeNotifierProvider((ref) => EpisodesHomeViewmodel());

class EpisodesHomeViewmodel extends ListViewmodel {
  EpisodesHomeViewmodel();

  List<Podcast> _podcastFilter = [];

  @override
  List<PodcastEpisode>? get episodes => super.episodes?.where((e) {
        if (_podcastFilter.isNotEmpty) {
          return _podcastFilter.map((p) => p.url).contains(e.podcast?.url);
        } else {
          final (pos, finished) = historyRepo.getPosition(e) ?? (null, null);
          return (pos != null && pos.inSeconds != 0) && (finished != true);
        }
      }).toList();

  filterEpisodes(List<Podcast> p) {
    _podcastFilter = p;
    try {
      initEpisodesList();
    } catch (_) {}
    notifyListeners();
  }

  bool isInFilter(Podcast p) {
    return _podcastFilter.contains(p);
  }

  bool isFilterEmpty() {
    return _podcastFilter.isEmpty;
  }

  bool isOfSize(int length) {
    return _podcastFilter.length == length;
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/data/podcast_episode.dart';
import 'package:podcasks/locator.dart';
import 'package:podcasks/repository/history_repo.dart';
import 'package:podcasks/ui/vms/list_vm.dart';
import 'package:podcast_search/podcast_search.dart';

final podcastViewmodel = ChangeNotifierProvider((ref) => PodcastViewmodel());

class PodcastViewmodel extends ListViewmodel {
  bool get newerFirst => _newerFirst;
  bool _newerFirst = true;

  @override
  get episodes =>
      (_newerFirst) ? super.episodes : super.episodes?.reversed.toList();

  setNewerFirst(bool newFirst) {
    _newerFirst = newFirst;
    initEpisodesList();
    notifyListeners();
  }
}

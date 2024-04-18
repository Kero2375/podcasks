import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/ui/vms/list_vm.dart';

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

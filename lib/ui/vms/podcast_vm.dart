import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ppp2/ui/vms/list_vm.dart';

final podcastViewmodel = ChangeNotifierProvider((ref) => PodcastViewmodel());

class PodcastViewmodel extends ListViewmodel {
  bool get newerFirst => _newerFirst;
  bool _newerFirst = true;

  setNewerFirst(bool newFirst) {
    _newerFirst = newFirst;
    initEpisodesList();
    notifyListeners();
  }
}

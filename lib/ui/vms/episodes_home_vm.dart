import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/ui/vms/list_vm.dart';

final episodesHomeViewmodel =
    ChangeNotifierProvider((ref) => EpisodesHomeViewmodel(ref));

class EpisodesHomeViewmodel extends ListViewmodel {
  EpisodesHomeViewmodel(super.ref);
}

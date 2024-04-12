import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ppp2/ui/vms/list_vm.dart';

final episodesHomeViewmodel = ChangeNotifierProvider((ref) => EpisodesHomeViewmodel());

class EpisodesHomeViewmodel extends ListViewmodel {}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/ui/vms/list_vm.dart';

final listeningViewmodel = ChangeNotifierProvider((ref) => ListeningVm());

class ListeningVm extends ListViewmodel {}

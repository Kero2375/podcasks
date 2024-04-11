import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ppp2/ui/common/app_bar.dart';
import 'package:ppp2/ui/pages/home/podcast_list.dart';
import 'package:ppp2/ui/player/bottom_player.dart';
import 'package:ppp2/ui/vms/home_vm.dart';
import 'package:ppp2/ui/vms/player_vm.dart';
import 'package:ppp2/ui/vms/vm.dart';

class HomePage extends ConsumerStatefulWidget {
  static const route = "/";

  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    final homeVm = ref.read(homeViewmodel);
    final playerVm = ref.read(playerViewmodel);
    _checkSaved(homeVm, playerVm);
    super.initState();
  }

  Future<void> _checkSaved(HomeViewmodel homeVm, PlayerViewmodel playerVm) async {
    final track = await homeVm.getLastSavedTrack();
    final position = await homeVm.getLastSavedPosition();
    if (track != null && position != null) {
      await playerVm.setPlaying(track);
      await playerVm.pause();
      await playerVm.seekPosition(position);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(homeViewmodel);
    return Scaffold(
      appBar: mainAppBar(context, title: 'Podcasts', cast: true),
      body: vm.state == UiState.loading
          ? const Center(child: CircularProgressIndicator())
          : PodcastList(items: vm.favourites),
      bottomSheet: const BottomPlayer(),
    );
  }
}

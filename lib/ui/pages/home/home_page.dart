import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ppp2/ui/common/app_bar.dart';
import 'package:ppp2/ui/pages/home/podcast_list.dart';
import 'package:ppp2/ui/player/bottom_player.dart';
import 'package:ppp2/ui/vms/home_vm.dart';

class HomePage extends ConsumerWidget {
  static const route = "/";

  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(homeViewmodel);
    return Scaffold(
      appBar: mainAppBar(context, title: 'Podcasts', cast: true),
      body: PodcastList(items: vm.favourites),
      bottomSheet: const BottomPlayer(),
    );
  }
}

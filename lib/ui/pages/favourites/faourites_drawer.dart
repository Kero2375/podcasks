import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/ui/common/app_bar.dart';
import 'package:podcasks/ui/pages/favourites/podcast_list.dart';
import 'package:podcasks/ui/vms/home_vm.dart';
import 'package:podcasks/utils.dart';

class FavouritesPage extends ConsumerWidget {
  static String route = '/favourites_page';

  const FavouritesPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeVm = ref.watch(homeViewmodel);
    return Scaffold(
      appBar: mainAppBar(
          title: context.l10n!.favourites,
          actions: const SizedBox.shrink(),
          context),
      body: ListView(
        children: [
          PodcastList(items: homeVm.favourites),
        ],
      ),
    );
  }
}

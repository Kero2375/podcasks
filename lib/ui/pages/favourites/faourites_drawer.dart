import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/pages/favourites/podcast_list.dart';
import 'package:podcasks/ui/vms/home_vm.dart';
import 'package:podcasks/utils.dart';

class FavouritesDrawer extends ConsumerWidget {
  const FavouritesDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeVm = ref.watch(homeViewmodel);
    return Drawer(
      child: ListView(
        children: [
          SizedBox(
            height: 86,
            child: DrawerHeader(
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Icon(
                    Icons.favorite,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    context.l10n!.following(2),
                    style: textStyleSubtitle(context),
                  ),
                ],
              ),
            ),
          ),
          PodcastList(items: homeVm.favourites),
        ],
      ),
    );
  }
}

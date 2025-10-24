import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/pages/bottom_navigation/tab_icon.dart';
import 'package:podcasks/ui/vms/home_vm.dart';
import 'package:podcasks/utils.dart';

class BottomBar extends ConsumerWidget {
  final Pages selectedPage;

  const BottomBar({required this.selectedPage, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomNavigationBar(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.primaryFixedDim.withAlpha(20),
      selectedLabelStyle: textStyleSmall.copyWith(fontWeight: FontWeight.bold),
      unselectedLabelStyle: textStyleSmall,
      onTap: (value) => onTabTapped(context, value, ref),
      currentIndex: selectedPage.index,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: TabIcon(
            icon: Icons.home_filled,
            selected: selectedPage == Pages.home,
          ),
          label: context.l10n!.home.toLowerCase(),
        ),
        BottomNavigationBarItem(
          icon: TabIcon(
            icon: Icons.search,
            selected: selectedPage == Pages.search,
          ),
          label: context.l10n!.explore.toLowerCase(),
        ),
        BottomNavigationBarItem(
          icon: TabIcon(
            icon: Icons.queue_music,
            selected: selectedPage == Pages.listening,
          ),
          label: context.l10n!.listening.toLowerCase(),
        ),
      ],
    );
  }

  void onTabTapped(BuildContext context, int index, WidgetRef ref) {
    final vm = ref.read(homeViewmodel);

    switch (index) {
      case 0:
        vm.setPage(Pages.home);
        // Navigator.of(context).popAndPushNamed(HomePage.route);
        break;
      case 1:
        vm.setPage(Pages.search);
        // Navigator.of(context).popAndPushNamed(SearchPage.route);
        break;
      case 2:
        // final lstVm = ref.read(listeningViewmodel);
        vm.setPage(Pages.listening);
        // vm.fetchListening();
        // lstVm.clear();
        // Navigator.of(context).popAndPushNamed(SearchPage.route);
        break;
    }
  }

}

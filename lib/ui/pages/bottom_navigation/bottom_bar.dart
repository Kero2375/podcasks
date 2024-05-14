import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/pages/bottom_navigation/tab_icon.dart';
import 'package:podcasks/ui/pages/home/home_page.dart';
import 'package:podcasks/ui/pages/search/search_page.dart';
import 'package:podcasks/ui/vms/home_vm.dart';

class BottomBar extends ConsumerWidget {
  final Pages selectedPage;

  const BottomBar({required this.selectedPage, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeVm = ref.watch(homeViewmodel);

    return BottomNavigationBar(
      elevation: 60,
      selectedLabelStyle: textStyleSmall.copyWith(fontWeight: FontWeight.bold),
      unselectedLabelStyle: textStyleSmall,
      onTap: (value) => onTabTapped(context, value, homeVm),
      currentIndex: selectedPage.index,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: TabIcon(
              icon: Icons.home_filled, selected: selectedPage == Pages.home),
          label: 'home',
        ),
        BottomNavigationBarItem(
          icon: TabIcon(
              icon: Icons.search, selected: selectedPage == Pages.search),
          label: 'explore',
        ),
        BottomNavigationBarItem(
          icon: TabIcon(
              icon: Icons.headphones,
              selected: selectedPage == Pages.listening),
          label: 'listening',
        ),
      ],
    );
  }

  void onTabTapped(BuildContext context, int index, HomeViewmodel vm) {
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
        vm.setPage(Pages.listening);
        // Navigator.of(context).popAndPushNamed(SearchPage.route);
        break;
    }
  }

  void _goTo(BuildContext context, String route) {
    Navigator.pushReplacementNamed(
      context,
      route,
      // PageRouteBuilder(
      //   pageBuilder: (context, animation1, animation2) => Page1(),
      //   transitionDuration: Duration.zero,
      //   reverseTransitionDuration: Duration.zero,
      // ),
    );
  }
}

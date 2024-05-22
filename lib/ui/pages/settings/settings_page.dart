import 'package:flutter/material.dart';
import 'package:podcasks/ui/common/app_bar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static String route = '/settings_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(
        title: 'Settings',
        actions: const SizedBox.shrink(),
        context,
      ),
      body: const Placeholder(
        child: Expanded(child: Text('TODO')),
      ),
    );
  }
}

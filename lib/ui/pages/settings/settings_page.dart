import 'package:flutter/material.dart';
import 'package:podcasks/ui/common/app_bar.dart';
import 'package:podcasks/utils.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static String route = '/settings_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(
        title: context.l10n!.settings,
        actions: const SizedBox.shrink(),
        context,
      ),
      body: Placeholder(
        child: Expanded(child: Text(context.l10n!.todo)),
      ),
    );
  }
}

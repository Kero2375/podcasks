import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcasks/locator.dart';
import 'package:podcasks/repository/prefs_repo.dart';
import 'package:podcasks/ui/common/app_bar.dart';
import 'package:podcasks/ui/common/opml_utils.dart';
import 'package:podcasks/ui/vms/settings_vm.dart';
import 'package:podcasks/ui/vms/home_vm.dart';
import 'package:podcasks/utils.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  static String route = '/settings_page';

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}


Text _text(String t) => Text(t, style: textStyleBody);
Text _textSmall(String t) => Text(t, style: textStyleSmall);
Text _textTitle(String t, BuildContext c) => Text(t, style: textStyleHeader.copyWith(color: Theme.of(c).colorScheme.primary));

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(settingsViewmodel).init());
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(settingsViewmodel);
    final homeVm = ref.read(homeViewmodel);
    locator.get<PrefsRepo>().getAllGenres(context);

    return Scaffold(
      appBar: mainAppBar(
        title: context.l10n!.settings,
        actions: const SizedBox.shrink(),
        context,
      ),
      body: ListView(
        children: [
          _sectionTitle(context.l10n!.appearance),
          SwitchListTile(
            title: _text(context.l10n!.dynamicColor),
            subtitle: _textSmall(context.l10n!.dynamicColorDescription),
            value: vm.dynamicColor,
            onChanged: (val) => vm.setDynamicColor(val),
          ),
          if (!vm.dynamicColor)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Colors.deepPurple,
                    Colors.blue,
                    Colors.teal,
                    Colors.green,
                    Colors.orange,
                    Colors.red,
                    Colors.pink,
                    Colors.brown,
                  ].map((color) => GestureDetector(
                    onTap: () => vm.setThemeColor(color),
                    child: Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: vm.themeColor.toARGB32() == color.toARGB32()
                            ? Border.all(color: Theme.of(context).colorScheme.onSurface, width: 3)
                            : null,
                      ),
                    ),
                  )).toList(),
                ),
              ),
            ),
          const Divider(),
          _sectionTitle(context.l10n!.backup),
          ListTile(
            leading: const Icon(Icons.download_outlined),
            title: _text(context.l10n!.exportOpml),
            onTap: () => exportFile(context),
          ),
          ListTile(
            leading: const Icon(Icons.upload_outlined),
            title: _text(context.l10n!.importOpml),
            onTap: () => pickFile(context, () => homeVm.update(), () => homeVm.syncing = true),
          ),
          const Divider(),
          _sectionTitle(context.l10n!.syncTitle),
          ListTile(
            title: _text(context.l10n!.syncFrequency),
            subtitle: _textSmall(context.l10n!.syncFrequencyDescription),
            trailing: DropdownButton<int>(
              value: vm.syncFrequency,
              onChanged: (val) => vm.setSyncFrequency(val),
              items: [
                DropdownMenuItem(value: 1, child: _text("1 ${context.l10n!.hour}")),
                DropdownMenuItem(value: 2, child: _text("2 ${context.l10n!.hours}")),
                DropdownMenuItem(value: 6, child: _text("6 ${context.l10n!.hours}")),
                DropdownMenuItem(value: 12, child: _text("12 ${context.l10n!.hours}")),
                DropdownMenuItem(value: 24, child: _text("1 ${context.l10n!.day}")),
              ],
            ),
          ),
          const Divider(),
          _sectionTitle(context.l10n!.searchFilters),
          ListTile(
            title: _text(context.l10n!.region),
            trailing: DropdownButton<Country>(
              value: vm.country,
              onChanged: (val) => vm.setCountry(val),
              items: Country.values.map((c) => DropdownMenuItem(
                value: c,
                child: _text(c.name.isNotEmpty ? c.name.capitalize(context) : "None"),
              )).toList(),
            ),
          ),
          const Divider(),
          _sectionTitle(context.l10n!.storage),
          ListTile(
            title: _text(context.l10n!.downloadDirectory),
            subtitle: _textSmall(vm.downloadPath ?? context.l10n!.defaultPath),
            trailing: const Icon(Icons.folder_open_outlined),
            onTap: () => vm.pickDownloadPath(),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: _textTitle(title, context),
    );
  }
}

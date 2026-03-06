import 'package:flutter/material.dart';
import 'package:podcasks/ui/common/opml_utils.dart';
import 'package:podcasks/ui/common/popup_menu_item.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/pages/favourites/faourites_drawer.dart';
import 'package:podcasks/ui/pages/search/search_page.dart';
import 'package:podcasks/ui/pages/settings/settings_page.dart';
import 'package:podcasks/utils.dart';

AppBar mainAppBar(
  BuildContext context, {
  String? title,
  Widget? actions,
  Widget? leading,
  Function()? updateHome,
  Function()? startLoading,
}) {
  return AppBar(
    leading: leading,
    title: Row(
      children: [
        if (title == 'Podcasks') ...[
          ColorFiltered(
            colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSurface, BlendMode.srcIn),
            child: Image.asset(
              'assets/icon/icon_foreground.png',
              width: 50,
              height: 50,
            ),
          ),
          const SizedBox(width: 8),
        ],
        Flexible(
          flex: 1,
          child: Text(
            title ?? '',
            overflow: TextOverflow.ellipsis,
            style: textStyleTitle,
          ),
        ),
      ],
    ),
    actions: [
      actions ??
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            shape: popupMenuShape(context),
            onSelected: (item) =>
                _checkValue(context, item, updateHome, startLoading),
            itemBuilder: (BuildContext context) => [
              popupMenuItem(
                value: 2,
                icon: const Icon(Icons.sync),
                text: context.l10n!.sync,
              ),
              popupMenuItem(
                value: 5,
                icon: const Icon(Icons.file_upload_outlined),
                text: context.l10n!.exportOpml,
              ),
              popupMenuItem(
                value: 1,
                icon: const Icon(Icons.file_download_outlined),
                text: context.l10n!.importOpml,
              ),
            ],
          ),
    ],
  );
}

_checkValue(BuildContext context, int item, Function()? updateHome,
    Function()? startLoading) {
  switch (item) {
    case 0:
      Navigator.pushNamed(context, SearchPage.route);
      break;
    case 1:
      pickFile(context, updateHome, startLoading);
      break;
    case 2:
      updateHome?.call();
      break;
    case 3:
      Navigator.pushNamed(context, SettingsPage.route);
      break;
    case 4:
      Navigator.pushNamed(context, FavouritesPage.route);
      break;
    case 5:
      exportFile(context);
      break;
  }
}

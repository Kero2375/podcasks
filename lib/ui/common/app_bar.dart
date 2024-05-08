import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:podcasks/locator.dart';
import 'package:podcasks/repository/favourites_repo.dart';
import 'package:podcasks/ui/common/confirm_dialog.dart';
import 'package:podcasks/ui/common/popup_menu_item.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/pages/search/search_page.dart';
import 'package:podcasks/utils.dart';
import 'package:xml/xml.dart';

AppBar mainAppBar(
  BuildContext context, {
  String? title,
  Widget? actions,
  Widget? leading,
  Function()? updateHome,
}) {
  return AppBar(
    leading: leading,
    title: Center(
      child: Text(
        title ?? '',
        overflow: TextOverflow.ellipsis,
        style: textStyleTitle,
      ),
    ),
    actions: [
      actions ??
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            onSelected: (item) => _checkValue(context, item, updateHome),
            itemBuilder: (BuildContext context) => [
              popupMenuItem(
                value: 0,
                icon: const Icon(Icons.search),
                text: context.l10n!.search,
              ),
              popupMenuItem(
                value: 1,
                icon: const Icon(Icons.upload_file_outlined),
                text: context.l10n!.importOpml,
              ),
              // popupMenuItem(
              //   value: 2,
              //   icon: const Icon(Icons.tune),
              //   text: 'Settings',
              // ),
            ],
          ),

      // IconButton(
      //   onPressed: () {
      //     Navigator.pushNamed(context, SearchPage.route);
      //   },
      //   icon: const Icon(Icons.search),
      // )
    ],
  );
}

_checkValue(BuildContext context, int item, Function()? updateHome) {
  switch (item) {
    case 0:
      Navigator.pushNamed(context, SearchPage.route);
      break;
    case 1:
      _pickFile(context, updateHome);
      break;
  }
}

_pickFile(BuildContext context, Function()? updateHome) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null) {
    File file = File(result.files.single.path!);
    final xmlString = await file.readAsString();
    final document = XmlDocument.parse(xmlString);
    final feeds = document
        .findAllElements('outline')
        .where((e) => e.getAttribute('text') != 'feeds')
        .map((e) => '${e.getAttribute('xmlUrl')}');

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        title: context.l10n!.importTitle,
        message: context.l10n!.importMessage(feeds.length),
        actionText: context.l10n!.import,
        actionIcon: const Icon(Icons.upload_file_outlined),
        onTap: () async {
          for (var item in feeds) {
            bool added = await locator.get<FavouriteRepo>().addToFavourite(item);
            if (added && context.mounted) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Added $item")));
            }
            // updateHome?.call();
          }
        },
      ),
    );
  } else {
    // User canceled the picker
  }
}

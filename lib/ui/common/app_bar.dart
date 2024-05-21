import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:podcasks/data/entities/podcast/podcast_entity.dart';
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
  Function()? startLoading,
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
            onSelected: (item) =>
                _checkValue(context, item, updateHome, startLoading),
            itemBuilder: (BuildContext context) => [
              // popupMenuItem(
              //   value: 0,
              //   icon: const Icon(Icons.search),
              //   text: context.l10n!.search,
              // ),
              popupMenuItem(
                value: 1,
                icon: const Icon(Icons.upload_file_outlined),
                text: context.l10n!.importOpml,
              ),
              popupMenuItem(
                value: 2,
                icon: const Icon(Icons.sync),
                text: 'Sync',
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

_checkValue(BuildContext context, int item, Function()? updateHome,
    Function()? startLoading) {
  switch (item) {
    case 0:
      Navigator.pushNamed(context, SearchPage.route);
      break;
    case 1:
      _pickFile(context, updateHome, startLoading);
      break;
    case 2:
      updateHome?.call();
      break;
  }
}

_pickFile(BuildContext context, Function()? updateHome,
    Function()? startLoading) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowedExtensions: ['opml', 'OPML', 'xml', 'XML'],
    type: FileType.custom,
  );

  if (result != null) {
    File file = File(result.files.single.path!);
    final favRepo = locator.get<FavouriteRepo>();
    final xmlString = await file.readAsString();
    final document = XmlDocument.parse(xmlString);
    final fav = await favRepo.getAllFavourites();
    final feeds = document
        .findAllElements('outline')
        .where((e) => e.getAttribute('text') != 'feeds')
        .map((e) => '${e.getAttribute('xmlUrl')}')
        .where((e) => !fav.map((e) => e.url).contains(e))
        .toList();

    if (!context.mounted) return;

    if (feeds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        "Nothing new to import",
        style: textStyleBody,
      )));
      return;
    }
    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        title: context.l10n!.importTitle,
        message: context.l10n!.importMessage(feeds.length),
        actionText: context.l10n!.import,
        actionIcon: const Icon(Icons.upload_file_outlined),
        onTap: () async {
          startLoading?.call();
          for (var item in feeds) {
            bool added = await favRepo.addToFavourite(
              await MPodcast.fromUrl(item),
            );
            // TODO: check
            if (added && context.mounted) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Added $item")));
            }
            // updateHome?.call();
          }
          updateHome?.call();
        },
      ),
    );
  } else {
    // User canceled the picker
  }
}

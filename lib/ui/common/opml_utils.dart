import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcasks/locator.dart';
import 'package:podcasks/repository/favourites_repo.dart';
import 'package:podcasks/ui/common/confirm_dialog.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/utils.dart';
import 'package:xml/xml.dart';

exportFile(BuildContext context) async {
  final favRepo = locator.get<FavouriteRepo>();
  final fav = await favRepo.getAllFavourites();

  if (fav.isEmpty) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        context.l10n!.notFavouritesMessage,
        style: textStyleBody,
      )));
    }
    return;
  }

  final builder = XmlBuilder();
  builder.processing('xml', 'version="1.0" encoding="UTF-8"');
  builder.element('opml', attributes: {'version': '1.0'}, nest: () {
    builder.element('head', nest: () {
      builder.element('title', nest: 'Podcasks Subscriptions');
    });
    builder.element('body', nest: () {
      for (var p in fav) {
        builder.element('outline', attributes: {
          'text': p.title ?? '',
          'title': p.title ?? '',
          'type': 'rss',
          'xmlUrl': p.url ?? '',
          'htmlUrl': p.link ?? '',
        });
      }
    });
  });

  final xmlString = builder.buildDocument().toXmlString(pretty: true);
  final bytes = Uint8List.fromList(utf8.encode(xmlString));

  try {
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select where to save your file:',
      fileName: 'podcasks_subscriptions.opml',
      type: FileType.any,
      bytes: bytes,
    );

    if (outputFile == null) {
      return;
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        "File saved successfully",
        style: textStyleBody,
      )));
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        "${context.l10n!.error}: $e",
        style: textStyleBody,
      )));
    }
  }
}

pickFile(BuildContext context, Function()? updateHome,
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
        context.l10n!.nothingToImport,
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
              await Feed.loadFeed(url: item),
            );
            if (added && context.mounted) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("${context.l10n!.added} $item")));
            }
          }
          updateHome?.call();
        },
      ),
    );
  }
}

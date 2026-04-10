import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcasks/locator.dart';
import 'package:podcasks/repository/favourites_repo.dart';
import 'package:podcasks/repository/history_repo.dart';
import 'package:podcasks/ui/common/confirm_dialog.dart';
import 'package:podcasks/ui/common/loading_dialog.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/utils.dart';
import 'package:xml/xml.dart';

exportFile(BuildContext context) async {
  final favRepo = locator.get<FavouriteRepo>();
  final historyRepo = locator.get<HistoryRepo>();
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

  // ignore: use_build_context_synchronously
  await showLoading(context);

  final builder = XmlBuilder();
  builder.processing('xml', 'version="1.0" encoding="UTF-8"');

  // Pre-fetch finished IDs for all favorites to avoid async calls inside builder
  Map<String, List<int>> allFinishedIds = {};
  for (var p in fav) {
    if (p.url != null) {
      allFinishedIds[p.url!] = await historyRepo.getFinishedIds(p.url!);
    }
  }

  builder.element('opml', attributes: {'version': '1.0'}, nest: () {
    builder.element('head', nest: () {
      builder.element('title', nest: 'Podcasks Subscriptions');
    });
    builder.element('body', nest: () {
      for (var p in fav) {
        final finishedIds = allFinishedIds[p.url] ?? [];
        builder.element('outline', attributes: {
          'text': p.title ?? '',
          'title': p.title ?? '',
          'type': 'rss',
          'xmlUrl': p.url ?? '',
          'htmlUrl': p.link ?? '',
        }, nest: () {
          for (var e in p.episodes) {
            final idString = e.guid.isNotEmpty
                ? e.guid
                : (e.contentUrl ?? e.title);
            if (finishedIds.contains(idString.hashCode)) {
              builder.element('outline', attributes: {
                'type': 'listened',
                'guid': idString,
              });
            }
          }
        });
      }
    });
  });

  final xmlString = builder.buildDocument().toXmlString(pretty: true);
  final bytes = Uint8List.fromList(utf8.encode(xmlString));

  if (context.mounted) {
    hideLoading(context);
  }

  try {
    String? outputFile = await FilePicker.platform.saveFile(
      // ignore: use_build_context_synchronously
      dialogTitle: context.l10n!.selectBackupLocation,
      fileName: 'podcasks_backup.opml',
      type: FileType.any,
      bytes: bytes,
    );

    if (outputFile == null) {
      return;
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        context.l10n!.backupSavedSuccessfully,
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
    final historyRepo = locator.get<HistoryRepo>();
    final xmlString = await file.readAsString();
    final document = XmlDocument.parse(xmlString);
    final fav = await favRepo.getAllFavourites();

    final feedElements = document
        .findAllElements('outline')
        .where((e) => e.getAttribute('type') == 'rss' || e.getAttribute('xmlUrl') != null)
        .toList();

    final feedsToImport = feedElements
        .map((e) => (e.getAttribute('xmlUrl') ?? ''))
        .where((url) => url.isNotEmpty && !fav.map((f) => f.url).contains(url))
        .toList();

    if (!context.mounted) return;

    if (feedsToImport.isEmpty) {
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
        message: context.l10n!.importMessage(feedsToImport.length),
        actionText: context.l10n!.import,
        actionIcon: const Icon(Icons.upload_file_outlined),
        onTap: () async {
          startLoading?.call();
          await showLoading(context);
          if (!context.mounted) return;
          for (var feedElement in feedElements) {
            final url = feedElement.getAttribute('xmlUrl');
            if (url == null || url.isEmpty) continue;
            
            // Only import if not already in favorites
            if (!fav.map((f) => f.url).contains(url)) {
              Podcast podcast = await Feed.loadFeed(url: url);
              bool added = await favRepo.addToFavourite(podcast);
              
              if (added) {
                // Restore finished episodes
                final listenedGuids = feedElement
                    .findElements('outline')
                    .where((e) => e.getAttribute('type') == 'listened')
                    .map((e) => e.getAttribute('guid'))
                    .whereType<String>()
                    .toSet();

                if (listenedGuids.isNotEmpty) {
                  for (var episode in podcast.episodes) {
                    final idString = episode.guid.isNotEmpty
                        ? episode.guid
                        : (episode.contentUrl ?? episode.title);
                    if (listenedGuids.contains(idString)) {
                      await historyRepo.setPosition(
                        episode,
                        podcast,
                        Duration.zero, // finished
                        episode.duration,
                      );
                    }
                  }
                }

                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("${context.l10n!.added} $url")));
                }
              }
            }
          }
          if (context.mounted) {
            hideLoading(context);
          }
          updateHome?.call();
        },
      ),
    );
  }
}

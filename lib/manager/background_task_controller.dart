import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podcasks/data/entities/favourites/fav_item.dart';
import 'package:podcasks/data/entities/save/save_track.dart';
import 'package:podcasks/repository/favourites_repo.dart';
import 'package:podcasks/l10n/app_localizations.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

@pragma("vm:entry-point")
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == 'podcasksUpdate') {
      final dir = await getApplicationSupportDirectory();
      await Isar.open(
        [SaveTrackSchema, FavouriteSchema],
        directory: dir.path,
      );

      Set<Podcast> updated = await FavouriteRepoIsar().syncFavourites();

      if (updated.isEmpty) return Future.value(true);

      final l10n = await AppLocalizations.delegate.load(
        WidgetsBinding.instance.platformDispatcher.locale,
      );

      if (updated.length == 1) {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
          id: updated.first.title.hashCode,
          channelKey: 'podcasks_sync',
          actionType: ActionType.Default,
          title: updated.first.title,
          body: updated.first.episodes.first.title,
          largeIcon: updated.first.image,
          payload: {'feedUrl': updated.first.url ?? ''},
        ));
      } else if (updated.length > 1) {
        final title = l10n.newEpisodesTitle;
        final body =
            "${updated.first.episodes[0].title}, ${updated.first.episodes[1].title}";
        final extra = (updated.length == 2)
            ? ""
            : l10n.andOthers(updated.length - 2);
        AwesomeNotifications().createNotification(
            content: NotificationContent(
          id: updated.first.title.hashCode,
          channelKey: 'podcasks_sync',
          actionType: ActionType.Default,
          title: title,
          body: body + extra,
          largeIcon: updated.first.image,
        ));
      }
    }

    return Future.value(true);
  });
}

class BackgroundTaskController {
  static Future<void> init() async {
    await Workmanager().initialize(callbackDispatcher);
    await Workmanager().registerPeriodicTask(
      'podcasksUpdate',
      'podcasksUpdate',
      frequency: const Duration(hours: 2),
      initialDelay: const Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
    );
  }
}

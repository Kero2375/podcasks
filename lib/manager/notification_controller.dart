import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:podcasks/locator.dart';
import 'package:podcasks/main.dart';
import 'package:podcasks/repository/search_repo.dart';
import 'package:podcasks/l10n/app_localizations.dart';
import 'package:podcasks/ui/pages/podcast/podcast_page.dart';
import 'package:podcast_search/podcast_search.dart';

class NotificationController {

  static Future<void> init() async {
    final l10n = await AppLocalizations.delegate.load(
      WidgetsBinding.instance.platformDispatcher.locale,
    );

    await AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
              channelGroupKey: 'basic_channel_group',
              channelKey: 'podcasks_sync',
              channelName: l10n.notificationChannelName,
              channelDescription: l10n.notificationChannelDescription,
              defaultColor: const Color(0xFF9D50DD),
              ledColor: Colors.white)
        ],
        // Channel groups are only visual and are not required
        channelGroups: [
          NotificationChannelGroup(
              channelGroupKey: 'basic_channel_group',
              channelGroupName: l10n.notificationGroupName)
        ],
        debug: true);

    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    await AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);
  }

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future <void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future <void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future <void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future <void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    final String? feedUrl = receivedAction.payload?['feedUrl'];
    if (feedUrl == null) return;

    // Push a loading screen immediately to cover the Home page during fetch
    MyApp.navigatorKey.currentState?.push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        transitionDuration: Duration.zero,
      ),
    );

    final Podcast? podcast = await locator.get<SearchRepo>().fetchPodcast(feedUrl);

    // Replace the loading screen with the PodcastPage
    MyApp.navigatorKey.currentState?.pushReplacementNamed(
      PodcastPage.route,
      arguments: podcast,
    );
  }
}

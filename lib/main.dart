import 'package:audio_service/audio_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podcasks/data/entities/episode/podcast_episode.dart';
import 'package:podcasks/data/entities/favourites/fav_item.dart';
import 'package:podcasks/data/entities/podcast/podcast_entity.dart';
import 'package:podcasks/data/entities/save/save_track.dart';
import 'package:podcasks/locator.dart';
import 'package:podcasks/manager/audio_handler.dart';
import 'package:podcasks/repository/favourites_repo.dart';
import 'package:podcasks/ui/notifications/notification_controller.dart';
import 'package:podcasks/ui/pages/episode_page.dart';
import 'package:podcasks/ui/pages/favourites/faourites_drawer.dart';
import 'package:podcasks/ui/pages/home/home_page.dart';
import 'package:podcasks/ui/pages/playing/playing_page.dart';
import 'package:podcasks/ui/pages/podcast/podcast_page.dart';
import 'package:podcasks/ui/pages/search/search_page.dart';
import 'package:podcasks/ui/pages/settings/settings_page.dart';
import 'package:podcasks/ui/vms/theme_vm.dart';
import 'package:workmanager/workmanager.dart';

import 'l10n/app_localizations.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == 'podcasksUpdate') {
      final dir = await getApplicationSupportDirectory();
      await Isar.open(
        [SaveTrackSchema, FavouriteSchema],
        directory: dir.path,
      );

      Set<MPodcast> updated = await FavouriteRepoIsar().syncFavourites();

      for (MPodcast pod in updated) {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
          id: pod.title.hashCode,
          channelKey: 'podcasks_sync',
          actionType: ActionType.Default,
          title: pod.title,
          body: pod.episodes.first.title,
          largeIcon: pod.image,
        ));
      }
    }

    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setup();

  final dir = await getApplicationSupportDirectory();
  Isar.open(
    [SaveTrackSchema, FavouriteSchema],
    directory: dir.path,
  );
  audioHandler = await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.kero.podcasks.channel.audio',
      androidNotificationChannelName: 'Podcast playback',
    ),
  );
  await FlutterDownloader.initialize(
    ignoreSsl: true,
    debug: true,
  );

  Workmanager().initialize(callbackDispatcher);
  Workmanager().registerPeriodicTask('podcasksUpdate', 'podcasksUpdate', frequency: const Duration(minutes: 15), initialDelay: Duration.zero);

  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'podcasks_sync',
            channelName: 'Podkasks sync',
            channelDescription: 'Notification channel for podcast episodes sync',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [NotificationChannelGroup(channelGroupKey: 'basic_channel_group', channelGroupName: 'Podkasks notifications')],
      debug: true);

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod: NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod: NotificationController.onDismissActionReceivedMethod);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(themeViewmodel);
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) => MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('it'),
          // Locale('es'),
        ],
        initialRoute: HomePage.route,
        routes: {
          HomePage.route: (context) => const HomePage(),
          SearchPage.route: (context) => const SearchPage(),
          PlayingPage.route: (context) => const PlayingPage(),
          SettingsPage.route: (context) => const SettingsPage(),
          FavouritesPage.route: (context) => const FavouritesPage(),
          // PodcastPage.route: (context) => const PodcastPage(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == PodcastPage.route) {
            return MaterialPageRoute(
              builder: (context) => PodcastPage(settings.arguments as MPodcast?),
            );
          } else if (settings.name == EpisodePage.route) {
            return MaterialPageRoute(
              builder: (context) => EpisodePage(settings.arguments as (MEpisode, MPodcast)?),
            );
          }
          return null;
        },
        theme: vm.getAppTheme(MediaQuery.of(context).platformBrightness == Brightness.light ? lightDynamic : darkDynamic),
      ),
    );
  }
}

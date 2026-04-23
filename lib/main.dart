// ignore_for_file: unused_import

import 'package:audio_service/audio_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcasks/data/entities/favourites/fav_item.dart';
import 'package:podcasks/data/entities/podcast/podcast_entity.dart';
import 'package:podcasks/data/entities/save/save_track.dart';
import 'package:podcasks/locator.dart';
import 'package:podcasks/manager/audio_handler.dart';
import 'package:podcasks/repository/favourites_repo.dart';
import 'package:podcasks/repository/search_repo.dart';
import 'package:podcasks/manager/notification_controller.dart';
import 'package:podcasks/ui/pages/episode_page.dart';
import 'package:podcasks/ui/pages/favourites/faourites_drawer.dart';
import 'package:podcasks/ui/pages/home/home_page.dart';
import 'package:podcasks/ui/pages/playing/playing_page.dart';
import 'package:podcasks/ui/pages/podcast/podcast_page.dart';
import 'package:podcasks/ui/pages/search/search_page.dart';
import 'package:podcasks/ui/pages/settings/settings_page.dart';
import 'package:podcasks/ui/vms/settings_vm.dart';
import 'package:podcasks/ui/vms/home_vm.dart';
import 'package:podcasks/ui/vms/theme_vm.dart';
import 'package:podcasks/manager/background_task_controller.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  setup();

  final dir = await getApplicationSupportDirectory();
  
  // Parallelize critical initializations
  await Future.wait([
    Isar.open(
      [SaveTrackSchema, FavouriteSchema],
      directory: dir.path,
    ),
    AudioService.init(
      builder: () => MyAudioHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.kero.podcasks.channel.audio',
        androidNotificationChannelName: 'Podcast playback',
      ),
    ).then((handler) => audioHandler = handler),
    FlutterDownloader.initialize(
      ignoreSsl: true,
      debug: true,
    ),
  ]);

  // Start background and notification controllers
  BackgroundTaskController.init();
  NotificationController.init();

  // Check if app was opened via notification
  ReceivedAction? initialAction = await AwesomeNotifications().getInitialNotificationAction(
    removeFromActionEvents: false
  );

  Podcast? initialPodcast;
  if (initialAction?.payload?['feedUrl'] != null) {
    initialPodcast = await locator.get<SearchRepo>().fetchPodcast(initialAction!.payload!['feedUrl']);
  }

  runApp(
    ProviderScope(child: MyApp(initialPodcast: initialPodcast)),
  );
}

class MyApp extends ConsumerStatefulWidget {
  final Podcast? initialPodcast;
  const MyApp({super.key, this.initialPodcast});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
@override
void initState() {
  super.initState();
  Future.microtask(() async {
    // Initialize core settings first (theme/lang)
    await ref.read(settingsViewmodel).init();

    // Native splash can go as soon as we have settings (theme info)
    FlutterNativeSplash.remove();

    // Start fetching home data immediately
    ref.read(homeViewmodel).init();

    if (kDebugMode && widget.initialPodcast == null) {
      final favs = await locator.get<FavouriteRepo>().getAllFavourites();
      if (favs.isNotEmpty && favs.first.episodes.isNotEmpty) {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 999,
            channelKey: 'podcasks_sync',
            title: favs.first.title,
            body: favs.first.episodes.first.title,
            largeIcon: favs.first.image,
            payload: {'feedUrl': favs.first.url ?? ''},
          ),
        );
      }
    }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(themeViewmodel);
    return DynamicColorBuilder(

      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) =>
          MaterialApp(
        navigatorKey: MyApp.navigatorKey,
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
        ],
        initialRoute: widget.initialPodcast != null ? PodcastPage.route : HomePage.route,
        routes: {
          HomePage.route: (context) => const HomePage(),
          SearchPage.route: (context) => const SearchPage(),
          PlayingPage.route: (context) => const PlayingPage(),
          SettingsPage.route: (context) => const SettingsPage(),
          FavouritesPage.route: (context) => const FavouritesPage(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == PodcastPage.route) {
            return MaterialPageRoute(
              builder: (context) =>
                  PodcastPage(settings.arguments as Podcast? ?? widget.initialPodcast),
            );
          } else if (settings.name == EpisodePage.route) {
            return MaterialPageRoute(
              builder: (context) =>
                  EpisodePage(settings.arguments as (Episode, Podcast, bool)?),
            );
          }
          return null;
        },
        theme: vm.getAppTheme(
          MediaQuery.of(context).platformBrightness == Brightness.light
              ? lightDynamic
              : darkDynamic,
        ),
      ),
    );
  }
}

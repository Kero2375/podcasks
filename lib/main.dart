import 'package:audio_service/audio_service.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcasks/data/podcast_episode.dart';
import 'package:podcasks/locator.dart';
import 'package:podcasks/manager/audio_handler.dart';
import 'package:podcasks/ui/pages/episode_page.dart';
import 'package:podcasks/ui/pages/home/home_page.dart';
import 'package:podcasks/ui/pages/playing/playing_page.dart';
import 'package:podcasks/ui/pages/podcast_page.dart';
import 'package:podcasks/ui/pages/search/search_page.dart';
import 'package:podcasks/ui/vms/theme_vm.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setup();
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

  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(themeViewmodel);
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) =>
          MaterialApp(
        initialRoute: HomePage.route,
        routes: {
          HomePage.route: (context) => const HomePage(),
          SearchPage.route: (context) => const SearchPage(),
          PlayingPage.route: (context) => const PlayingPage(),
          // PodcastPage.route: (context) => const PodcastPage(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == PodcastPage.route) {
            return MaterialPageRoute(
              builder: (context) => PodcastPage(settings.arguments as Podcast?),
            );
          } else if (settings.name == EpisodePage.route) {
            return MaterialPageRoute(
              builder: (context) =>
                  EpisodePage(settings.arguments as PodcastEpisode?),
            );
          }
          return null;
        },
        theme: vm.getAppTheme(
            MediaQuery.of(context).platformBrightness == Brightness.light
                ? lightDynamic
                : darkDynamic),
      ),
    );
  }
}

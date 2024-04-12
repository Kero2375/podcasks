import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:ppp2/locator.dart';
import 'package:ppp2/manager/audio_handler.dart';
import 'package:ppp2/ui/pages/episode_page.dart';
import 'package:ppp2/ui/pages/home/home_page.dart';
import 'package:ppp2/ui/pages/playing/playing_page.dart';
import 'package:ppp2/ui/pages/podcast_page.dart';
import 'package:ppp2/ui/pages/search/search_page.dart';
import 'package:ppp2/ui/vms/theme_vm.dart';

Future<void> main() async {
  setup();
  audioHandler = await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.kero.ppp2.channel.audio',
      androidNotificationChannelName: 'Podcast playback',
    ),
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
    return MaterialApp(
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
            builder: (context) => EpisodePage(settings.arguments as EpisodeData?),
          );
        }
        return null;
      },
      theme: vm.getAppTheme(MediaQuery.of(context).platformBrightness),
    );
  }
}

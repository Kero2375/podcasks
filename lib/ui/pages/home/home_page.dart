import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:podcasks/data/entities/episode/podcast_episode.dart';
import 'package:podcasks/manager/download_manager.dart';
import 'package:podcasks/ui/common/app_bar.dart';
import 'package:podcasks/ui/common/bottom_player.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/pages/bottom_navigation/bottom_bar.dart';
import 'package:podcasks/ui/pages/favourites/faourites_drawer.dart';
import 'package:podcasks/ui/common/episode_item.dart';
import 'package:podcasks/ui/pages/home/favourites_row.dart';
import 'package:podcasks/ui/pages/home/home_content.dart';
import 'package:podcasks/ui/pages/home/home_listening.dart';
import 'package:podcasks/ui/pages/playing/playing_page.dart';
import 'package:podcasks/ui/pages/podcast/podcast_page.dart';
import 'package:podcasks/ui/pages/search/search_page.dart';
import 'package:podcasks/ui/vms/episodes_home_vm.dart';
import 'package:podcasks/ui/vms/home_vm.dart';
import 'package:podcasks/ui/vms/list_vm.dart';
import 'package:podcasks/ui/vms/player_vm.dart';
import 'package:podcasks/ui/vms/vm.dart';
import 'package:podcasks/utils.dart';

class HomePage extends ConsumerStatefulWidget {
  static const route = "/";

  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _syncing = false;

  @override
  void initState() {
    final homeVm = ref.read(homeViewmodel);
    final playerVm = ref.read(playerViewmodel);
    final episodesVm = ref.read(episodesHomeViewmodel);
    _checkSaved(homeVm, playerVm, episodesVm);
    super.initState();
  }

  Future<void> _checkSaved(HomeViewmodel homeVm, PlayerViewmodel playerVm,
      EpisodesHomeViewmodel episodesVm) async {
    final (track, pod, position) =
        await homeVm.getLastSaved() ?? (null, null, null);
    final (state, _) = episodesVm.getEpisodeState(track);
    if (track != null &&
        pod != null &&
        position != null &&
        state != EpisodeState.finished) {
      await playerVm.setupPlayer(track, pod);
      await playerVm.pause();
      await playerVm.seekPosition(playerVm.duration - position);
    }
  }

  // void _initEpisodeList(
  //     EpisodesHomeViewmodel episodesVm, HomeViewmodel homeVm) {
  //   final List<PodcastEpisode>? saved = homeVm.saved;
  //   // final favourites = homeVm.favourites;
  //   final list = <PodcastEpisode>[];

  //   if (saved != null) {
  //     list.addAll(saved);
  //   }

  //   // // FIXME: get episodes?
  //   // list.addAll(favourites
  //   //     .map(
  //   //       (p) => p.episodes.map(
  //   //         (e) => PodcastEpisode.fromEpisode(e, podcast: p),
  //   //       ),
  //   //     )
  //   //     .flattened);

  //   episodesVm.init(list, maxItems: 30);
  // }

  @override
  Widget build(BuildContext context) {
    final homeVm = ref.watch(homeViewmodel);
    final playerVm = ref.read(playerViewmodel);

    _sync(HomeViewmodel homeVm) async {
      setState(() => _syncing = true);
      await homeVm.syncFavourites();
      // await homeVm.fetchFavourites();
      // await homeVm.fetchListening();
      // episodesVm.initEpisodesList();
      // await episodesVm.update();
      // await homeVm.update();
      setState(() => _syncing = false);
    }

    return Scaffold(
      appBar: mainAppBar(
        context,
        title: context.l10n!.appTitle,
        leading: homeVm.favourites.isNotEmpty
            ? _favouritesButton()
            : const SizedBox.shrink(),
        updateHome: () async {
          await homeVm.fetchFavourites();
        },
      ),
      bottomNavigationBar: BottomBar(selectedPage: homeVm.page),
      body: homeVm.state == UiState.loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator.adaptive(
              onRefresh: () async {
                _sync(homeVm);
                await Future.delayed(const Duration(seconds: 2));
              },
              child: Column(
                children: [
                  if (_syncing) const LinearProgressIndicator(minHeight: 2),
                  Expanded(
                    child: switch (homeVm.page) {
                      Pages.home => const HomeContentPage(),
                      Pages.search => const SearchPage(),
                      Pages.listening => const ListeningPage(),
                      Pages.favourites => const SizedBox.shrink(),
                    },
                  ),
                  if (playerVm.playing != null)
                    const SizedBox(
                      height: BottomPlayer.playerHeight,
                    ),
                ],
              ),
            ),
      bottomSheet: const BottomPlayer(),
      drawer: homeVm.favourites.isNotEmpty ? const FavouritesDrawer() : null,
    );
  }

  // Widget _favRow(EpisodesHomeViewmodel episodesVm, HomeViewmodel homeVm) {
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: FavouritesRow(
  //       episodesVm: episodesVm,
  //       homeVm: homeVm,
  //     ),
  //   );
  // }

  Builder _favouritesButton() {
    return Builder(
      builder: (context) {
        return IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          icon: SvgPicture.asset(
            'assets/icon/favorites_list.svg',
            width: 32,
            // ignore: deprecated_member_use
            color: Theme.of(context).colorScheme.secondary,
          ),
        );
      },
    );
  }

  // Column _episodesList(EpisodesHomeViewmodel episodesVm, DownloadManager dm) =>
  //     Column(
  //       children: [
  //         ListView.builder(
  //           physics: const ScrollPhysics(),
  //           scrollDirection: Axis.vertical,
  //           shrinkWrap: true,
  //           itemCount: episodesVm.displayingEpisodes.length,
  //           itemBuilder: (context, i) {
  //             return EpisodeItem(
  //               vm: episodesVm,
  //               dm: dm,
  //               episode: episodesVm.displayingEpisodes[i],
  //               showImage: true,
  //               showDesc: false,
  //             );
  //           },
  //         ),
  //         const SizedBox(height: BottomPlayer.playerHeight),
  //       ],
  //     );

  // Center _welcomeContent(BuildContext context) {
  //   return Center(
  //     child: Padding(
  //       padding: const EdgeInsets.only(top: 64),
  //       child: Column(
  //         children: [
  //           Text(context.l10n!.welcome, style: textStyleBody),
  //           Text(context.l10n!.notListeningMessage, style: textStyleBody),
  //           const SizedBox(height: 8),
  //           Text(context.l10n!.bohEmoji, style: textStyleBody),
  //           const SizedBox(height: 8),
  //           FilledButton(
  //             onPressed: () {
  //               Navigator.pushNamed(
  //                 context,
  //                 SearchPage.route,
  //               );
  //             },
  //             style: buttonStyle,
  //             child: Row(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 const Icon(Icons.search),
  //                 const SizedBox(width: 8),
  //                 Text(context.l10n!.explorePodcasts),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

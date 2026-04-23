import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/manager/download_manager.dart';
import 'package:podcasks/ui/common/episode_menu.dart';
import 'package:podcasks/ui/common/home_episode_card.dart';
import 'package:podcasks/ui/common/opml_utils.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/pages/podcast/podcast_page.dart';
import 'package:podcasks/ui/vms/episodes_home_vm.dart';
import 'package:podcasks/ui/vms/home_vm.dart';
import 'package:podcasks/ui/vms/list_vm.dart';
import 'package:podcasks/ui/vms/listening_vm.dart';
import 'package:podcasks/ui/vms/player_vm.dart';
import 'package:podcasks/ui/vms/vm.dart';
import 'package:podcasks/utils.dart';

class HomeContentPage extends ConsumerStatefulWidget {
  const HomeContentPage({super.key});

  @override
  ConsumerState<HomeContentPage> createState() => _HomeContentPageState();
}

class _HomeContentPageState extends ConsumerState<HomeContentPage> {
  @override
  void initState() {
    super.initState();
    final homeVm = ref.read(homeViewmodel);
    final episodesVm = ref.read(episodesHomeViewmodel);
    episodesVm.refreshHomeList(homeVm);
  }

  @override
  Widget build(BuildContext context) {
    final homeVm = ref.watch(homeViewmodel);
    final episodesVm = ref.watch(episodesHomeViewmodel);
    final dm = ref.watch(downloadManager);

    ref.listen(homeViewmodel, (previous, next) {
      episodesVm.refreshHomeList(next);
    });

    return RefreshIndicator(
      onRefresh: () async {
        sync(ref);
        await Future.delayed(const Duration(seconds: 2));
      },
      child: (episodesVm.displayingEpisodes.isEmpty)
          ? LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) =>
                  SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight + 1),
                  child: _welcomeContent(context, homeVm),
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _episodesList(episodesVm, dm, homeVm)),
              ],
            ),
    );
  }

  Widget _episodesList(
      EpisodesHomeViewmodel episodesVm, DownloadManager dm, HomeViewmodel homeVm) {
    final playerVm = ref.watch(playerViewmodel);
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 900 ? 5 : width > 600 ? 3 : 2;

    return CustomScrollView(
      controller: episodesVm.controller,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(12),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 0.7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final x = episodesVm.displayingEpisodes[index];
                final state = episodesVm.getEpisodeState(x.$1);
                return HomeEpisodeCard(
                  episode: x.$1,
                  podcast: x.$2,
                  onCardTap: () => Navigator.pushNamed(context, PodcastPage.route,
                      arguments: x.$2),
                  onPlayTap: () {
                    if (playerVm.state != UiState.loading) {
                      playerVm.isPlaying(url: x.$1.contentUrl)
                          ? playerVm.pause()
                          : playerVm.play(
                              track: x.$1,
                              pod: x.$2,
                              seekPos: true,
                            );
                    } else {
                      playerVm.pause();
                    }
                  },
                  onLongTap: (Offset tapPosition) {
                    final (episodeState, remaining) =
                        episodesVm.getEpisodeState(x.$1);
                    showEpisodeMenu(
                      context: context,
                      value: episodeState,
                      vm: episodesVm,
                      dm: ref.read(downloadManager),
                      playerVm: ref.read(playerViewmodel),
                      ep: x.$1,
                      pd: x.$2,
                      tapPos: tapPosition,
                      homeVm: homeVm,
                    );
                  },
                  timeLeftOnEpisode: state.$1 == EpisodeState.finished ? null : state.$2 == null ? x.$1.duration?.toEnlapsed() : state.$2?.toEnlapsed(),
                );
              },
              childCount: episodesVm.displayingEpisodes.length,
            ),
          ),
        ),
        if (episodesVm.loadingMore)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0),
              child: Center(
                child: CircularProgressIndicator(
                  strokeCap: StrokeCap.round,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _welcomeContent(BuildContext context, HomeViewmodel homeVm) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(context.l10n!.welcome, style: textStyleBody),
          Text(context.l10n!.notFavouritesMessage, style: textStyleBody),
          const SizedBox(height: 8),
          Text(context.l10n!.bohEmoji, style: textStyleBody),
          const SizedBox(height: 16),
          IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledButton(
                  onPressed: () {
                    homeVm.setPage(Pages.search);
                  },
                  style: buttonStyle,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.search),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          context.l10n!.explorePodcasts,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () {
                    pickFile(context, () => sync(ref), () {
                      homeVm.syncing = true;
                      homeVm.update();
                    });
                  },
                  style: buttonStyle,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.file_download_outlined),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          context.l10n!.importOpml,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> sync(WidgetRef ref) async {
  final homeVm = ref.read(homeViewmodel);
  final epVm = ref.read(episodesHomeViewmodel);
  final lstVm = ref.read(listeningViewmodel);

  homeVm.syncing = true;
  homeVm.update();
  await homeVm.syncFavourites();
  await homeVm.fetchFavourites();
  await homeVm.fetchListening();
  epVm.refreshHomeList(homeVm);
  await epVm.update();
  lstVm.initEpisodesList();
  await lstVm.update();
  homeVm.syncing = false;
  await homeVm.update();
}

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/data/entities/episode/podcast_episode.dart';
import 'package:podcasks/data/entities/podcast/podcast_entity.dart';
import 'package:podcasks/manager/download_manager.dart';
import 'package:podcasks/repository/favourites_repo.dart';
import 'package:podcasks/ui/common/divider.dart';
import 'package:podcasks/ui/common/episode_item.dart';
import 'package:podcasks/ui/common/episode_menu.dart';
import 'package:podcasks/ui/common/home_episode_card.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/pages/episode_page.dart';
import 'package:podcasks/ui/pages/home/favourites_row.dart';
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
  void _initEpisodeList(
      EpisodesHomeViewmodel episodesVm, HomeViewmodel homeVm) {
    // final List<(MEpisode, MPodcast)>? saved = homeVm.saved;
    final favourites = homeVm.favourites;
    final list = <(MEpisode, MPodcast)>[];

    for (MPodcast p in favourites) {
      list.add((p.episodes.first, p));
      // TODO: next ep instead of last

      // list.addAll(
      //   p.episodes
      //       // .whereNot(
      //       //     ((e) => saved?.firstWhereOrNull((e1) => e1.$1 == e) != null))
      //       .map((e) => (e, p)),
      // );
      // list.sort((a, b) => b.$1.publicationDate != null
      //     ? a.$1.publicationDate?.compareTo(b.$1.publicationDate!) ?? 0
      //     : 0);
    }

    // if (saved != null) {
    //   list.addAll(saved);
    // }

    episodesVm.init(list.toList(), maxItems: 30);
  }

  @override
  void initState() {
    final homeVm = ref.read(homeViewmodel);
    final episodesVm = ref.read(episodesHomeViewmodel);
    _initEpisodeList(episodesVm, homeVm);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final homeVm = ref.watch(homeViewmodel);
    final episodesVm = ref.watch(episodesHomeViewmodel);
    final dm = ref.watch(downloadManager);

    homeVm.addListener(() {
      _initEpisodeList(episodesVm, homeVm);
    });

    if (episodesVm.displayingEpisodes.isEmpty) {
      // episodesVm.filterEpisodes([]);
      _initEpisodeList(episodesVm, homeVm);
    }

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
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: _welcomeContent(context, homeVm),
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: FavouritesRow(episodesVm: episodesVm, homeVm: homeVm),
                // ),
                Expanded(child: _episodesList(episodesVm, dm)),
              ],
            ),
    );
  }

  Widget _episodesList(EpisodesHomeViewmodel episodesVm, DownloadManager dm) {
    final playerVm = ref.watch(playerViewmodel);
    return GridView.count(
      crossAxisCount: 2,
      // physics: const ScrollPhysics(),
      scrollDirection: Axis.vertical,
      controller: episodesVm.controller,
      shrinkWrap: true,
      childAspectRatio: 0.7,
      padding: const EdgeInsets.all(12),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: episodesVm.displayingEpisodes
          .map((x) {
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
                  );
                },
                timeLeftOnEpisode: state.$1 == EpisodeState.finished ? null : state.$2 == null ? x.$1.duration.toEnlapsed() : state.$2?.toEnlapsed(),
              );
          })
          .toList(),
      // separatorBuilder: (BuildContext context, int index) => divider(context),
    );
  }

  Widget _welcomeContent(BuildContext context, HomeViewmodel homeVm) {
    return Center(
      child: Column(
        children: [
          Text(context.l10n!.welcome, style: textStyleBody),
          Text(context.l10n!.notFavouritesMessage, style: textStyleBody),
          const SizedBox(height: 8),
          Text(context.l10n!.bohEmoji, style: textStyleBody),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () {
              homeVm.setPage(Pages.search);
            },
            style: buttonStyle,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.search),
                const SizedBox(width: 8),
                Text(context.l10n!.explorePodcasts),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

sync(WidgetRef ref) async {
  final homeVm = ref.read(homeViewmodel);
  final epVm = ref.read(episodesHomeViewmodel);
  final lstVm = ref.read(listeningViewmodel);

  homeVm.syncing = true;
  homeVm.update();
  await homeVm.syncFavourites();
  await homeVm.fetchFavourites();
  await homeVm.fetchListening();
  epVm.initEpisodesList();
  await epVm.update();
  lstVm.initEpisodesList();
  await lstVm.update();
  homeVm.syncing = false;
  await homeVm.update();
}

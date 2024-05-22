import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/data/entities/episode/podcast_episode.dart';
import 'package:podcasks/data/entities/podcast/podcast_entity.dart';
import 'package:podcasks/manager/download_manager.dart';
import 'package:podcasks/ui/common/episode_item.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/pages/home/favourites_row.dart';
import 'package:podcasks/ui/vms/episodes_home_vm.dart';
import 'package:podcasks/ui/vms/home_vm.dart';
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
      list.addAll(
        p.episodes
            // .whereNot(
            //     ((e) => saved?.firstWhereOrNull((e1) => e1.$1 == e) != null))
            .map((e) => (e, p)),
      );
      list.sort((a, b) => b.$1.publicationDate != null
          ? a.$1.publicationDate?.compareTo(b.$1.publicationDate!) ?? 0
          : 0);
    }

    // if (saved != null) {
    //   list.addAll(saved);
    // }

    episodesVm.init(list.reversed.toList(), maxItems: 30);
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

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: FavouritesRow(episodesVm: episodesVm, homeVm: homeVm),
        ),
        (episodesVm.displayingEpisodes.isEmpty)
            ? _welcomeContent(context, homeVm)
            : Expanded(child: _episodesList(episodesVm, dm)),
      ],
    );
  }

  Widget _episodesList(EpisodesHomeViewmodel episodesVm, DownloadManager dm) =>
      ListView.builder(
        physics: const ScrollPhysics(),
        scrollDirection: Axis.vertical,
        controller: episodesVm.controller,
        shrinkWrap: true,
        itemCount: episodesVm.displayingEpisodes.length,
        itemBuilder: (context, i) {
          return EpisodeItem(
            vm: episodesVm,
            dm: dm,
            episode: episodesVm.displayingEpisodes[i].$1,
            podcast: episodesVm.displayingEpisodes[i].$2,
            showImage: true,
            showDesc: false,
          );
        },
      );

  Center _welcomeContent(BuildContext context, HomeViewmodel homeVm) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 64),
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
      ),
    );
  }
}

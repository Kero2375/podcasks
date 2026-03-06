import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/manager/download_manager.dart';
import 'package:podcasks/ui/common/divider.dart';
import 'package:podcasks/ui/common/episode_item.dart';
import 'package:podcasks/ui/common/opml_utils.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/pages/home/home_content.dart';
import 'package:podcasks/ui/vms/episodes_home_vm.dart';
import 'package:podcasks/ui/vms/home_vm.dart';
import 'package:podcasks/utils.dart';
import 'package:podcast_search/podcast_search.dart';

class ChronoPage extends ConsumerStatefulWidget {
  const ChronoPage({super.key});

  @override
  ConsumerState<ChronoPage> createState() => _ChronoPageState();
}

class _ChronoPageState extends ConsumerState<ChronoPage> {
  void _initEpisodeList(
      EpisodesHomeViewmodel episodesVm, HomeViewmodel homeVm) {
    // final List<(MEpisode, MPodcast)>? saved = homeVm.saved;
    final favourites = homeVm.favourites;
    final list = <(Episode, Podcast)>[];

    for (Podcast p in favourites) {
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

  Widget _episodesList(EpisodesHomeViewmodel episodesVm, DownloadManager dm) =>
      ListView.separated(
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
        separatorBuilder: (BuildContext context, int index) => divider(context),
      );

  Widget _welcomeContent(BuildContext context, HomeViewmodel homeVm) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                    children: [
                      const Icon(Icons.search),
                      const SizedBox(width: 8),
                      Text(context.l10n!.explorePodcasts),
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
                    children: [
                      const Icon(Icons.file_download_outlined),
                      const SizedBox(width: 8),
                      Text(context.l10n!.importOpml),
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
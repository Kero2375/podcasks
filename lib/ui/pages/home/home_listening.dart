import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/data/entities/episode/podcast_episode.dart';
import 'package:podcasks/data/entities/podcast/podcast_entity.dart';
import 'package:podcasks/manager/download_manager.dart';
import 'package:podcasks/ui/common/episode_item.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/vms/home_vm.dart';
import 'package:podcasks/ui/vms/listening_vm.dart';
import 'package:podcasks/utils.dart';

class ListeningPage extends ConsumerStatefulWidget {
  const ListeningPage({super.key});

  @override
  ConsumerState<ListeningPage> createState() => _HomeContentPageState();
}

class _HomeContentPageState extends ConsumerState<ListeningPage> {
  void _initEpisodeList(ListeningVm episodesVm, HomeViewmodel homeVm) {
    // homeVm.fetchListening();
    final List<(MEpisode, MPodcast)>? saved = homeVm.saved;
    episodesVm.init(
      saved?.map((e) => (e.$1, e.$2)).toList(),
      maxItems: 30,
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeVm = ref.watch(homeViewmodel);
    final vm = ref.watch(listeningVm);
    final dm = ref.watch(downloadManager);

    homeVm.addListener(() {
      _initEpisodeList(vm, homeVm);
    });

    if (vm.displayingEpisodes.isEmpty) {
      // TODO: check
      // episodesVm.filterEpisodes([]);
      _initEpisodeList(vm, homeVm);
    }

    return (vm.displayingEpisodes.isEmpty)
        ? _welcomeContent(context, homeVm)
        : _episodesList(vm, dm);
  }

  Widget _episodesList(ListeningVm episodesVm, DownloadManager dm) =>
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
            Text(context.l10n!.notListeningMessage, style: textStyleBody),
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

import 'dart:isolate';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/data/entities/episode/podcast_episode.dart';
import 'package:podcasks/data/entities/podcast/podcast_entity.dart';
import 'package:podcasks/manager/download_manager.dart';
import 'package:podcasks/ui/common/bottom_player.dart';
import 'package:podcasks/ui/common/episode_item.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/pages/home/favourites_row.dart';
import 'package:podcasks/ui/vms/episodes_home_vm.dart';
import 'package:podcasks/ui/vms/home_vm.dart';
import 'package:podcasks/ui/vms/listening_vm.dart';
import 'package:podcasks/ui/vms/player_vm.dart';

class ListeningPage extends ConsumerStatefulWidget {
  const ListeningPage({super.key});

  @override
  ConsumerState<ListeningPage> createState() => _HomeContentPageState();
}

class _HomeContentPageState extends ConsumerState<ListeningPage> {
  void _initEpisodeList(ListeningVm episodesVm, HomeViewmodel homeVm) {
    final List<(MEpisode, MPodcast)>? saved = homeVm.saved;
    episodesVm.init(
      saved?.map((e) => (e.$1, e.$2)).toList(),
      maxItems: 30,
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeVm = ref.watch(homeViewmodel);
    // final playerVm = ref.read(playerViewmodel);
    final episodesVm = ref.watch(listeningVm);
    final dm = ref.watch(downloadManager);

    homeVm.addListener(() {
      _initEpisodeList(episodesVm, homeVm);
    });

    if (episodesVm.displayingEpisodes.isEmpty) {
      // TODO: check
      // episodesVm.filterEpisodes([]);
      _initEpisodeList(episodesVm, homeVm);
    }

    return _episodesList(episodesVm, dm);
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
}

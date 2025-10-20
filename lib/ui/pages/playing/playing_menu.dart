import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/data/entities/episode/podcast_episode.dart';
import 'package:podcasks/data/entities/podcast/podcast_entity.dart';
import 'package:podcasks/manager/download_manager.dart';
import 'package:podcasks/ui/common/popup_menu_item.dart';
import 'package:podcasks/ui/vms/episodes_home_vm.dart';
import 'package:podcasks/ui/vms/list_vm.dart';
import 'package:podcasks/ui/vms/player_vm.dart';
import 'package:podcasks/ui/vms/podcast_vm.dart';
import 'package:podcasks/utils.dart';

class PlayingPopupMenu extends ConsumerWidget {
  final MEpisode? episode;
  final MPodcast? podcast;

  const PlayingPopupMenu(this.episode, this.podcast, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(episodesHomeViewmodel);
    final (epState, _) = vm.getEpisodeState(episode);

    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      shape: popupMenuShape(context),
      onSelected: (item) => _checkValue(context, item, ref, episode, podcast),
      itemBuilder: (BuildContext context) => [
        if (epState != EpisodeState.finished)
          popupMenuItem(
            value: 3,
            icon: const Icon(Icons.check),
            text: context.l10n!.markAsFinished,
          ),
        if (epState != EpisodeState.none)
          popupMenuItem(
            value: 4,
            icon: const Icon(Icons.delete_outline),
            text: context.l10n!.cancelProgress,
          ),
        popupMenuItem(
          value: 0,
          icon: const Icon(Icons.share),
          text: context.l10n!.share,
        ),
        popupMenuItem(
          value: 1,
          icon: const Icon(Icons.download),
          text: context.l10n!.download,
        ),
        popupMenuItem(
          value: 2,
          icon: const Icon(Icons.queue),
          text: context.l10n!.addToQueue,
        ),
      ],
    );
  }

  _checkValue(BuildContext context, int item, WidgetRef ref, MEpisode? episode,
      MPodcast? podcast) async {
    final dm = ref.read(downloadManager);
    final vm = ref.read(playerViewmodel);
    final epVm = ref.read(podcastViewmodel);

    switch (item) {
      case 0:
        vm.share(episode);
        break;
      case 1:
        dm.download(episode, context);
        break;
      case 2:
        await epVm.addToQueue(episode, podcast, context);
        break;
      case 3:
        epVm.markAsFinished(episode, podcast);
        break;
      case 4:
        epVm.cancelProgress(episode);
        break;
    }
  }
}

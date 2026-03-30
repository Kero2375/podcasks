import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcasks/manager/download_manager.dart';
import 'package:podcasks/ui/common/confirm_dialog.dart';
import 'package:podcasks/ui/common/popup_menu_item.dart';
import 'package:podcasks/ui/vms/downloads_vm.dart';
import 'package:podcasks/ui/vms/episodes_home_vm.dart';
import 'package:podcasks/ui/vms/home_vm.dart';
import 'package:podcasks/ui/vms/list_vm.dart';
import 'package:podcasks/ui/vms/player_vm.dart';
import 'package:podcasks/ui/vms/podcast_vm.dart';
import 'package:podcasks/utils.dart';

class PlayingPopupMenu extends ConsumerWidget {
  final Episode? episode;
  final Podcast? podcast;

  const PlayingPopupMenu(this.episode, this.podcast, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(episodesHomeViewmodel);
    final downloadsVm = ref.watch(downloadsViewmodel);
    final (epState, _) = vm.getEpisodeState(episode);

    final isDownloaded = downloadsVm.dummyPodcast.episodes
        .any((e) => e.contentUrl == episode?.contentUrl || e.guid == episode?.guid || e.title == episode?.title);

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
            icon: const Icon(Icons.clear_all_rounded),
            text: context.l10n!.cancelProgress,
          ),
        popupMenuItem(
          value: 0,
          icon: const Icon(Icons.share),
          text: context.l10n!.share,
        ),
        if (!isDownloaded)
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
        // if (isDownloaded)
        //   popupMenuItem(
        //     value: 5,
        //     icon: const Icon(Icons.delete),
        //     text: context.l10n!.delete,
        //     color: Theme.of(context).colorScheme.error.withAlpha(180),
        //   ),
      ],
    );
  }

  _checkValue(BuildContext context, int item, WidgetRef ref, Episode? episode,
      Podcast? podcast) async {
    final dm = ref.read(downloadManager);
    final vm = ref.read(playerViewmodel);
    final epVm = ref.read(podcastViewmodel);
    final homeVm = ref.read(homeViewmodel);
    final downloadsVm = ref.read(downloadsViewmodel);

    switch (item) {
      case 0:
        vm.share(episode);
        break;
      case 1:
        dm.download(episode, podcast, context);
        break;
      case 2:
        await epVm.addToQueue(episode, podcast, context);
        break;
      case 3:
        epVm.markAsFinished(episode, podcast, homeVm: homeVm);
        break;
      case 4:
        epVm.cancelProgress(episode, homeVm: homeVm);
        break;
      case 5:
        if (episode != null) {
          final downloadEp = downloadsVm.dummyPodcast.episodes.firstWhereOrNull(
              (e) => e.contentUrl == episode.contentUrl || e.guid == episode.guid || e.title == episode.title);
          if (downloadEp != null) {
            showDialog(
              context: context,
              builder: (context) => ConfirmDialog(
                title: context.l10n!.delete,
                message: context.l10n!.deleteEpisodeMessage(episode.title),
                actionText: context.l10n!.delete,
                actionIcon: const Icon(Icons.delete),
                onTap: () => downloadsVm.deleteEpisode(downloadEp),
              ),
            );
          }
        }
        break;
    }
  }
}

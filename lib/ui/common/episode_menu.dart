import 'package:flutter/material.dart';
import 'package:podcasks/data/entities/episode/podcast_episode.dart';
import 'package:podcasks/data/entities/podcast/podcast_entity.dart';
import 'package:podcasks/manager/download_manager.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/vms/list_vm.dart';
import 'package:podcasks/ui/vms/player_vm.dart';
import 'package:podcasks/utils.dart';

Future<int?> showEpisodeMenu({
  required BuildContext context,
  required EpisodeState value,
  required ListViewmodel vm,
  required PlayerViewmodel playerVm,
  required DownloadManager dm,
  required MEpisode? ep,
  required MPodcast? pd,
  required Offset tapPos,
}) {
  final screenSize = MediaQuery.of(context).size;
  return showMenu(
    // color: Theme.of(context).colorScheme.primaryContainer,
    shape: popupMenuShape(context),
    context: context,
    items: <PopupMenuEntry<int>>[
      if (value != EpisodeState.finished)
        episodeMenuItem<int>(
          message: context.l10n!.markAsFinished,
          icon: Icons.check,
          onTap: () => vm.markAsFinished(ep, pd),
        ),
      if (value != EpisodeState.none)
        episodeMenuItem<int>(
          message: context.l10n!.cancelProgress,
          icon: Icons.delete_outline,
          onTap: () => vm.cancelProgress(ep),
        ),
      episodeMenuItem<int>(
        message: context.l10n!.share,
        icon: Icons.share,
        onTap: () => playerVm.share(ep),
      ),
      episodeMenuItem<int>(
        message: context.l10n!.download,
        icon: Icons.download,
        onTap: () => dm.download(ep, context),
      ),
      episodeMenuItem<int>(
        message: context.l10n!.addToQueue,
        icon: Icons.queue,
        onTap: () async {
          await vm.addToQueue(ep, pd, context);
        },
      ),
    ],
    position: RelativeRect.fromRect(
        tapPos & const Size(40, 40), // smaller rect, the touch area
        Offset.zero & screenSize // Bigger rect, the entire screen
        ),
  );
}

PopupMenuItem<T> episodeMenuItem<T>({
  required String message,
  required IconData icon,
  required Function() onTap,
}) {
  return PopupMenuItem<T>(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(
            message,
            style: textStyleBody,
          ),
        ],
      ));
}

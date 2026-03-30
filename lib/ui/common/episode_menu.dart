import 'package:flutter/material.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcasks/manager/download_manager.dart';
import 'package:podcasks/ui/common/confirm_dialog.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/vms/downloads_vm.dart';
import 'package:podcasks/ui/vms/home_vm.dart';
import 'package:podcasks/ui/vms/list_vm.dart';
import 'package:podcasks/ui/vms/player_vm.dart';
import 'package:podcasks/utils.dart';

Future<int?> showEpisodeMenu({
  required BuildContext context,
  required EpisodeState value,
  required ListViewmodel vm,
  required PlayerViewmodel playerVm,
  required DownloadManager dm,
  required Episode? ep,
  required Podcast? pd,
  required Offset tapPos,
  HomeViewmodel? homeVm,
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
          onTap: () => vm.markAsFinished(ep, pd, homeVm: homeVm),
        ),
      if (value != EpisodeState.none)
        episodeMenuItem<int>(
          message: context.l10n!.cancelProgress,
          icon: Icons.clear_all_rounded,
          onTap: () => vm.cancelProgress(ep, homeVm: homeVm),
        ),
      episodeMenuItem<int>(
        message: context.l10n!.share,
        icon: Icons.share,
        onTap: () => playerVm.share(ep),
      ),
      if (vm is! DownloadsViewmodel)
        episodeMenuItem<int>(
          message: context.l10n!.download,
          icon: Icons.download,
          onTap: () => dm.download(ep, pd, context),
        ),

      episodeMenuItem<int>(
        message: context.l10n!.addToQueue,
        icon: Icons.queue,
        onTap: () async {
          await vm.addToQueue(ep, pd, context);
        },
      ),
      if (vm is DownloadsViewmodel && ep != null)
        episodeMenuItem<int>(
          message: context.l10n!.delete,
          icon: Icons.delete_forever,
          color: Theme.of(context).colorScheme.error,
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => ConfirmDialog(
                title: context.l10n!.delete,
                message: context.l10n!.deleteEpisodeMessage(ep.title),
                actionText: context.l10n!.delete,
                actionIcon: const Icon(Icons.delete),
                onTap: () => vm.deleteEpisode(ep),
              ),
            );
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
  Color? color,
}) {
  return PopupMenuItem<T>(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Text(
            message,
            style: textStyleBody.copyWith(color: color),
          ),
        ],
      ));
}

import 'package:flutter/material.dart';
import 'package:podcasks/data/podcast_episode.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/vms/list_vm.dart';

Future<int?> showEpisodeMenu({
  required BuildContext context,
  required EpisodeState value,
  required ListViewmodel vm,
  required PodcastEpisode? ep,
  required Offset tapPos,
}) {
  final screenSize = MediaQuery.of(context).size;
  return showMenu(
    context: context,
    items: <PopupMenuEntry<int>>[
      if (value != EpisodeState.finished)
        episodeMenuItem<int>(
          message: 'Mark as finished',
          icon: Icons.check,
          onTap: () => vm.markAsFinished(ep),
        ),
      if (value != EpisodeState.none)
        episodeMenuItem<int>(
          message: 'Cancel progress',
          icon: Icons.delete_outline,
          onTap: () => vm.cancelProgress(ep),
        ),
      // episodeMenuItem<int>(
      //   message: 'Add to queue',
      //   icon: Icons.queue_outlined,
      //   onTap: () {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(
      //         content: Text(
      //           "Queue is yet WIP :)",
      //           style: textStyleBody,
      //         ),
      //       ),
      //     );
      //   },
      // ),
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

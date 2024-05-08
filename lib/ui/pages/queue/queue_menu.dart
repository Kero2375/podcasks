import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:podcasks/data/entities/queue/queue_track.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/vms/podcast_vm.dart';
import 'package:podcasks/utils.dart';

Future<int?> showQueueMenu({
  required BuildContext context,
  required PodcastViewmodel vm,
  required QueueTrack track,
  required Offset tapPos,
}) {
  final screenSize = MediaQuery.of(context).size;
  return showMenu(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    context: context,
    items: <PopupMenuEntry<int>>[
      episodeMenuItem<int>(
        message: context.l10n!.removeFromQueue,
        icon: Icons.delete,
        onTap: () async {
          HapticFeedback.lightImpact();
          await vm.removeFromQueue(track);
          vm.update();
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

import 'package:flutter/material.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/vms/list_vm.dart';
import 'package:podcasks/utils.dart';
import 'package:podcast_search/podcast_search.dart';

class ListeningTag extends StatelessWidget {
  final Episode? ep;
  final EpisodeState episodeState;
  final EdgeInsets padding;
  final bool playing;
  final Duration? remaining;

  const ListeningTag({
    super.key,
    required this.ep,
    required this.episodeState,
    this.padding = const EdgeInsets.all(0),
    this.playing = false,
    this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    if (episodeState == EpisodeState.finished) {
      return tag(
        Theme.of(context).colorScheme.onBackground.withOpacity(.4),
        // Theme.of(context).colorScheme.tertiary.withOpacity(.6),
        'FINISHED',
        Icons.check,
      );
    } else if (playing) {
      return tag(
        Theme.of(context).colorScheme.primary.withOpacity(.8),
        'LISTENING',
        Icons.headphones,
      );
    } else if (episodeState case EpisodeState.started) {
      return tag(
        Theme.of(context).colorScheme.onBackground.withOpacity(.4),
        remaining != null ? parseRemainingTime(remaining!) : 'STARTED',
        Icons.bookmark,
      );
    }
    return const SizedBox.shrink();
  }

  Padding tag(Color color, String text, IconData icon) {
    return Padding(
      padding: padding,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: color,
          ),
          // color: Theme.of(context).colorScheme.primary.withOpacity(.8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 4),
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 8),
            Text(
              text,
              style: textStyleSmall.copyWith(color: color),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

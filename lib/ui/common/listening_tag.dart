import 'package:flutter/material.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/vms/list_vm.dart';
import 'package:podcast_search/podcast_search.dart';

class ListeningTag extends StatelessWidget {
  final Episode? ep;
  final Future<EpisodeState> Function(Episode? ep) isFinished;
  final EdgeInsets padding;
  final bool playing;

  const ListeningTag({
    super.key,
    required this.ep,
    required this.isFinished,
    this.padding = const EdgeInsets.all(0),
    this.playing = false,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ep != null ? isFinished(ep) : Future.value(false),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data case EpisodeState.finished) {
            return tag(
              Colors.greenAccent.withOpacity(.6),
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
          } else if (snapshot.data case EpisodeState.started) {
            return tag(
              Theme.of(context).colorScheme.onBackground.withOpacity(.4),
              'STARTED',
              Icons.bookmark,
            );
          }
        }
        return const SizedBox.shrink();
      },
    );
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

import 'package:flutter/material.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcast_search/podcast_search.dart';

class ListeningTag extends StatelessWidget {
  final Episode? ep;
  final Future Function(Episode?) isStarted;
  final EdgeInsets padding;

  const ListeningTag({
    super.key,
    required this.ep,
    required this.isStarted,
    this.padding = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ep != null ? isStarted(ep) : Future.value(false),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data) {
          Color textColor =
              Theme.of(context).colorScheme.onBackground.withOpacity(.4);
          return Padding(
            padding: padding,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: textColor,
                ),
                // color: Theme.of(context).colorScheme.primary.withOpacity(.8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 4),
                  Icon(Icons.headphones, size: 15, color: textColor),
                  const SizedBox(width: 8),
                  Text(
                    'LISTENING',
                    style: textStyleSmall.copyWith(color: textColor),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

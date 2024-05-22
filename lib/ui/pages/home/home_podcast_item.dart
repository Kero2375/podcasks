import 'package:flutter/material.dart';
import 'package:podcasks/data/entities/podcast/podcast_entity.dart';

class HomePodcastItem extends StatelessWidget {
  final MPodcast? podcast;
  final IconData? icon;
  final Function() onTap;
  final Function()? onLongTap;
  final bool selected;

  const HomePodcastItem({
    super.key,
    required this.selected,
    this.podcast,
    this.icon,
    required this.onTap,
    this.onLongTap,
  });

  double get size => 70;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongTap,
        child: Column(
          // crossAxisAlignment:CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(.1),
              ),
              clipBehavior: Clip.antiAlias,
              width: size,
              height: size,
              duration: animationDuration,
              curve: Curves.fastOutSlowIn,
              child: podcast?.image != null
                  ? Image.network(podcast!.image!)
                  : Icon(
                      icon!,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
            ),
            // const SizedBox(height: 8),
            // SizedBox(
            //   width: size,
            //   child: Text(
            //     podcast?.title ?? '',
            //     style: textStyleSmall,
            //     overflow: TextOverflow.ellipsis,
            //     maxLines: 1,
            //   ),
            // ),
            // Icon(Icons.keyboard_arrow_up),
            // AnimatedContainer(
            //   margin: const EdgeInsets.only(top: 8),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(1),
            //     color: Theme.of(context).colorScheme.secondary.withOpacity(.8),
            //   ),
            //   height: 2,
            //   width: selected ? 30 : 0,
            //   duration: animationDuration,
            //   curve: Curves.fastOutSlowIn,
            // ),
          ],
        ),
      ),
    );
  }

  Duration get animationDuration => const Duration(milliseconds: 500);
}

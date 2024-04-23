import 'package:flutter/material.dart';

class HomePodcastItem extends StatelessWidget {
  final String? image;
  final IconData? icon;
  final Function() onTap;
  final bool selected;

  const HomePodcastItem({
    super.key,
    required this.selected,
    this.image,
    this.icon,
    required this.onTap,
  });

  double get size => 70;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
      child: GestureDetector(
        onTap: onTap,
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
              child: image != null
                  ? Image.network(image!)
                  : Icon(
                      icon!,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
            ),
            // Icon(Icons.keyboard_arrow_up),
            AnimatedContainer(
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1),
                color: Theme.of(context).colorScheme.secondary.withOpacity(.8),
              ),
              height: 2,
              width: selected ? 30 : 0,
              duration: animationDuration,
              curve: Curves.fastOutSlowIn,
            ),
          ],
        ),
      ),
    );
  }

  Duration get animationDuration => const Duration(milliseconds: 500);
}

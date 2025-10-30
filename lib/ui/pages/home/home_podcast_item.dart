import 'package:cached_network_image/cached_network_image.dart';
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
        child: AnimatedContainer(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.onSurface.withAlpha(25),
          ),
          clipBehavior: Clip.antiAlias,
          width: size,
          height: size,
          duration: animationDuration,
          curve: Curves.fastOutSlowIn,
          child: podcast?.image != null
              ? CachedNetworkImage(imageUrl: podcast!.image!)
              : Icon(
                  icon!,
                  color: Theme.of(context).colorScheme.secondary,
                ),
        ),
      ),
    );
  }

  Duration get animationDuration => const Duration(milliseconds: 500);
}

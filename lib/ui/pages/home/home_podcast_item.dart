import 'package:flutter/material.dart';

const double size = 75;

class HomePodcastItem extends StatelessWidget {
  final String? image;
  final Widget? icon;
  final Function() onTap;
  final bool selected;

  const HomePodcastItem({
    super.key,
    required this.selected,
    this.image,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.secondary.withOpacity(.1),
            border: selected
                ? Border.all(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(.5),
                    width: 4,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  )
                : null,
          ),
          clipBehavior: Clip.antiAlias,
          width: size,
          height: size,
          child: image != null
              ? Image.network(
                  image!,
                )
              : icon ?? Icons.error as Widget,
        ),
      ),
    );
  }
}

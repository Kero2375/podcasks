import 'package:flutter/material.dart';

class TabIcon extends StatelessWidget {
  final IconData icon;
  final bool selected;

  const TabIcon({super.key, required this.icon, required this.selected});

  @override
  Widget build(BuildContext context) {
    Color foreground = selected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurface;
    Color background = selected
        ? Theme.of(context).colorScheme.primaryContainer
        : Colors.transparent;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: background,
      ),
      width: 60,
      height: 30,
      child: Icon(icon, color: foreground),
    );
  }
}

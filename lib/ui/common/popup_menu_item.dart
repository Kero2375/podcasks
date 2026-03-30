import 'package:flutter/material.dart';
import 'package:podcasks/ui/common/themes.dart';

PopupMenuItem<T> popupMenuItem<T>({
  required T value,
  required Icon icon,
  required String text,
  Color? color,
}) =>
    PopupMenuItem<T>(
      value: value,
      child: Row(
        children: [
          Icon(icon.icon, color: color),
          const SizedBox(width: 8),
          Flexible(
            flex: 1,
            child: Text(
              text,
              style: textStyleBody.copyWith(color: color),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );

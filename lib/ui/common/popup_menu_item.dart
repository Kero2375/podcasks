import 'package:flutter/material.dart';
import 'package:podcasks/ui/common/themes.dart';

PopupMenuItem<T> popupMenuItem<T>({
  required T value,
  required Icon icon,
  required String text,
}) =>
    PopupMenuItem<T>(
      value: value,
      child: Row(
        children: [
          icon,
          const SizedBox(width: 8),
          Flexible(
            flex: 1,
            child: Text(
              text,
              style: textStyleBody,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/utils.dart';

const int maxDropdownLength = 15;

class FilterDropdown<T> extends StatelessWidget {
  final void Function(T?) onChanged;
  final T? value;
  final Map<T, T> items;
  final String Function(T) getString;

  const FilterDropdown({
    super.key,
    required this.onChanged,
    required this.value,
    required this.items,
    required this.getString,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      borderRadius: BorderRadius.circular(12),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      menuMaxHeight: 600,
      onChanged: onChanged,
      value: value,
      items: items.entries
          .map((entry) => MapEntry(
              null,
              DropdownMenuItem<T>(
                alignment: Alignment.center,
                value: entry.key,
                child: Text(
                  _formatForMenu(getString(entry.value), context),
                  style: textStyleBody.copyWith(color: Theme.of(context).colorScheme.onBackground),
                ),
              )))
          .map((e) => e.value)
          .toList(),
      style: textStyleBody,
    );
  }
}

String _formatForMenu(String c, BuildContext context) {
  final s = c.split(RegExp(r"(?=[A-Z])")).map((e) => e[0].toUpperCase() + e.substring(1)).join(' ');
  if (s == 'None' || s == 'All') {
    return context.l10n!.all;
  }
  // return s;
  if (s.length < maxDropdownLength + 3) {
    return s;
  } else {
    return '${s.substring(0, min(s.length, maxDropdownLength))}...';
  }
}

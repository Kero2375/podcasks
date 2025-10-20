import 'package:flutter/material.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/utils.dart';

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
      initialValue: value,
      items: items.entries
          .map((entry) => MapEntry(
              null,
              DropdownMenuItem<T>(
                alignment: Alignment.center,
                value: entry.key,
                child: Text(
                  getString(entry.value).capitalize(context),
                  style: textStyleBody.copyWith(
                      color: Theme.of(context).colorScheme.onSurface),
                ),
              )))
          .map((e) => e.value)
          .toList(),
      style: textStyleBody,
    );
  }
}

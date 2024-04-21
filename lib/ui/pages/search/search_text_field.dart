import 'package:flutter/material.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/pages/search/filters_dialog.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String term)? search;
  final Function? init;
  final bool showFilters;
  final String hint;

  const SearchTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.search,
    this.init,
    this.showFilters = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.secondaryContainer,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        autofocus: true,
        decoration: InputDecoration(
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
          hintText: hint,
          suffixIcon: showFilters
              ? IconButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => const FiltersDialog(),
                  ),
                  icon: const Icon(Icons.filter_alt),
                )
              : null,
        ),
        style: textStyleBody,
        controller: controller,
        onChanged: (value) {
          if (value.trim().isNotEmpty) {
            search?.call(value);
          } else {
            init?.call();
          }
        },
      ),
    );
  }
}

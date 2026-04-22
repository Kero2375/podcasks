import 'package:flutter/material.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/pages/search/filters_dialog.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String term)? search;
  final Function? init;
  final bool showFilters;
  final String hint;
  final Function? clear;
  final bool isSearching;

  const SearchTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.search,
    this.init,
    this.showFilters = false,
    required this.clear,
    this.isSearching = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = controller.text.trim() == '';
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.secondaryContainer,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        // autofocus: true,
        decoration: InputDecoration(
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
          hintText: hint,
          prefixIcon: isSearching
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => init?.call(),
                )
              : Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(127),
                ),
          suffixIcon: SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (showFilters)
                  IconButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => const FiltersDialog(),
                    ),
                    icon: const Icon(Icons.filter_alt_outlined),
                  ),
                if (!isEmpty)
                  IconButton(
                    onPressed: () {
                      clear?.call();
                    },
                    icon: const Icon(Icons.backspace),
                  ),
              ],
            ),
          ),
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

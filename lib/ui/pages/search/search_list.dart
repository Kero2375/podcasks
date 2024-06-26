import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcasks/ui/pages/search/search_list_item.dart';

class SearchList extends StatelessWidget {
  final List<Item> items;

  const SearchList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: items.mapIndexed((i, e) => SearchListItem(item: e, index: i)).toList(),
    );
  }
}
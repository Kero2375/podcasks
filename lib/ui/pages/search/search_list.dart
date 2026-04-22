import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcasks/ui/pages/search/search_list_item.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/ui/vms/search_vm.dart';

class SearchList extends ConsumerWidget {
  final List<Item> items;
  final ScrollController? controller;

  const SearchList({super.key, required this.items, this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loadingMore = ref.watch(searchViewmodel).loadingMore;
    return ListView(
      controller: controller,
      children: [
        ...items.mapIndexed((i, e) => SearchListItem(item: e, index: i)),
        if (loadingMore)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32.0),
            child: Center(
              child: CircularProgressIndicator(
                strokeCap: StrokeCap.round,
              ),
            ),
          ),
      ],
    );
  }
}
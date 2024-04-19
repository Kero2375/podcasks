import 'package:flutter/material.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcasks/ui/common/search_list_item.dart';

class SearchList extends StatelessWidget {
  final List<Item> items;

  const SearchList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children:
          // <Widget>[
          //       SingleChildScrollView(
          //         scrollDirection: Axis.horizontal,
          //         child: Row(
          //           mainAxisSize: MainAxisSize.min,
          //           children: List.filled(10, box(context)),
          //         ),
          //       )
          //     ] +
          items.map((e) => SearchListItem(item: e)).toList(),
    );
  }
}

Widget box(context) => Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.primary,
        ),
        height: 80,
        width: 80,
        child: Center(
          child: Text(
            "Top 10 Italy",
            style: textStyleBody.copyWith(
                color: Theme.of(context).colorScheme.onPrimary),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );

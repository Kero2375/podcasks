import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:ppp2/ui/common/bottom_player.dart';
import 'package:ppp2/ui/common/podcast_list_item.dart';

class PodcastList extends StatelessWidget {
  final List<Podcast> items;

  const PodcastList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ...items
            .mapIndexed(
              (i, e) => PodcastListItem(podcast: e, isLast: i == items.length - 1),
            )
            .toList(),
        const SizedBox(height: BottomPlayer.playerHeight),
      ],
    );
  }
}

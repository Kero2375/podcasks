import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:podcasks/data/entities/podcast/podcast_entity.dart';
import 'package:podcasks/ui/common/bottom_player.dart';
import 'package:podcasks/ui/pages/favourites/podcast_list_item.dart';

class PodcastList extends StatelessWidget {
  final List<PodcastEntity> items;

  const PodcastList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...items
            .sorted((a, b) {
              final dateA = a.title;
              final dateB = b.title;
              return (dateA != null && dateB != null)
                  ? dateA.compareTo(dateB)
                  : 0;
            })
            .mapIndexed(
              (i, e) =>
                  PodcastListItem(podcast: e, isLast: i == items.length - 1),
            )
            .toList(),
        const SizedBox(height: BottomPlayer.playerHeight),
      ],
    );
  }
}

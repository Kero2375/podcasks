import 'package:flutter/material.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:ppp2/ui/common/podcast_list_item.dart';
import 'package:ppp2/ui/player/bottom_player.dart';

class PodcastList extends StatelessWidget {
  final List<Podcast> items;

  const PodcastList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ...items.map((e) => PodcastListItem(podcast: e)).toList(),
        const SizedBox(height: BottomPlayer.playerHeight),
      ],
    );
  }
}

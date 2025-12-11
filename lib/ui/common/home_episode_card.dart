
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:podcasks/data/entities/episode/podcast_episode.dart';
import 'package:podcasks/data/entities/podcast/podcast_entity.dart';

class HomeEpisodeCard extends StatelessWidget {
  const HomeEpisodeCard({super.key, required this.episode, required this.podcast, required this.onTap, required this.onLongTap});

  final MEpisode episode;
  final MPodcast podcast;
  final Function onTap;
  final Function onLongTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onPrimary,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => onTap(),
        onLongPress: () => onLongTap(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (podcast.image != null) Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                    child: CachedNetworkImage(imageUrl: podcast.image!),
                  ),
              ),
              if (podcast.title != null) Text(podcast.title!, maxLines: 1, overflow: TextOverflow.ellipsis,),
              Text(episode.title, maxLines: 2,  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcasks/ui/common/themes.dart';

class HomeEpisodeCard extends StatefulWidget {
  const HomeEpisodeCard({
    super.key,
    required this.episode,
    required this.podcast,
    required this.onPlayTap,
    required this.onCardTap,
    required this.onLongTap,
    this.timeLeftOnEpisode,
  });

  final Episode episode;
  final Podcast podcast;
  final Function onPlayTap;
  final Function onCardTap;
  final Function(Offset) onLongTap;
  final String? timeLeftOnEpisode;

  @override
  State<HomeEpisodeCard> createState() => _HomeEpisodeCardState();
}

class _HomeEpisodeCardState extends State<HomeEpisodeCard> {
  Offset _tapPos = Offset.zero;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onPrimary,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () => widget.onCardTap(),
          onTapDown: (details) =>
              setState(() => _tapPos = details.globalPosition),
          onLongPress: () => widget.onLongTap(_tapPos),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.podcast.image != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CachedNetworkImage(
                      imageUrl: widget.podcast.image!,
                    ),
                  ),
                ),
              if (widget.podcast.title != null && widget.timeLeftOnEpisode == null)
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(width: 4),
                      Icon(
                        Icons.check,
                        // size: 18,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(127),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          maxLines: 3,
                          widget.podcast.title!,
                          overflow: TextOverflow.ellipsis,
                          style: textStyleBody.copyWith(
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              if (widget.timeLeftOnEpisode != null)
                Expanded(
                  child: Text(
                    widget.episode.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textStyleBody,
                  ),
                ),
              if (widget.timeLeftOnEpisode != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${widget.podcast.episodes.reversed.toList().indexWhere((e) => e == widget.episode) + 1}/${widget.podcast.episodes.length}",
                      overflow: TextOverflow.ellipsis,
                      style: textStyleSmall.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(127),
                      ),
                    ),
                    if (widget.timeLeftOnEpisode != null)
                      SizedBox(
                        height: 26,
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                              padding: const EdgeInsets.fromLTRB(4, 0, 8, 0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          onPressed: () => widget.onPlayTap(),
                          label: Text(
                            widget.timeLeftOnEpisode ?? '',
                            style: textStyleSmall,
                          ),
                          icon: const Icon(Icons.play_arrow),
                        ),
                      )
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}

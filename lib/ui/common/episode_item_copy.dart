import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/data/entities/podcast/podcast_entity.dart';
import 'package:podcasks/data/entities/episode/podcast_episode.dart';
import 'package:podcasks/manager/download_manager.dart';
import 'package:podcasks/ui/common/divider.dart';
import 'package:podcasks/ui/common/episode_menu.dart';
import 'package:podcasks/ui/common/listening_tag.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/pages/episode_page.dart';
import 'package:podcasks/ui/pages/podcast/podcast_page.dart';
import 'package:podcasks/ui/vms/list_vm.dart';
import 'package:podcasks/ui/vms/player_vm.dart';
import 'package:podcasks/utils.dart';

class EpisodeItem extends ConsumerStatefulWidget {
  final bool showImage;
  final bool showDesc;
  final MEpisode? episode;
  final MPodcast? podcast;
  final ListViewmodel vm;
  final DownloadManager dm;

  const EpisodeItem({
    super.key,
    this.episode,
    this.podcast,
    required this.showImage,
    required this.showDesc,
    required this.vm,
    required this.dm,
  });

  @override
  ConsumerState<EpisodeItem> createState() => _HomeEpisodeItemState();
}

class _HomeEpisodeItemState extends ConsumerState<EpisodeItem> {
  Offset _tapPos = Offset.zero;
  MEpisode? get episode => widget.episode;
  MPodcast? get podcast => widget.podcast;
  String? get image => podcast?.image;
  ListViewmodel get episodesVm => widget.vm;
  DownloadManager get downloadManager => widget.dm;

  @override
  Widget build(BuildContext context) {
    final (episodeState, remaining) = episodesVm.getEpisodeState(episode);

    return InkWell(
      onTap: () =>
          Navigator.pushNamed(context, EpisodePage.route, arguments: (episode, podcast)),
      onTapDown: (details) => setState(() => _tapPos = details.globalPosition),
      onLongPress: () {
        showEpisodeMenu(
          context: context,
          value: episodeState,
          vm: episodesVm,
          dm: downloadManager,
          playerVm: ref.read(playerViewmodel),
          ep: episode,
          pd: podcast,
          tapPos: _tapPos,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          divider(context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.showImage) ...[
                  _podcastImage(context),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListeningTag(
                        ep: episode,
                        episodeState: episodeState,
                        remaining: remaining,
                        padding: const EdgeInsets.only(bottom: 4),
                        playing:
                            ref.read(playerViewmodel).playing?.contentUrl ==
                                episode?.contentUrl,
                      ),
                      Text(
                        episode?.publicationDate?.toDate() ?? '',
                        style: textStyleSmallGray(context),
                      ),
                      Text(
                        episode?.title ?? '',
                        style: textStyleHeader,
                        overflow: TextOverflow.fade,
                      ),
                      if (widget.showDesc)
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 104),
                          // child: Html(
                          //   data: episode?.description ?? '',
                          //   style: {'*': htmlStyle(margin: Margins.zero)},
                          // ),
                          child: Text(
                            HtmlParser.parseHTML(episode?.description ?? '')
                                .text,
                            style: textStyleBody,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector _podcastImage(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, PodcastPage.route,
          arguments: podcast),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            if (image != null)
              CachedNetworkImage(
                imageUrl: image!,
                height: 40,
                width: 40,
              ),
          ],
        ),
      ),
    );
  }
}

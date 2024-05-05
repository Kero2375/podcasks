import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/data/podcast_episode.dart';
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
  final PodcastEpisode? episode;
  final ListViewmodel vm;

  const EpisodeItem({
    super.key,
    this.episode,
    required this.showImage,
    required this.showDesc,
    required this.vm,
  });

  @override
  ConsumerState<EpisodeItem> createState() => _HomeEpisodeItemState();
}

class _HomeEpisodeItemState extends ConsumerState<EpisodeItem> {
  Offset _tapPos = Offset.zero;
  PodcastEpisode? get episode => widget.episode;
  String? get image => episode?.podcast?.image;
  ListViewmodel get episodesVm => widget.vm;

  @override
  Widget build(BuildContext context) {
    final (episodeState, remaining) = episodesVm.getEpisodeState(episode);

    return InkWell(
      onTap: () =>
          Navigator.pushNamed(context, EpisodePage.route, arguments: episode),
      onTapDown: (details) => setState(() => _tapPos = details.globalPosition),
      onLongPress: () {
        showEpisodeMenu(
          context: context,
          value: episodeState,
          vm: episodesVm,
          playerVm: ref.read(playerViewmodel),
          ep: episode,
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
          arguments: episode?.podcast),
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
              Image.network(
                image!,
                height: 40,
                width: 40,
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcasks/data/podcast_episode.dart';
import 'package:podcasks/ui/common/app_bar.dart';
import 'package:podcasks/ui/common/bottom_player.dart';
import 'package:podcasks/ui/common/divider.dart';
import 'package:podcasks/ui/common/fav_button.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/pages/episode_page.dart';
import 'package:podcasks/ui/vms/podcast_vm.dart';
import 'package:podcasks/utils.dart';

class PodcastPage extends ConsumerStatefulWidget {
  static const route = '/podcast_page';
  final Podcast? podcast;

  const PodcastPage(this.podcast, {super.key});

  @override
  ConsumerState<PodcastPage> createState() => _PodcastPageState();
}

class _PodcastPageState extends ConsumerState<PodcastPage> {
  @override
  void initState() {
    final vm = ref.read(podcastViewmodel);
    vm.init(widget.podcast?.episodes
        .map((e) => PodcastEpisode.fromEpisode(e))
        .toList());
    super.initState();
  }

  void handleClick(bool item, PodcastViewmodel vm) {
    vm.setNewerFirst(item);
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(podcastViewmodel);
    return Scaffold(
      appBar: mainAppBar(
        context,
        title: widget.podcast?.title,
        actions: PopupMenuButton(
          icon: const Icon(Icons.sort),
          onSelected: (item) => handleClick(item, vm),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: false,
              child: Row(
                children: [
                  const Icon(Icons.arrow_downward),
                  const SizedBox(width: 8),
                  Text('Older first', style: textStyleBody),
                ],
              ),
            ),
            PopupMenuItem(
              value: true,
              child: Row(
                children: [
                  const Icon(Icons.arrow_upward),
                  const SizedBox(width: 8),
                  Text('Newer first', style: textStyleBody),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        controller: vm.controller,
        child: (widget.podcast == null)
            ? Center(child: Text("Error", style: textStyleBody))
            : Column(
                children: [
                  _image(widget.podcast!),
                  Html(
                    data: widget.podcast!.description ?? '',
                    style: {
                      '*': Style(
                        margin: Margins.all(8),
                        fontFamily: themeFontFamily.fontFamily,
                      ),
                    },
                  ),
                  _favButton(),
                  _episodes(vm),
                  // if (vm.displayingEpisodes.length < (vm.podcast?.episodes.length ?? 0))
                  //   const CircularProgressIndicator(),
                  const SizedBox(height: BottomPlayer.playerHeight),
                ],
              ),
      ),
      bottomSheet: const BottomPlayer(),
    );
  }

  Widget _favButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: FavButton(widget.podcast!),
    );
  }

  Widget _episodes(PodcastViewmodel vm) {
    return ListView.builder(
      physics: const PageScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: vm.displayingEpisodes.length,
      itemBuilder: (context, i) => _episode(context, vm.displayingEpisodes[i]),
    );
  }

  Widget _episode(BuildContext context, Episode? ep) {
    return InkWell(
      onTap: () {
        if (ep != null && widget.podcast != null) {
          Navigator.pushNamed(context, EpisodePage.route,
              arguments:
                  PodcastEpisode.fromEpisode(ep, podcast: widget.podcast!));
        }
      },
      child: Column(
        children: [
          divider(context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  ep?.publicationDate?.toDate() ?? '',
                  style: textStyleSmallGray(context),
                ),
                Text(
                  ep?.title ?? '',
                  style: textStyleHeader,
                ),
                Html(
                  data: ep?.description ?? '',
                  style: {
                    '*': Style(
                      maxLines: 3,
                      margin: Margins.zero,
                      textOverflow: TextOverflow.ellipsis,
                      fontFamily: themeFontFamily.fontFamily,
                    ),
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _image(Podcast item) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
      clipBehavior: Clip.antiAlias,
      width: 120,
      height: 120,
      child: Image.network(item.image ?? ''),
    );
  }
}

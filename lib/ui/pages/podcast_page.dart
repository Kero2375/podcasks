import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/ui/common/listening_tag.dart';
import 'package:podcasks/ui/common/search_text_field.dart';
import 'package:podcasks/ui/vms/list_vm.dart';
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
  // @override
  _initEpisodeList(ListViewmodel vm) {
    if (vm.displayingEpisodes.isEmpty) {
      vm.init(
        widget.podcast?.episodes
            .map((e) => PodcastEpisode.fromEpisode(e))
            .toList(),
      );
    }
    // super.initState();
  }

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
    // _initEpisodesList();
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(podcastViewmodel);

    vm.addListener(() => _initEpisodeList(vm));

    _initEpisodeList(vm);

    return Scaffold(
      appBar: vm.searchController == null
          ? mainAppBar(
              context,
              title: widget.podcast?.title,
              actions: IconButton(
                onPressed: () {
                  vm.showSearch();
                },
                icon: const Icon(Icons.search),
              ),
              // actions: _sortMenuButton(vm),
            )
          : AppBar(
              title: SearchTextField(
                controller: vm.searchController!,
                hint: 'Search in ${widget.podcast?.title ?? 'podcast'}',
                search: vm.search,
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    vm.hideSearch();
                  },
                  icon: const Icon(Icons.close),
                )
              ],
            ),
      body: RefreshIndicator(
        onRefresh: () async {
          vm.initEpisodesList();
          await vm.update();
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
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
                    _buttons(vm),
                    _episodes(vm),
                    // if (vm.displayingEpisodes.length < (vm.podcast?.episodes.length ?? 0))
                    //   const CircularProgressIndicator(),
                    const SizedBox(height: BottomPlayer.playerHeight),
                  ],
                ),
        ),
      ),
      bottomSheet: const BottomPlayer(),
    );
  }

  PopupMenuButton<bool> _sortMenuButton(PodcastViewmodel vm) {
    return PopupMenuButton(
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
    );
  }

  Widget _buttons(PodcastViewmodel vm) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FavButton(widget.podcast!),
          _sortMenuButton(vm),
        ],
      ),
    );
  }

  Widget _episodes(PodcastViewmodel vm) {
    return ListView.builder(
      physics: const PageScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: vm.displayingEpisodes.length,
      itemBuilder: (context, i) =>
          _episode(context, vm.displayingEpisodes[i], vm.isStarted),
    );
  }

  Widget _episode(
      BuildContext context, Episode? ep, Future Function(Episode?) isStarted) {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListeningTag(
                    ep: ep,
                    isStarted: isStarted,
                    padding: const EdgeInsets.only(bottom: 8)),
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

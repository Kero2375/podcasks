import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/data/podcast_episode.dart';
import 'package:podcasks/ui/common/app_bar.dart';
import 'package:podcasks/ui/common/bottom_player.dart';
import 'package:podcasks/ui/common/fav_button.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/pages/home/episode_item.dart';
import 'package:podcasks/ui/pages/search/search_text_field.dart';
import 'package:podcasks/ui/vms/home_vm.dart';
import 'package:podcasks/ui/vms/list_vm.dart';
import 'package:podcasks/ui/vms/podcast_vm.dart';
import 'package:podcast_search/podcast_search.dart';

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
        widget.podcast?.episodes.map((e) => PodcastEpisode.fromEpisode(e)).toList(),
      );
    }
    // super.initState();
  }

  @override
  void initState() {
    final vm = ref.read(podcastViewmodel);
    vm.init(widget.podcast?.episodes
        .map((e) => PodcastEpisode.fromEpisode(e, podcast: widget.podcast))
        .toList());
    super.initState();
  }

  void handleSort(bool item, PodcastViewmodel vm) {
    vm.setNewerFirst(item);
  }

  void handleMore(int action, PodcastViewmodel vm, Podcast? podcast) {
    switch (action) {
      case 0:
        vm.markAllAsFinished(podcast);
        break;
      case 1:
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "Delete Progress",
              style: textStyleHeader,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Are you sure you want to delete all progress for \"${podcast?.title}\"?",
                  style: textStyleBody,
                ),
                const SizedBox(height: 8),
                Text(
                  "ಠ_ಠ",
                  style: textStyleBody,
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: buttonStyle,
                child: const Text('Cancel'),
              ),
              FilledButton.icon(
                icon: const Icon(Icons.warning),
                onPressed: () {
                  vm.deleteAll(podcast);
                  Navigator.of(context).pop();
                },
                style: buttonStyle,
                label: const Text('Delete'),
              ),
            ],
          ),
        );
        break;
    }
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
          await ref.read(homeViewmodel).fetchListening();
          await vm.update();
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
      onSelected: (item) => handleSort(item, vm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
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

  PopupMenuButton<int> _moreMenuButton(PodcastViewmodel vm) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      onSelected: (item) => handleMore(item, vm, widget.podcast),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          child: Row(
            children: [
              const Icon(Icons.done_all),
              const SizedBox(width: 8),
              Text('Mark all as finished', style: textStyleBody),
            ],
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              const Icon(Icons.delete_forever),
              const SizedBox(width: 8),
              Text('Delete progress', style: textStyleBody),
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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _sortMenuButton(vm),
              _moreMenuButton(vm),
            ],
          ),
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
      itemBuilder: (context, i) {
        final ep = vm.displayingEpisodes[i];
        ep.podcast ??= widget.podcast;

        return EpisodeItem(
          vm: vm,
          episode: ep,
          showImage: false,
          showDesc: true,
        );
      },
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

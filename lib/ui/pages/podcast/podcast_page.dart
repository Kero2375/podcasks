import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/data/podcast_episode.dart';
import 'package:podcasks/manager/download_manager.dart';
import 'package:podcasks/ui/common/app_bar.dart';
import 'package:podcasks/ui/common/bottom_player.dart';
import 'package:podcasks/ui/common/confirm_dialog.dart';
import 'package:podcasks/ui/common/fav_button.dart';
import 'package:podcasks/ui/common/popup_menu_item.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/common/episode_item.dart';
import 'package:podcasks/ui/pages/search/search_text_field.dart';
import 'package:podcasks/ui/vms/home_vm.dart';
import 'package:podcasks/ui/vms/list_vm.dart';
import 'package:podcasks/ui/vms/podcast_vm.dart';
import 'package:podcasks/utils.dart';
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
        .map((e) => PodcastEpisode.fromEpisode(e, podcast: widget.podcast))
        .toList());
    super.initState();
  }

  void handleSort(bool item, PodcastViewmodel vm) {
    vm.setNewerFirst(item);
  }

  void handleMore(
      int action, Podcast? podcast, PodcastViewmodel vm, DownloadManager dm) {
    switch (action) {
      case 0:
        showDialog(
          context: context,
          builder: (context) => ConfirmDialog(
            title: context.l10n!.markAllFinished,
            actionText: context.l10n!.confirm,
            actionIcon: const Icon(Icons.check),
            message: context.l10n!.markAllFinishedMessage(podcast?.title ?? ''),
            // emoji: 'ಠ_ಠ',
            onTap: () {
              vm.markAllAsFinished(podcast);
            },
          ),
        );
        break;
      case 1:
        showDialog(
          context: context,
          builder: (context) => ConfirmDialog(
            title: context.l10n!.deleteProgress,
            actionText: context.l10n!.delete,
            actionIcon: const Icon(Icons.warning),
            message: context.l10n!.deleteProgressMessage(podcast?.title ?? ''),
            emoji: context.l10n!.deleteAllEmoji,
            onTap: () {
              vm.deleteAll(podcast);
            },
          ),
        );
        break;
      case 2:
        showDialog(
          context: context,
          builder: (context) => ConfirmDialog(
            title: context.l10n!.downloadAll,
            actionText: context.l10n!.download,
            actionIcon: const Icon(Icons.file_download_outlined),
            message: context.l10n!.downloadMessage(vm.episodes?.length ?? 0),
            // emoji: context.l10n!.deleteAllEmoji,
            onTap: () {
              dm.downloadAll(vm.episodes ?? [], context);
            },
          ),
        );
        break;
      case 3:
        showDialog(
          context: context,
          builder: (context) => ConfirmDialog(
            title: context.l10n!.stopDownloads,
            actionText: context.l10n!.stop,
            actionIcon: const Icon(Icons.file_download_off_outlined),
            message: context.l10n!.stopMessage,
            // emoji: context.l10n!.deleteAllEmoji,
            onTap: () {
              dm.cancelDownloads();
            },
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(podcastViewmodel);
    final dm = ref.watch(downloadManager);

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
                hint: context.l10n!
                    .searchIn(widget.podcast?.title ?? context.l10n!.podcast),
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
              ? Center(child: Text(context.l10n!.error, style: textStyleBody))
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
                    _buttons(vm, dm),
                    _episodes(vm, dm),
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
              Text(context.l10n!.olderFirst, style: textStyleBody),
            ],
          ),
        ),
        PopupMenuItem(
          value: true,
          child: Row(
            children: [
              const Icon(Icons.arrow_upward),
              const SizedBox(width: 8),
              Text(context.l10n!.newerFirst, style: textStyleBody),
            ],
          ),
        ),
      ],
    );
  }

  PopupMenuButton<int> _moreMenuButton(
      PodcastViewmodel vm, DownloadManager dm) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      onSelected: (item) => handleMore(item, widget.podcast, vm, dm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      itemBuilder: (context) => [
        popupMenuItem(
          value: 0,
          icon: const Icon(Icons.done_all),
          text: context.l10n!.markAllFinished,
        ),
        popupMenuItem(
          value: 1,
          icon: const Icon(Icons.delete_forever),
          text: context.l10n!.deleteProgress,
        ),
        if (dm.status != DownloadTaskStatus.running.index)
          popupMenuItem(
            value: 2,
            icon: const Icon(Icons.file_download_outlined),
            text: context.l10n!.downloadAll,
          ),
        if (dm.status == DownloadTaskStatus.running.index)
          popupMenuItem(
            value: 3,
            icon: const Icon(Icons.file_download_off_outlined),
            text: context.l10n!.stopDownloads,
          ),
      ],
    );
  }

  Widget _buttons(PodcastViewmodel vm, DownloadManager dm) {
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
              _moreMenuButton(vm, dm),
            ],
          ),
        ],
      ),
    );
  }

  Widget _episodes(PodcastViewmodel vm, DownloadManager dm) {
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
          dm: dm,
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

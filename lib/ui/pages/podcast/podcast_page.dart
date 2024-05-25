import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/data/entities/podcast/podcast_entity.dart';
import 'package:podcasks/manager/download_manager.dart';
import 'package:podcasks/ui/common/app_bar.dart';
import 'package:podcasks/ui/common/bottom_player.dart';
import 'package:podcasks/ui/common/fav_button.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/common/episode_item.dart';
import 'package:podcasks/ui/pages/podcast/more_button.dart';
import 'package:podcasks/ui/pages/search/search_text_field.dart';
import 'package:podcasks/ui/vms/podcast_vm.dart';
import 'package:podcasks/ui/vms/vm.dart';
import 'package:podcasks/utils.dart';

class PodcastPage extends ConsumerStatefulWidget {
  static const route = '/podcast_page';
  final MPodcast? podcast;

  const PodcastPage(this.podcast, {super.key});

  @override
  ConsumerState<PodcastPage> createState() => _PodcastPageState();
}

class _PodcastPageState extends ConsumerState<PodcastPage> {
  String? get title => widget.podcast?.title;
  bool expanded = false;

  // @override
  _initEpisodeList(PodcastViewmodel vm) async {
    if (vm.displayingEpisodes.isEmpty) {
      vm.initPodcast(widget.podcast);
    }
    // super.initState();
  }

  _firstInit() async {
    final vm = ref.read(podcastViewmodel);
    vm.loading();
    await vm.initPodcast(widget.podcast);
    vm.success();
  }

  @override
  initState() {
    _firstInit();
    super.initState();
  }

  void handleSort(bool item, PodcastViewmodel vm) {
    vm.setNewerFirst(item);
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
              title: title,
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
                hint: context.l10n!.searchIn(title ?? context.l10n!.podcast),
                search: vm.search,
                clear: vm.clearText,
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
      body: vm.state == UiState.loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              controller: vm.controller,
              child: (vm.podcast == null)
                  ? Center(
                      child: Text(context.l10n!.error, style: textStyleBody))
                  : Column(
                      children: [
                        _image(vm.podcast!),
                        Html(
                          data: vm.podcast!.description ?? '',
                          style: {
                            '*': Style(
                              margin: Margins.only(top: 8, right: 8, left: 8),
                              fontFamily: themeFontFamily.fontFamily,
                              maxLines:
                                  expanded && shortDescription(vm) ? null : 2,
                            ),
                          },
                        ),
                        if (shortDescription(vm))
                          (expanded)
                              ? TextButton(
                                  onPressed: () =>
                                      setState(() => expanded = false),
                                  style: underlineButtonStyle,
                                  child: Text(context.l10n!.hide),
                                )
                              : TextButton(
                                  onPressed: () =>
                                      setState(() => expanded = true),
                                  style: underlineButtonStyle,
                                  child: Text(context.l10n!.readMore),
                                ),
                        _buttons(vm, dm),
                        _episodes(vm, dm),
                        // if (vm.displayingEpisodes.length < (vm.podcast?.episodes.length ?? 0))
                        //   const CircularProgressIndicator(),
                        const SizedBox(height: BottomPlayer.playerHeight),
                      ],
                    ),
            ),
      bottomSheet: const BottomPlayer(),
    );
  }

  bool shortDescription(PodcastViewmodel vm) =>
      (vm.podcast!.description?.length ?? 0) > 100;

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

  Widget _buttons(PodcastViewmodel vm, DownloadManager dm) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FavButton(vm.podcast!),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _sortMenuButton(vm),
              MoreButton(vm: vm, dm: dm),
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

        return EpisodeItem(
          vm: vm,
          dm: dm,
          episode: ep.$1,
          podcast: widget.podcast,
          showImage: false,
          showDesc: true,
        );
      },
    );
  }

  Widget _image(MPodcast item) {
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

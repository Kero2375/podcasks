import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcasks/manager/download_manager.dart';
import 'package:podcasks/ui/common/divider.dart';
import 'package:podcasks/ui/common/episode_item.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/vms/home_vm.dart';
import 'package:podcasks/ui/vms/listening_vm.dart';
import 'package:podcasks/utils.dart';

class ListeningPage extends ConsumerStatefulWidget {
  const ListeningPage({super.key});

  @override
  ConsumerState<ListeningPage> createState() => _HomeContentPageState();
}

class _HomeContentPageState extends ConsumerState<ListeningPage> {
  void _initEpisodeList(ListeningVm vm, HomeViewmodel homeVm) {
    // homeVm.fetchListening();
    final List<(Episode, Podcast)>? saved = homeVm.saved;
    vm.init(
      saved?.map((e) => (e.$1, e.$2)).toList(),
      maxItems: 30,
    );
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final homeVm = ref.read(homeViewmodel);
      final vm = ref.read(listeningViewmodel);
      _initEpisodeList(vm, homeVm);
    });
  }

  @override
  Widget build(BuildContext context) {
    // ref.watch(playerViewmodel);
    final homeVm = ref.watch(homeViewmodel);
    final vm = ref.watch(listeningViewmodel);
    final dm = ref.watch(downloadManager);

    ref.listen(homeViewmodel, (previous, next) {
      Future.microtask(() => _initEpisodeList(vm, next));
    });

    return RefreshIndicator(
      onRefresh: () async {
        await homeVm.fetchListening();
        vm.clear();
        await vm.init(homeVm.saved);
      },
      child: (vm.displayingEpisodes.isEmpty)
          ? LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) =>
                  SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: _welcomeContent(context, homeVm, constraints),
              ),
            )
          : _episodesList(vm, dm),
    );
  }

  Widget _episodesList(ListeningVm episodesVm, DownloadManager dm) =>
      ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        controller: episodesVm.controller,
        shrinkWrap: false,
        itemCount: episodesVm.displayingEpisodes.length,
        itemBuilder: (context, i) {
          return EpisodeItem(
            vm: episodesVm,
            dm: dm,
            episode: episodesVm.displayingEpisodes[i].$1,
            podcast: episodesVm.displayingEpisodes[i].$2,
            showImage: true,
            showDesc: false,
          );
        },
        separatorBuilder: (BuildContext context, int index) => divider(context),
      );

  Widget _welcomeContent(
      BuildContext context, HomeViewmodel homeVm, BoxConstraints constraints) {
    final iconColor =
        Theme.of(context).colorScheme.onSurface.withAlpha(127);
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: constraints.maxHeight),
      child: Center(
        child: Column(
          children: [
            Text(context.l10n!.notListeningMessage, style: textStyleBody),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('~~', style: textStyleBody.copyWith(color: iconColor)),
                Icon(Icons.music_note, color: iconColor),
                Text('~~', style: textStyleBody.copyWith(color: iconColor)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

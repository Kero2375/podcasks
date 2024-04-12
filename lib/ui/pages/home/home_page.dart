import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:ppp2/ui/common/app_bar.dart';
import 'package:ppp2/ui/common/bottom_player.dart';
import 'package:ppp2/ui/common/divider.dart';
import 'package:ppp2/ui/common/themes.dart';
import 'package:ppp2/ui/pages/episode_page.dart';
import 'package:ppp2/ui/pages/home/podcast_list.dart';
import 'package:ppp2/ui/vms/episodes_home_vm.dart';
import 'package:ppp2/ui/vms/home_vm.dart';
import 'package:ppp2/ui/vms/player_vm.dart';
import 'package:ppp2/ui/vms/vm.dart';
import 'package:ppp2/utils.dart';

class HomePage extends ConsumerStatefulWidget {
  static const route = "/";

  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    final homeVm = ref.read(homeViewmodel);
    final playerVm = ref.read(playerViewmodel);
    _checkSaved(homeVm, playerVm);
    super.initState();
  }

  Future<void> _checkSaved(HomeViewmodel homeVm, PlayerViewmodel playerVm) async {
    final track = await homeVm.getLastSavedTrack();
    final position = await homeVm.getLastSavedPosition();
    if (track != null && position != null) {
      await playerVm.setPlaying(track);
      await playerVm.pause();
      await playerVm.seekPosition(position);
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeVm = ref.watch(homeViewmodel);
    final episodesVm = ref.watch(episodesHomeViewmodel);

    episodesVm.init(
      homeVm.favourites
          .map((e) => e.episodes)
          .flattened
          .sorted((a, b) =>
              b.publicationDate != null ? a.publicationDate?.compareTo(b.publicationDate!) ?? 0 : 0)
          .reversed
          .toList(),
      maxItems: 30,
    );

    return Scaffold(
      appBar: mainAppBar(
        context,
        title: 'Podcasts',
      ),
      body: homeVm.state == UiState.loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: episodesVm.controller,
              physics: const ScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: episodesVm.displayingEpisodes.length,
              itemBuilder: (context, i) => _episode(context, episodesVm.displayingEpisodes[i]),
            ),
      bottomSheet: const BottomPlayer(),
      drawer: Drawer(
        child: ListView(
          children: [
            SizedBox(
              height: 86,
              child: DrawerHeader(
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    Icon(
                      Icons.favorite,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      "Following",
                      style: textStyleSubtitle(context),
                    ),
                  ],
                ),
              ),
            ),
            PodcastList(items: homeVm.favourites),
          ],
        ),
      ),
    );
  }

  Widget _episode(BuildContext context, Episode? ep) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, EpisodePage.route,
            arguments: EpisodeData(ep, null)); // fixme: podcast missing!!!!!!!!!!!!!!!!!!!!!!!11 (maybe wrapper object)
        // fixme: list scroll not working here in home!
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          divider(context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                if (ep?.imageUrl != null)
                  Image.network(
                    ep!.imageUrl!,
                    height: 40,
                  ),
                const SizedBox(width: 8),
                Flexible(
                  flex: 1,
                  child: Text(
                    ep?.title ?? '',
                    style: textStyleHeader,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

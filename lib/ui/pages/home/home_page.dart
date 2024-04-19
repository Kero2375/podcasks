import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:podcasks/data/podcast_episode.dart';
import 'package:podcasks/ui/common/app_bar.dart';
import 'package:podcasks/ui/common/bottom_player.dart';
import 'package:podcasks/ui/common/divider.dart';
import 'package:podcasks/ui/common/listening_tag.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/pages/episode_page.dart';
import 'package:podcasks/ui/pages/home/podcast_list.dart';
import 'package:podcasks/ui/pages/search/search_page.dart';
import 'package:podcasks/ui/vms/episodes_home_vm.dart';
import 'package:podcasks/ui/vms/home_vm.dart';
import 'package:podcasks/ui/vms/player_vm.dart';
import 'package:podcasks/ui/vms/vm.dart';
import 'package:podcasks/utils.dart';

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

  Future<void> _checkSaved(
      HomeViewmodel homeVm, PlayerViewmodel playerVm) async {
    final (track, position) = await homeVm.getLastSaved() ?? (null, null);
    if (track != null && position != null) {
      await playerVm.setupPlayer(track);
      await playerVm.pause();
      await playerVm.seekPosition(position);
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeVm = ref.watch(homeViewmodel);
    final episodesVm = ref.watch(episodesHomeViewmodel);

    homeVm.addListener(() => _initEpisodeList(episodesVm, homeVm));

    if (episodesVm.displayingEpisodes.isEmpty) {
      _initEpisodeList(episodesVm, homeVm);
    }

    return Scaffold(
      appBar: mainAppBar(
        context,
        title: 'Podcasks',
        leading: homeVm.favourites.isNotEmpty
            ? Builder(
                builder: (context) {
                  return IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: SvgPicture.asset(
                      'assets/icon/favorites_list.svg',
                      width: 32,
                      // ignore: deprecated_member_use
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  );
                },
              )
            : const SizedBox.shrink(),
      ),
      body: homeVm.state == UiState.loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await episodesVm.update();
                await homeVm.update();
                await homeVm.fetchFavourites();
                await homeVm.fetchAllSaved();
              },
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: episodesVm.controller,
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: episodesVm.displayingEpisodes.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 64),
                              child: Column(
                                children: [
                                  Text('welcome!', style: textStyleBody),
                                  Text('you are not listening anything yet',
                                      style: textStyleBody),
                                  const SizedBox(height: 8),
                                  Text('¯\\_(ツ)_/¯', style: textStyleBody),
                                  const SizedBox(height: 8),
                                  FilledButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        SearchPage.route,
                                      );
                                    },
                                    style: buttonStyle,
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.search),
                                        SizedBox(width: 8),
                                        Text('explore podcasts'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              ListView.builder(
                                physics: const ScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: episodesVm.displayingEpisodes.length,
                                itemBuilder: (context, i) => _episode(
                                    context,
                                    episodesVm.displayingEpisodes[i],
                                    episodesVm),
                              ),
                              const SizedBox(height: BottomPlayer.playerHeight),
                            ],
                          ),
                  ),
                ),
              ),
            ),
      bottomSheet: const BottomPlayer(),
      drawer: homeVm.favourites.isNotEmpty
          ? Drawer(
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
            )
          : null,
    );
  }

  void _initEpisodeList(
      EpisodesHomeViewmodel episodesVm, HomeViewmodel homeVm) {
    episodesVm.init(
      homeVm.saved +
          homeVm.favourites
              .map((p) => p.episodes
                  .map((e) => PodcastEpisode.fromEpisode(e, podcast: p)))
              .flattened
              .sorted((a, b) => b.publicationDate != null
                  ? a.publicationDate?.compareTo(b.publicationDate!) ?? 0
                  : 0)
              .reversed
              .toList(),
      maxItems: 30,
    );
  }

  Widget _episode(BuildContext context, PodcastEpisode? ep,
      EpisodesHomeViewmodel episodesVm) {
    final image = ep?.podcast?.image;
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, EpisodePage.route, arguments: ep);
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
                Container(
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
                          image,
                          height: 40,
                          width: 40,
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListeningTag(
                        ep: ep,
                        isStarted: episodesVm.isStarted,
                        padding: const EdgeInsets.only(bottom: 4),
                      ),
                      Text(
                        ep?.publicationDate?.toDate() ?? '',
                        style: textStyleSmallGray(context),
                      ),
                      Text(
                        ep?.title ?? '',
                        style: textStyleHeader,
                        overflow: TextOverflow.fade,
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
}

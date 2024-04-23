import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:podcasks/data/podcast_episode.dart';
import 'package:podcasks/ui/common/app_bar.dart';
import 'package:podcasks/ui/common/bottom_player.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/pages/favourites/faourites_drawer.dart';
import 'package:podcasks/ui/pages/home/episode_item.dart';
import 'package:podcasks/ui/pages/home/favourites_row.dart';
import 'package:podcasks/ui/pages/search/search_page.dart';
import 'package:podcasks/ui/vms/episodes_home_vm.dart';
import 'package:podcasks/ui/vms/home_vm.dart';
import 'package:podcasks/ui/vms/list_vm.dart';
import 'package:podcasks/ui/vms/player_vm.dart';
import 'package:podcasks/ui/vms/vm.dart';

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
    final episodesVm = ref.read(episodesHomeViewmodel);
    _checkSaved(homeVm, playerVm, episodesVm);
    super.initState();
  }

  Future<void> _checkSaved(HomeViewmodel homeVm, PlayerViewmodel playerVm,
      EpisodesHomeViewmodel episodesVm) async {
    final (track, position) = await homeVm.getLastSaved() ?? (null, null);
    final (state, _) = episodesVm.getEpisodeState(track);
    if (track != null && position != null && state != EpisodeState.finished) {
      await playerVm.setupPlayer(track);
      await playerVm.pause();
      await playerVm.seekPosition(
          track.duration ?? const Duration(hours: 1) - position); //fixme
    }
  }

  void _initEpisodeList(
      EpisodesHomeViewmodel episodesVm, HomeViewmodel homeVm) {
    final PodcastEpisode? saved = homeVm.saved;
    final favourites = homeVm.favourites;
    final list = <PodcastEpisode>[];

    if (saved != null &&
        favourites.firstWhereOrNull((p) => p.url == saved.podcast?.url) ==
            null) {
      list.add(saved);
    }

    list.addAll(favourites
        .map((p) =>
            p.episodes.map((e) => PodcastEpisode.fromEpisode(e, podcast: p)))
        .flattened
        .sorted((a, b) => b.publicationDate != null
            ? a.publicationDate?.compareTo(b.publicationDate!) ?? 0
            : 0)
        .reversed);

    episodesVm.init(list, maxItems: 30);
  }

  @override
  Widget build(BuildContext context) {
    final homeVm = ref.watch(homeViewmodel);
    final episodesVm = ref.watch(episodesHomeViewmodel);

    homeVm.addListener(() {
      _initEpisodeList(episodesVm, homeVm);
    });

    if (episodesVm.displayingEpisodes.isEmpty) {
      episodesVm.filterEpisodes([]);
      _initEpisodeList(episodesVm, homeVm);
    }

    return Scaffold(
      appBar: mainAppBar(
        context,
        title: 'Podcasks',
        leading: homeVm.favourites.isNotEmpty
            ? _favouritesButton()
            : const SizedBox.shrink(),
      ),
      body: homeVm.state == UiState.loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await homeVm.fetchFavourites();
                await homeVm.fetchListening();
                await episodesVm.update();
                await homeVm.update();
                // _initEpisodeList(episodesVm, homeVm);
              },
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: episodesVm.controller,
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _favRow(episodesVm, homeVm),
                        episodesVm.displayingEpisodes.isEmpty
                            ? _welcomeContent(context)
                            : _episodesList(episodesVm),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      bottomSheet: const BottomPlayer(),
      drawer: homeVm.favourites.isNotEmpty ? const FavouritesDrawer() : null,
    );
  }

  Widget _favRow(EpisodesHomeViewmodel episodesVm, HomeViewmodel homeVm) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: FavouritesRow(
          episodesVm: episodesVm,
          homeVm: homeVm,
        ),
      ),
    );
  }

  Builder _favouritesButton() {
    return Builder(
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
    );
  }

  Column _episodesList(EpisodesHomeViewmodel episodesVm) {
    return Column(
      children: [
        ListView.builder(
          physics: const ScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: episodesVm.displayingEpisodes.length,
          itemBuilder: (context, i) => EpisodeItem(
            vm: episodesVm,
            episode: episodesVm.displayingEpisodes[i],
            showImage: true,
            showDesc: false,
          ),
        ),
        const SizedBox(height: BottomPlayer.playerHeight),
      ],
    );
  }

  Center _welcomeContent(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 64),
        child: Column(
          children: [
            Text('welcome!', style: textStyleBody),
            Text('you\'re not listening to anything', style: textStyleBody),
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
    );
  }
}

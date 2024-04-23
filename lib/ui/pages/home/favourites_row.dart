import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:podcasks/ui/pages/home/home_podcast_item.dart';
import 'package:podcasks/ui/pages/podcast/podcast_page.dart';
import 'package:podcasks/ui/vms/episodes_home_vm.dart';
import 'package:podcasks/ui/vms/home_vm.dart';

class FavouritesRow extends StatelessWidget {
  const FavouritesRow({
    super.key,
    required this.episodesVm,
    required this.homeVm,
  });

  final EpisodesHomeViewmodel episodesVm;
  final HomeViewmodel homeVm;

  @override
  Widget build(BuildContext context) {
    final int favLength = homeVm.favourites.length;
    final bool isFull = episodesVm.isOfSize(favLength);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
            HomePodcastItem(
              icon: Icons.headphones,
              selected: episodesVm.isFilterEmpty(),
              onTap: () {
                episodesVm.filterEpisodes([]);
              },
            ),
            HomePodcastItem(
              icon: Icons.home_filled,
              selected: isFull,
              onTap: () {
                episodesVm.filterEpisodes(homeVm.favourites);
              },
            ),
          ] +
          homeVm.favourites
              // .where((e) => !episodesVm.isInFilter(e))
              .mapIndexed((i, p) => HomePodcastItem(
                    image: p.image,
                    selected: !isFull && episodesVm.isInFilter(p),
                    onTap: () {
                      if (!isFull && episodesVm.isInFilter(p)) {
                        Navigator.pushNamed(
                          context,
                          PodcastPage.route,
                          arguments: p,
                        );
                      } else {
                        episodesVm.filterEpisodes([p]);
                      }
                    },
                  ))
              .toList(),
    );
  }
}

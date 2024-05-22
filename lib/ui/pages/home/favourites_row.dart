import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final selectedPod = episodesVm.tempPodcast;

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
              // HomePodcastItem(
              //   icon: Icons.headphones,
              //   selected: episodesVm.tempPodcast == null,
              //   onTap: () {
              //     episodesVm.showListening(homeVm);
              //   },
              // ),
              // HomePodcastItem(
              //   icon: Icons.playlist_play,
              //   selected: episodesVm.tempPodcast == null,
              //   onTap: () {
              //     episodesVm.showListening(homeVm);
              //   },
              // ),
            ] +
            homeVm.favourites
                // .where((e) => !episodesVm.isInFilter(e))
                .mapIndexed((i, p) {
              final isSelected = selectedPod?.url == p.url;
              return HomePodcastItem(
                podcast: p,
                selected: isSelected,
                // onTap: () async {
                //   if (!isSelected) {
                //     await episodesVm.initPodcast(p, maxItems: 30);
                //     episodesVm.update();
                //   } else {
                //     HapticFeedback.lightImpact();
                //     return Navigator.pushNamed(
                //       context,
                //       PodcastPage.route,
                //       arguments: selectedPod,
                //     );
                //   }
                // },
                onTap: () {
                  HapticFeedback.lightImpact();
                  return Navigator.pushNamed(
                    context,
                    PodcastPage.route,
                    arguments: isSelected ? selectedPod : p,
                  );
                },
              );
            }).toList(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_search/src/model/episode.dart';
import 'package:podcast_search/src/model/podcast.dart';
import 'package:ppp2/ui/common/app_bar.dart';
import 'package:ppp2/ui/vms/player_vm.dart';

class PlayingPage extends ConsumerWidget {
  static const route = '/playing_page';

  const PlayingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(playerViewmodel);
    final ep = vm.playingEpisode;
    final podcast = vm.playingPodcast;

    return Scaffold(
      appBar: mainAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _image(ep),
            _title(context, ep, podcast),
            LinearProgressIndicator(value: vm.trackPosition),
            _buttons(vm),
          ],
        ),
      ),
    );
  }

  Widget _buttons(PlayerViewmodel vm) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.replay_10),
            iconSize: 30,
            onPressed: () {},
          ),
          IconButton.filled(
            icon: vm.isPlaying() ? const Icon(Icons.pause) : const Icon(Icons.play_arrow),
            iconSize: 40,
            onPressed: () => vm.isPlaying() ? vm.pause() : vm.play(),
          ),
          IconButton(
            icon: const Icon(Icons.forward_30),
            iconSize: 30,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _title(BuildContext context, Episode? ep, Podcast? podcast) {
    return Column(
      children: [
        Text(
          ep?.title ?? '',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 26),
        ),
        Text(
          podcast?.title ?? '',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.primary),
        ),
      ],
    );
  }

  Container _image(Episode? ep) {
    return Container(
      // margin: const EdgeInsets.all(32),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.antiAlias,
      child: (ep?.imageUrl != null) ? Image.network(ep!.imageUrl!) : null,
    );
  }
}

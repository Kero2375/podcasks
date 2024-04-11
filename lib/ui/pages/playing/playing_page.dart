import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:ppp2/ui/common/app_bar.dart';
import 'package:ppp2/ui/vms/player_vm.dart';
import 'package:ppp2/utils.dart';

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
            _image(vm.image),
            _title(context, ep, podcast),
            LinearProgressIndicator(value: vm.percent),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(vm.position.toTime()),
                Text((vm.position - vm.duration).toTime()),
              ],
            ),
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
            onPressed: () => vm.forward(const Duration(seconds: -10)),
          ),
          IconButton.filled(
            icon: vm.isPlaying() ? const Icon(Icons.pause) : const Icon(Icons.play_arrow),
            iconSize: 40,
            onPressed: () => vm.isPlaying() ? vm.pause() : vm.play(),
          ),
          IconButton(
            icon: const Icon(Icons.forward_30),
            iconSize: 30,
            onPressed: () => vm.forward(const Duration(seconds: 30)),
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

  Container _image(String? image) {
    return Container(
      // margin: const EdgeInsets.all(32),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.antiAlias,
      child: (image != null) ? Image.network(image) : null,
    );
  }
}

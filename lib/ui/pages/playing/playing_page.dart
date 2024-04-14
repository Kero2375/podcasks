import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:ppp2/data/podcast_episode.dart';
import 'package:ppp2/ui/common/app_bar.dart';
import 'package:ppp2/ui/common/themes.dart';
import 'package:ppp2/ui/pages/episode_page.dart';
import 'package:ppp2/ui/pages/podcast_page.dart';
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
      body: SingleChildScrollView(
        controller: vm.scrollController,
        child: Column(
          children: [
            _pageContent(context, vm, ep, podcast),
            description(ep),
          ],
        ),
      ),
    );
  }

  SizedBox _pageContent(BuildContext context, PlayerViewmodel vm,
      PodcastEpisode? ep, Podcast? podcast) {
    return SizedBox(
      height: MediaQuery.of(context).size.height -
          MediaQuery.of(context).viewPadding.top * 2,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _image(vm.image),
            _bottomSection(context, ep, podcast, vm),
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
            style: controlsButtonStyle(true),
          ),
          IconButton.filled(
            icon: vm.isPlaying()
                ? const Icon(Icons.pause)
                : const Icon(Icons.play_arrow),
            iconSize: 40,
            onPressed: () => vm.isPlaying() ? vm.pause() : vm.play(),
            style: controlsButtonStyle(!vm.isPlaying()),
          ),
          IconButton(
            icon: const Icon(Icons.forward_30),
            iconSize: 30,
            onPressed: () => vm.forward(const Duration(seconds: 30)),
            style: controlsButtonStyle(true),
          ),
        ],
      ),
    );
  }

  Widget _bottomSection(BuildContext context, PodcastEpisode? ep,
      Podcast? podcast, PlayerViewmodel vm) {
    return Column(
      children: [
        _title(context, ep, podcast),
        Slider(
          value: vm.percent,
          onChangeStart: (value) => vm.pause(),
          onChanged: (value) => vm.seek(value),
          onChangeEnd: (value) => vm.play(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              vm.position.toTime(),
              style: textStyleSmallGray(context),
            ),
            Text(
              (vm.position - vm.duration).toTime(),
              style: textStyleSmallGray(context),
            ),
          ],
        ),
        _buttons(vm),
        IconButton(
          onPressed: () => vm.scrollDown(),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: Theme.of(context).colorScheme.onBackground.withOpacity(.5),
          ),
        ),
      ],
    );
  }

  Widget _title(BuildContext context, PodcastEpisode? ep, Podcast? podcast) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Navigator.popAndPushNamed(context, EpisodePage.route,
              arguments: ep),
          child: Text(
            ep?.title ?? '',
            maxLines: 3,
            textAlign: TextAlign.center,
            style: textStyleTitle,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => Navigator.popAndPushNamed(context, PodcastPage.route,
              arguments: podcast),
          child: Text(
            podcast?.title ?? '',
            textAlign: TextAlign.center,
            style: textStyleSubtitle(context),
          ),
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

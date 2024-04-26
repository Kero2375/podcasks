import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/data/podcast_episode.dart';
import 'package:podcasks/ui/common/app_bar.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/pages/episode_page.dart';
import 'package:podcasks/ui/pages/podcast/podcast_page.dart';
import 'package:podcasks/ui/vms/player_vm.dart';
import 'package:podcasks/utils.dart';
import 'package:podcast_search/podcast_search.dart';

class PlayingPage extends ConsumerStatefulWidget {
  static const route = '/playing_page';

  const PlayingPage({super.key});

  @override
  ConsumerState<PlayingPage> createState() => _PlayingPageState();
}

class _PlayingPageState extends ConsumerState<PlayingPage> {
  bool wasPlayingBeforeSeek = false;

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(playerViewmodel);
    final ep = vm.playing;
    final podcast = vm.playingPodcast;

    return Scaffold(
      appBar: mainAppBar(context,
          actions: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: PopupMenuButton<double>(
              onSelected: vm.setSpeed,
              icon: Text(
                '⚡️ ${vm.speed}x',
                style: textStyleBody,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              itemBuilder: (context) => [
                _speedMenuItem(0.5),
                _speedMenuItem(0.75),
                _speedMenuItem(1),
                _speedMenuItem(1.25),
                _speedMenuItem(1.5),
                _speedMenuItem(2),
              ],
            ),
          )),
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

  PopupMenuItem<double> _speedMenuItem(double speed) {
    return PopupMenuItem(
        value: speed,
        textStyle: textStyleBody,
        child: Text(
          '⚡️ ${speed}x',
          style: textStyleBody,
        ));
  }

  SizedBox _pageContent(
      BuildContext context, PlayerViewmodel vm, PodcastEpisode? ep, Podcast? podcast) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - MediaQuery.of(context).viewPadding.top * 2,
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
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.replay_10),
            iconSize: 30,
            onPressed: () {
              HapticFeedback.lightImpact();
              vm.forward(const Duration(seconds: -10));
            },
            style: controlsButtonStyle(true),
          ),
          IconButton.filled(
            icon: vm.isPlaying() ? const Icon(Icons.pause) : const Icon(Icons.play_arrow),
            iconSize: 40,
            onPressed: () {
              HapticFeedback.lightImpact();
              vm.isPlaying() ? vm.pause() : vm.play();
            },
            style: controlsButtonStyle(!vm.isPlaying()),
          ),
          IconButton(
            icon: const Icon(Icons.forward_30),
            iconSize: 30,
            onPressed: () {
              HapticFeedback.lightImpact();
              vm.forward(const Duration(seconds: 30));
            },
            style: controlsButtonStyle(true),
          ),
        ],
      ),
    );
  }

  Widget _bottomSection(
      BuildContext context, PodcastEpisode? ep, Podcast? podcast, PlayerViewmodel vm) {
    return Column(
      children: [
        _title(context, ep, podcast),
        Slider(
          value: max(vm.percent, 0),
          onChangeStart: (value) {
            HapticFeedback.lightImpact();
            wasPlayingBeforeSeek = vm.isPlaying();
            if (wasPlayingBeforeSeek) {
              vm.pause();
            }
          },
          onChanged: (value) => vm.seek(value),
          onChangeEnd: (value) {
            if (wasPlayingBeforeSeek) {
              vm.play();
            }
          },
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
          onPressed: () {
            HapticFeedback.lightImpact();
            vm.scrollDown();
          },
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
          onTap: () => Navigator.popAndPushNamed(context, EpisodePage.route, arguments: ep),
          child: Text(
            ep?.title ?? '',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: textStyleTitle,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => Navigator.popAndPushNamed(context, PodcastPage.route, arguments: podcast),
          child: Text(
            podcast?.title ?? '',
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textStyleSubtitle(context),
          ),
        ),
      ],
    );
  }

  Container _image(String? image) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.antiAlias,
      child: (image != null) ? Image.network(image) : null,
    );
  }
}

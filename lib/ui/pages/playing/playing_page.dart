import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:podcasks/data/entities/episode/podcast_episode.dart';
import 'package:podcasks/data/entities/podcast/podcast_entity.dart';
import 'package:podcasks/ui/common/app_bar.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/pages/episode_page.dart';
import 'package:podcasks/ui/pages/playing/playing_menu.dart';
import 'package:podcasks/ui/pages/queue/queue_button.dart';
import 'package:podcasks/ui/pages/podcast/podcast_page.dart';
import 'package:podcasks/ui/vms/player_vm.dart';
import 'package:podcasks/utils.dart';

class PlayingPage extends ConsumerStatefulWidget {
  static const route = '/playing_page';

  const PlayingPage({super.key});

  @override
  ConsumerState<PlayingPage> createState() => _PlayingPageState();
}

class _PlayingPageState extends ConsumerState<PlayingPage>
    with TickerProviderStateMixin {
  bool wasPlayingBeforeSeek = false;
  double? tempSeekPerc;
  Color? dominantColor;
  bool colorReady = false;

  @override
  void initState() {
    super.initState();
    final vm = ref.read(playerViewmodel);
    PaletteGenerator.fromImageProvider(ResizeImage(
            Image.network(vm.image ?? '').image,
            width: 10,
            height: 10))
        .then((value) => {
              setState(() {
                dominantColor = Theme.of(context).brightness == Brightness.light
                    ? value.vibrantColor?.color
                    : value.lightVibrantColor?.color;
                colorReady = true;
              }),
            });
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(playerViewmodel);
    final ep = vm.playing;
    final podcast = vm.playingPodcast;

    return Scaffold(
      appBar: mainAppBar(context, actions: PlayingPopupMenu(ep, podcast)),
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

  PopupMenuButton<double> _speedButton(
      BuildContext context, PlayerViewmodel vm) {
    return PopupMenuButton<double>(
      onSelected: vm.setSpeed,
      icon: Text(
        '⚡ ${vm.speed}x',
        style: textStyleBody.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(204)),
      ),
      shape: popupMenuShape(context),
      itemBuilder: (context) => [
        _speedMenuItem(0.5),
        _speedMenuItem(0.75),
        _speedMenuItem(1),
        _speedMenuItem(1.25),
        _speedMenuItem(1.5),
        _speedMenuItem(2),
      ],
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

  SizedBox _pageContent(BuildContext context, PlayerViewmodel vm, MEpisode? ep,
      MPodcast? podcast) {
    return SizedBox(
      height: MediaQuery.of(context).size.height -
          MediaQuery.of(context).viewPadding.top -
          MediaQuery.of(context).viewPadding.bottom,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _image(vm.image)),
            _bottomSection(context, ep, podcast, vm),
            SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
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
          (vm.isReady && colorReady)
              ? _playButton(vm)
              : SizedBox(
                  width: 55,
                  height: 55,
                  child: CircularProgressIndicator(
                    strokeCap: StrokeCap.round,
                    padding: const EdgeInsets.all(8),
                    strokeWidth: 8,
                    color: Theme.of(context).colorScheme.onSurface.withAlpha(127),
                  ),
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

  Widget _playButton(PlayerViewmodel vm) {
    void onPressed() {
      HapticFeedback.lightImpact();
      vm.isPlaying() ? vm.pause() : vm.play();
    }

    return SizedBox(
      height: 55,
      width: 55,
      child: vm.isPlaying()
          ? IconButton.filledTonal(
              icon: const Icon(Icons.pause),
              color: dominantColor,
              iconSize: 40,
              onPressed: onPressed,
              style: controlsButtonStyle(!vm.isPlaying()).copyWith(
                // backgroundColor: WidgetStatePropertyAll(bgColor),
              ),
            )
          : IconButton.filled(
              icon: const Icon(Icons.play_arrow),
              iconSize: 40,
              onPressed: onPressed,
              style: controlsButtonStyle(!vm.isPlaying()).copyWith(
                backgroundColor: WidgetStatePropertyAll(dominantColor),
              ),
            ),
    );
  }

  Widget _bottomSection(BuildContext context, MEpisode? ep, MPodcast? podcast,
      PlayerViewmodel vm) {
    return Column(
      children: [
        _title(context, ep, podcast),
        _slider(vm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              tempSeekPerc != null
                  ? (vm.duration * tempSeekPerc!).toTime()
                  : vm.position.toTime(),
              style: textStyleSmallGray(context),
            ),
            Text(
              tempSeekPerc != null
                  ? ((vm.duration * tempSeekPerc!) - vm.duration).toTime()
                  : (vm.position - vm.duration).toTime(),
              style: textStyleSmallGray(context),
            ),
          ],
        ),
        _buttons(vm),
        Stack(
          alignment: Alignment.center,
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: _speedButton(context, vm)),
            _showDescriptionButton(vm, context),
            Align(
              alignment: Alignment.centerRight,
              child: Builder(
                builder: (context) => QueueButton(vm: vm),
              ),
            )
          ],
        ),
      ],
    );
  }

  Slider _slider(PlayerViewmodel vm) {
    return Slider(
        activeColor: dominantColor,
        value: tempSeekPerc ?? max(vm.percent, 0),
        onChangeStart: (value) {
          // tempSeekPerc = value;
          HapticFeedback.lightImpact();
          wasPlayingBeforeSeek = vm.isPlaying();
          if (wasPlayingBeforeSeek) {
            vm.pause();
          }
        },
        onChanged: (value) {
          setState(() {
            tempSeekPerc = value;
          });
        },
        onChangeEnd: (value) async {
          vm.seek(value).then(
                (value) => setState(() {
                  tempSeekPerc = null;
                }),
              );
          if (wasPlayingBeforeSeek) {
            vm.play();
          }
        },
      );
  }

  IconButton _showDescriptionButton(PlayerViewmodel vm, BuildContext context) {
    return IconButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        vm.scrollDown();
      },
      icon: Icon(
        Icons.keyboard_arrow_down,
        color: Theme.of(context).colorScheme.onSurface.withAlpha(127),
      ),
    );
  }

  Widget _title(BuildContext context, MEpisode? ep, MPodcast? podcast) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Navigator.popAndPushNamed(context, EpisodePage.route,
              arguments: (ep, podcast)),
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
          onTap: () => Navigator.popAndPushNamed(context, PodcastPage.route,
              arguments: podcast),
          child: Text(
            podcast?.title ?? '',
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textStyleSubtitle(context).copyWith(
              color: dominantColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _image(String? image) {
    final imageSize = MediaQuery.of(context).size.width * 0.8;
    return Column(
      children: [
        SizedBox(
        width: imageSize, height: imageSize,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(8)
            ),
            elevation: 32,
            shadowColor: dominantColor?.withAlpha(64),
            margin: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
            child: Container(
              child: (image != null) ? Image.network(image, width: imageSize, height: imageSize, fit: BoxFit.cover,) : null,
            ),
          ),
        ),
      ],
    );
  }
}

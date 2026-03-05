import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:podcast_search/podcast_search.dart';
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
  double speedValue = 1;

  @override
  void initState() {
    super.initState();
    final vm = ref.read(playerViewmodel);
    if (vm.image != null) {
      PaletteGenerator.fromImageProvider(
        CachedNetworkImageProvider(vm.image!, maxWidth: 10, maxHeight: 10),
      ).then((value) => {
            setState(() {
              dominantColor = Theme.of(context).brightness == Brightness.light
                  ? value.vibrantColor?.color
                  : value.lightVibrantColor?.color;
              colorReady = true;
            }),
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(playerViewmodel);
    final ep = vm.playing;
    final podcast = vm.playingPodcast;

    return Scaffold(
      appBar: mainAppBar(context, actions: PlayingPopupMenu(ep, podcast)),
      body: _pageContent(context, vm, ep, podcast),
    );
  }

  Widget _speedButton(BuildContext context, PlayerViewmodel vm) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
            context: context,
            showDragHandle: true,
            useSafeArea: true,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (context, stateSetter) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        "${speedValue}x",
                        style: textStyleBody,
                      ),
                      Slider(
                        min: .5,
                        max: 1.5,
                        value: speedValue,
                        onChanged: (value) {
                          stateSetter(() {
                            speedValue = double.parse(value.toStringAsFixed(2));
                          });
                        },
                        onChangeEnd: (value) {
                          vm.setSpeed(speedValue);
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // TODO: fix not updating slider when pressing buttons
                          _speedMenuItem(0.5, vm),
                          _speedMenuItem(0.75, vm),
                          _speedMenuItem(1, vm),
                          _speedMenuItem(1.25, vm),
                          _speedMenuItem(1.5, vm),
                          // _speedMenuItem(2),
                        ],
                      )
                    ],
                  ),
                ),
              );
            });
      },
      icon: Text(
        '⚡ ${vm.speed}x',
        style: textStyleBody.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(150)),
      ),
    );

    // return PopupMenuButton<double>(
    //   onSelected: vm.setSpeed,
    //   icon: Text(
    //     '⚡ ${vm.speed}x',
    //     style: textStyleBody.copyWith(
    //         color: Theme.of(context).colorScheme.onSurface.withAlpha(150)),
    //   ),
    //   shape: popupMenuShape(context),
    //   itemBuilder: (context) => [
    //     _speedMenuItem(0.5),
    //     _speedMenuItem(0.75),
    //     _speedMenuItem(1),
    //     _speedMenuItem(1.25),
    //     _speedMenuItem(1.5),
    //     _speedMenuItem(2),
    //   ],
    // );
  }

  Widget _speedMenuItem(double speed, PlayerViewmodel vm) {
    return IconButton.filledTonal(
      style: IconButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(12),
        ),
      ),
      onPressed: () {
        setState(() {
          speedValue = speed;
          vm.setSpeed(speed);
        });
      },
      icon: Text(
        speed.toString(),
        style: textStyleBody,
      ),
      // textStyle: textStyleBody,
      // child: Text(
      //   '⚡️ ${speed}x',
      //   style: textStyleBody,
      // )
    );
  }

  Widget _pageContent(
      BuildContext context, PlayerViewmodel vm, Episode? ep, Podcast? podcast) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: _image(vm.image)),
          _bottomSection(context, ep, podcast, vm),
        ],
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
                    color:
                        Theme.of(context).colorScheme.onSurface.withAlpha(127),
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

  Widget _bottomSection(
      BuildContext context, Episode? ep, Podcast? podcast, PlayerViewmodel vm) {
    return Column(
      children: [
        const SizedBox(height: 8),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: _speedButton(context, vm)),
            _showDescriptionButton(vm, context, ep),
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
      secondaryActiveColor: dominantColor?.withAlpha(50),
      secondaryTrackValue: vm.bufferedPercent,
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

  IconButton _showDescriptionButton(
      PlayerViewmodel vm, BuildContext context, Episode? ep) {
    return IconButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        showModalBottomSheet(
          showDragHandle: true,
          context: context,
          builder: (context) => BottomSheet(
            onClosing: () {},
            builder: (BuildContext context) => SingleChildScrollView(
                child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: description(ep),
                ),
              ],
            )),
          ),
        );
      },
      icon: Icon(
        Icons.receipt_long_outlined,
        color: Theme.of(context).colorScheme.onSurface.withAlpha(127),
      ),
    );
  }

  Widget _title(BuildContext context, Episode? ep, Podcast? podcast) {
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
    if (image == null) return const SizedBox.shrink();
    final imageSize = MediaQuery.of(context).size.width;
    return FittedBox(
      fit: BoxFit.contain,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          boxShadow: dominantColor != null
              ? [BoxShadow(color: dominantColor!.withAlpha(64), blurRadius: 30)]
              : [],
        ),
        clipBehavior: Clip.antiAlias,
        child: CachedNetworkImage(
            imageUrl: image, fit: BoxFit.fill, width: imageSize),
      ),
    );
  }
}

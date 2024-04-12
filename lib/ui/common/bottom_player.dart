import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ppp2/ui/common/themes.dart';
import 'package:ppp2/ui/pages/playing/playing_page.dart';
import 'package:ppp2/ui/vms/player_vm.dart';

class BottomPlayer extends ConsumerWidget {
  static const double playerHeight = 64;

  const BottomPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(playerViewmodel);
    return vm.playing == null
        ? const SizedBox.shrink()
        : BottomSheet(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            enableDrag: false,
            onClosing: () {},
            builder: (context) {
              final playing = vm.isPlaying();
              return SizedBox(
                height: playerHeight,
                child: Column(
                  children: [
                    LinearProgressIndicator(value: vm.percent),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                  context, PlayingPage.route),
                              onVerticalDragEnd: (details) {
                                if (details.primaryVelocity! < 0) {
                                  Navigator.pushNamed(
                                      context, PlayingPage.route);
                                }
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: Row(
                                  children: [
                                    if (vm.image != null)
                                      Container(
                                        margin: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        child: Image.network(vm.image!),
                                      ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Html(
                                        data: vm.playingEpisode?.title ?? '',
                                        style: {
                                          '*': Style(
                                            margin: Margins.zero,
                                            fontFamily:
                                                themeFontFamily.fontFamily,
                                            textOverflow: TextOverflow.ellipsis,
                                          ),
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: IconButton(
                              onPressed: () {
                                if (playing) {
                                  vm.pause();
                                } else {
                                  vm.play();
                                }
                              },
                              icon: playing
                                  ? const Icon(Icons.pause)
                                  : const Icon(Icons.play_arrow),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }
}

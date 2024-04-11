import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ppp2/ui/pages/playing/playing_page.dart';
import 'package:ppp2/ui/vms/player_vm.dart';

class BottomPlayer extends ConsumerWidget {
  static const double playerHeight = 64;

  const BottomPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(playerViewmodel);
    return BottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
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
                        onTap: () {
                          Navigator.pushNamed(context, PlayingPage.route);
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Row(
                            children: [
                              if (vm.playingEpisode?.imageUrl != null)
                                Container(
                                  margin: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Image.network(vm.playingEpisode!.imageUrl!),
                                ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(vm.playingEpisode?.title ?? '', maxLines: 1,),
                                // child: TextScroll(
                                //   vm.playingEpisode?.title ?? '',
                                //   mode: TextScrollMode.endless,
                                //   velocity: const Velocity(pixelsPerSecond: Offset(30, 0)),
                                //   pauseBetween: const Duration(seconds: 1),
                                // ),
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
                        icon: playing ? const Icon(Icons.pause) : const Icon(Icons.play_arrow),
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

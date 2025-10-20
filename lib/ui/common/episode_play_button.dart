import 'package:flutter/material.dart';
import 'package:podcasks/data/entities/episode/podcast_episode.dart';
import 'package:podcasks/data/entities/podcast/podcast_entity.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/vms/player_vm.dart';
import 'package:podcasks/ui/vms/vm.dart';

class EpisodePlayButton extends StatelessWidget {
  const EpisodePlayButton({
    super.key,
    required this.episode,
    required this.podcast,
    required this.vm,
  });

  final MEpisode? episode;
  final MPodcast? podcast;
  final PlayerViewmodel vm;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton.filled(
        onPressed: () async {
          vm.isPlaying(url: episode?.contentUrl)
              ? vm.pause()
              : vm.play(
                  track: episode,
                  pod: podcast,
                  seekPos: true,
                );
        },
        icon: vm.state == UiState.loading &&
                vm.playing?.contentUrl == episode?.contentUrl
            ? SizedBox(
                height: 15,
                width: 15,
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              )
            : vm.isPlaying(url: episode?.contentUrl)
                ? const Icon(Icons.pause)
                : const Icon(Icons.play_arrow),
        // label: vm.isPlaying(url: episode?.contentUrl) ? const Text('PAUSE') : const Text('PLAY'),
        style: controlsButtonStyle(!vm.isPlaying(url: episode?.contentUrl)),
      ),
    );
  }
}

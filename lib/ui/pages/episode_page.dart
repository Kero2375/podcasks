import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:ppp2/data/track.dart';
import 'package:ppp2/ui/common/app_bar.dart';
import 'package:ppp2/ui/common/themes.dart';
import 'package:ppp2/ui/player/bottom_player.dart';
import 'package:ppp2/ui/vms/player_vm.dart';
import 'package:ppp2/ui/vms/vm.dart';
import 'package:ppp2/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class EpisodeData {
  final Episode? episode;
  final Podcast? podcast;

  EpisodeData(this.episode, this.podcast);
}

class EpisodePage extends ConsumerWidget {
  static const route = '/podcast_page/episode_page';

  final EpisodeData? episodeData;

  Podcast? get podcast => episodeData?.podcast;

  Episode? get episode => episodeData?.episode;

  const EpisodePage(this.episodeData, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(playerViewmodel);
    return Scaffold(
      appBar: mainAppBar(context, title: podcast?.title),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _title(),
            Center(
              child: FilledButton.icon(
                onPressed: () async {
                  vm.isPlaying(url: episode?.contentUrl)
                      ? vm.pause()
                      : vm.play(
                          track: Track(
                              url: episode?.contentUrl, episode: episode, podcast: podcast));
                },
                icon: vm.state == UiState.loading
                    ? const Icon(Icons.more_horiz)
                    : vm.isPlaying(url: episode?.contentUrl)
                        ? const Icon(Icons.pause)
                        : const Icon(Icons.play_arrow),
                label: vm.state == UiState.loading
                    ? const Text('    ')
                    : vm.isPlaying(url: episode?.contentUrl)
                        ? const Text('Pause')
                        : const Text('Play'),
                style: buttonStyle,
              ),
            ),
            _description(),
            const SizedBox(height: BottomPlayer.playerHeight),
          ],
        ),
      ),
      bottomSheet: const BottomPlayer(),
    );
  }

  Html _description() {
    return Html(
      data: episode?.description ?? '',
      onLinkTap: (url, attributes, element) {
        launchUrl(Uri.parse(url!));
      },
      style: {'*': Style(margin: Margins.all(8))},
    );
  }

  Widget _title() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            episode?.title ?? '',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Text(episode?.publicationDate?.toDate() ?? ''),
          // Text(_parseDuration(episode?.duration)),
        ],
      ),
    );
  }

}

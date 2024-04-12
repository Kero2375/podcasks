import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:ppp2/data/track.dart';
import 'package:ppp2/ui/common/app_bar.dart';
import 'package:ppp2/ui/common/bottom_player.dart';
import 'package:ppp2/ui/common/themes.dart';
import 'package:ppp2/ui/vms/player_vm.dart';
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
            _title(context, vm),
            _description(),
            const SizedBox(height: BottomPlayer.playerHeight),
          ],
        ),
      ),
      bottomSheet: const BottomPlayer(),
    );
  }

  Widget _playButton(PlayerViewmodel vm) {
    return Center(
      child: IconButton.filled(
        onPressed: () async {
          vm.isPlaying(url: episode?.contentUrl)
              ? vm.pause()
              : vm.play(track: Track(url: episode?.contentUrl, episode: episode, podcast: podcast));
        },
        icon: vm.isPlaying(url: episode?.contentUrl)
            ? const Icon(Icons.pause)
            : const Icon(Icons.play_arrow),
        // label: vm.isPlaying(url: episode?.contentUrl) ? const Text('PAUSE') : const Text('PLAY'),
        style: controlsButtonStyle(!vm.isPlaying()),
      ),
    );
  }

  Html _description() {
    return Html(
      data: episode?.description ?? '',
      onLinkTap: (url, attributes, element) {
        launchUrl(Uri.parse(url!));
      },
      style: {
        '*': Style(
          margin: Margins.all(8),
          fontFamily: themeFontFamily.fontFamily,
        )
      },
    );
  }

  Widget _title(BuildContext context, PlayerViewmodel vm) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _playButton(vm),
              const SizedBox(width: 8),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    episode?.title ?? '',
                    style: textStyleTitle,
                  ),
                ),
              ),
            ],
          ),
          _iconInfo(context, Icons.people, episode?.author ?? ''),
          _iconInfo(context, Icons.calendar_today, episode?.publicationDate?.toDate() ?? ''),
          _iconInfo(context, Icons.hourglass_top, episode?.duration?.toTime() ?? ''),
        ],
      ),
    );
  }

  Widget _iconInfo(BuildContext context, IconData icon, String? text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 15,
            color: Theme.of(context).colorScheme.onBackground.withOpacity(.5),
          ),
          const SizedBox(width: 8),
          Text(text ?? '', style: textStyleSmallGray(context)),
        ],
      ),
    );
  }
}

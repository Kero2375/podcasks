import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/manager/download_manager.dart';
import 'package:podcasks/ui/vms/vm.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcasks/data/podcast_episode.dart';
import 'package:podcasks/ui/common/app_bar.dart';
import 'package:podcasks/ui/common/bottom_player.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/vms/player_vm.dart';
import 'package:podcasks/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class EpisodePage extends ConsumerWidget {
  static const route = '/podcast_page/episode_page';

  final PodcastEpisode? episodeData;

  Podcast? get podcast => episodeData?.podcast;

  Episode? get episode => episodeData;

  const EpisodePage(this.episodeData, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(playerViewmodel);
    final dm = ref.watch(downloadManager);

    return Scaffold(
      appBar: mainAppBar(context, title: podcast?.title),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _title(context, vm, dm),
            description(episode),
            const SizedBox(height: BottomPlayer.playerHeight),
          ],
        ),
      ),
      bottomSheet: const BottomPlayer(),
    );
  }

  Widget _playButton(PlayerViewmodel vm, BuildContext context) {
    return Center(
      child: IconButton.filled(
        onPressed: () async {
          vm.isPlaying(url: episode?.contentUrl)
              ? vm.pause()
              : vm.play(
                  track: PodcastEpisode.fromEpisode(episode!, podcast: podcast),
                  seekPos: true,
                );
        },
        icon: vm.state == UiState.loading
            ? SizedBox(
                width: 15,
                height: 15,
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

  Widget _title(BuildContext context, PlayerViewmodel vm, DownloadManager dm) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _playButton(vm, context),
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
          const SizedBox(height: 8),
          Wrap(
            direction: Axis.horizontal,
            children: [
              OutlinedButton.icon(
                onPressed: () => dm.download(episode, context),
                icon: const Icon(Icons.download),
                style: buttonStyle,
                label: Text(
                  context.l10n!.download,
                  style: textStyleBody,
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () {
                  vm.share(episode);
                },
                icon: const Icon(Icons.share),
                style: buttonStyle,
                label: Text(
                  context.l10n!.share,
                  style: textStyleBody,
                ),
              ),
            ],
          ),
          if (episode?.author != null)
            _iconInfo(context, Icons.people, episode!.author!),
          _iconInfo(context, Icons.calendar_today,
              episode?.publicationDate?.toDate() ?? ''),
          (episode?.duration != null)
              ? _iconInfo(context, Icons.hourglass_top,
                  episode?.duration?.toTime() ?? '')
              : const SizedBox.shrink()
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

Widget description(Episode? episode) {
  return SelectionArea(
    child: Html(
      data: episode?.description ?? '',
      onLinkTap: (url, attributes, element) {
        launchUrl(Uri.parse(url!));
      },
      style: {'*': htmlStyle()},
    ),
  );
}

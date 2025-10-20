import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/data/entities/podcast/podcast_entity.dart';
import 'package:podcasks/manager/download_manager.dart';
import 'package:podcasks/ui/common/episode_play_button.dart';
import 'package:podcasks/data/entities/episode/podcast_episode.dart';
import 'package:podcasks/ui/common/app_bar.dart';
import 'package:podcasks/ui/common/bottom_player.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/pages/playing/playing_menu.dart';
import 'package:podcasks/ui/vms/player_vm.dart';
import 'package:podcasks/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class EpisodePage extends ConsumerWidget {
  static const route = '/podcast_page/episode_page';

  MEpisode? get episode => _episodePodcast?.$1;
  // final MEpisode? _episodeData;

  MPodcast? get podcast => _episodePodcast?.$2;
  // final MPodcast? _podcast;

  final (MEpisode, MPodcast)? _episodePodcast;

  const EpisodePage(this._episodePodcast, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(playerViewmodel);
    final dm = ref.watch(downloadManager);

    return Scaffold(
      appBar: mainAppBar(context, title: podcast?.title, actions: PlayingPopupMenu(episode, podcast)),
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

  Widget _title(BuildContext context, PlayerViewmodel vm, DownloadManager dm) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EpisodePlayButton(
                episode: episode,
                podcast: podcast,
                vm: vm,
              ),
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
                  episode?.duration.toTime() ?? '')
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
            color: Theme.of(context).colorScheme.onSurface.withAlpha(127),
          ),
          const SizedBox(width: 8),
          Text(text ?? '', style: textStyleSmallGray(context)),
        ],
      ),
    );
  }
}

Widget description(MEpisode? episode) {
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

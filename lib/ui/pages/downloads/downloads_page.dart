import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/manager/download_manager.dart';
import 'package:podcasks/ui/common/episode_item.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/vms/downloads_vm.dart';
import 'package:podcasks/ui/vms/vm.dart';
import 'package:podcasks/utils.dart';

class DownloadsPage extends ConsumerStatefulWidget {
  const DownloadsPage({super.key});

  @override
  ConsumerState<DownloadsPage> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends ConsumerState<DownloadsPage> {
  @override
  void initState() {
    super.initState();
    ref.read(downloadsViewmodel).initDownloads();
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(downloadsViewmodel);
    final dm = ref.watch(downloadManager);

    if (vm.state == UiState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.downloadsPath == null || vm.downloadsPath!.isEmpty || vm.displayingEpisodes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context.l10n!.noResults,
                style: textStyleBody,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n!.noResultsEmoji,
                style: textStyleBody,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                context.l10n!.selectDownloadsDir,
                textAlign: TextAlign.center,
                style: textStyleBody,
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                style: buttonStyle,
                onPressed: () => vm.pickDirectory(),
                icon: const Icon(Icons.folder_open),
                label: Text(context.l10n!.downloadsDir, style: textStyleBody),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        if (vm.podcasts.isNotEmpty)
          Container(
            height: 120,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: vm.podcasts.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _podcastFilterItem(
                    context,
                    title: context.l10n!.all,
                    isSelected: vm.selectedPodcast == null,
                    onTap: () => vm.selectPodcast(null),
                  );
                }
                final podcast = vm.podcasts[index - 1];
                return _podcastFilterItem(
                  context,
                  title: podcast.title == 'Downloads' ? context.l10n!.downloads : podcast.title ?? '',
                  isSelected: vm.selectedPodcast?.title == podcast.title,
                  onTap: () => vm.selectPodcast(podcast),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: vm.controller,
              itemCount: vm.displayingEpisodes.length,
              itemBuilder: (context, index) {
                final (episode, podcast) = vm.displayingEpisodes[index];
                return EpisodeItem(
                  showImage: false,
                  showDesc: false,
                  episode: episode,
                  podcast: podcast,
                  vm: vm,
                  dm: dm,
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _podcastFilterItem(
    BuildContext context, {
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: isSelected
                    ? Border.all(
                        color: Theme.of(context).colorScheme.primary, width: 2)
                    : Border.all(
                        color: Theme.of(context).colorScheme.onSurface.withAlpha(80), width: 1),
                color: Theme.of(context).colorScheme.surfaceContainer,
              ),
              clipBehavior: Clip.hardEdge,
              child: Center(
                child: Icon(
                  Icons.podcasts,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: textStyleSmall.copyWith(
                fontWeight: isSelected ? FontWeight.bold : null,
                color: isSelected ? Theme.of(context).colorScheme.primary : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

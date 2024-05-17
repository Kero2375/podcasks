import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:podcasks/data/entities/podcast/podcast_entity.dart';
import 'package:podcasks/manager/download_manager.dart';
import 'package:podcasks/ui/common/confirm_dialog.dart';
import 'package:podcasks/ui/common/popup_menu_item.dart';
import 'package:podcasks/ui/vms/podcast_vm.dart';
import 'package:podcasks/utils.dart';

class MoreButton extends StatelessWidget {
  const MoreButton({
    super.key,
    required this.vm,
    required this.dm,
  });

  final PodcastViewmodel vm;
  final DownloadManager dm;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      onSelected: (item) => handleMore(item, vm.podcast, vm, dm, context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      itemBuilder: (context) => [
        popupMenuItem(
          value: 0,
          icon: const Icon(Icons.done_all),
          text: context.l10n!.markAllFinished,
        ),
        popupMenuItem(
          value: 1,
          icon: const Icon(Icons.delete_forever),
          text: context.l10n!.deleteProgress,
        ),
        if (dm.status != DownloadTaskStatus.running.index)
          popupMenuItem(
            value: 2,
            icon: const Icon(Icons.file_download_outlined),
            text: context.l10n!.downloadAll,
          ),
        if (dm.status == DownloadTaskStatus.running.index)
          popupMenuItem(
            value: 3,
            icon: const Icon(Icons.file_download_off_outlined),
            text: context.l10n!.stopDownloads,
          ),
      ],
    );
  }

  void handleMore(
    int action,
    MPodcast? podcast,
    PodcastViewmodel vm,
    DownloadManager dm,
    BuildContext context,
  ) {
    switch (action) {
      case 0:
        showDialog(
          context: context,
          builder: (context) => ConfirmDialog(
            title: context.l10n!.markAllFinished,
            actionText: context.l10n!.confirm,
            actionIcon: const Icon(Icons.check),
            message: context.l10n!.markAllFinishedMessage(podcast?.title ?? ''),
            // emoji: 'ಠ_ಠ',
            onTap: () {
              vm.markAllAsFinished(podcast);
            },
          ),
        );
        break;
      case 1:
        showDialog(
          context: context,
          builder: (context) => ConfirmDialog(
            title: context.l10n!.deleteProgress,
            actionText: context.l10n!.delete,
            actionIcon: const Icon(Icons.warning),
            message: context.l10n!.deleteProgressMessage(podcast?.title ?? ''),
            emoji: context.l10n!.deleteAllEmoji,
            onTap: () {
              vm.deleteAll(podcast);
            },
          ),
        );
        break;
      case 2:
        showDialog(
          context: context,
          builder: (context) => ConfirmDialog(
            title: context.l10n!.downloadAll,
            actionText: context.l10n!.download,
            actionIcon: const Icon(Icons.file_download_outlined),
            message: context.l10n!.downloadMessage(vm.episodes?.length ?? 0),
            // emoji: context.l10n!.deleteAllEmoji,
            onTap: () {
              dm.downloadAll(
                  vm.episodes?.map((e) => e.$1).toList() ?? [], context);
            },
          ),
        );
        break;
      case 3:
        showDialog(
          context: context,
          builder: (context) => ConfirmDialog(
            title: context.l10n!.stopDownloads,
            actionText: context.l10n!.stop,
            actionIcon: const Icon(Icons.file_download_off_outlined),
            message: context.l10n!.stopMessage,
            // emoji: context.l10n!.deleteAllEmoji,
            onTap: () {
              dm.cancelDownloads();
            },
          ),
        );
        break;
    }
  }
}

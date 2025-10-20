import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/pages/queue/queue_menu.dart';
import 'package:podcasks/ui/vms/player_vm.dart';
import 'package:podcasks/ui/vms/podcast_vm.dart';
import 'package:podcasks/utils.dart';

class QueueButton extends ConsumerStatefulWidget {
  final PlayerViewmodel vm;

  const QueueButton({
    super.key,
    required this.vm,
  });

  @override
  ConsumerState<QueueButton> createState() => _QueueButtonState();
}

class _QueueButtonState extends ConsumerState<QueueButton> {
  Offset _tapPos = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
          enableDrag: true,
          showDragHandle: true,
          context: context,
          builder: (context) {
            return Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                final PodcastViewmodel listVm = ref.watch(podcastViewmodel);
                return SizedBox(
                  height: MediaQuery.of(context).size.height - 400,
                  child: FutureBuilder(
                    future: widget.vm.queue,
                    builder: (context, snapshot) => (snapshot.hasData &&
                            snapshot.data!.isNotEmpty)
                        ? Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  context.l10n!.nextInQueue,
                                  style: textStyleSubtitle(context),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: ListView(
                                  children: snapshot.data!
                                          .map((e) => _item(context, e, listVm))
                                          .toList() +
                                      _clearAllButton(listVm),
                                ),
                              ),
                            ],
                          )
                        : Center(
                            child: Text(
                              context.l10n!.emptyQueue,
                              style: textStyleBody,
                            ),
                          ),
                  ),
                );
              },
            );
          },
        );
      },
      icon: Icon(
        Icons.playlist_play,
        color: Theme.of(context).colorScheme.onSurface.withAlpha(204),
      ),
    );
  }

  List<Widget> _clearAllButton(PodcastViewmodel listVm) {
    return [
      Center(
        // padding: const EdgeInsets.all(8),
        child: TextButton.icon(
          label: Text(context.l10n!.clearAll),
          style: buttonStyle,
          icon: const Icon(Icons.clear_all),
          onPressed: () {
            listVm.clearQueue();
          },
        ),
      ),
      const SizedBox(height: 8),
    ];
  }

  Widget _item(BuildContext context, MediaItem e, PodcastViewmodel listVm) {
    return InkWell(
      onTapDown: (details) => setState(() => _tapPos = details.globalPosition),
      onLongPress: () {
        HapticFeedback.lightImpact();
        showQueueMenu(context: context, vm: listVm, track: e, tapPos: _tapPos);
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            if (e.artUri != null) ...[
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(4)),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  e.artUri.toString(),
                  width: 40,
                ),
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                e.title,
                overflow: TextOverflow.ellipsis,
                style: textStyleBody,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

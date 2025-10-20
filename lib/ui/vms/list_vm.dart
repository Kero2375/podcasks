import 'dart:developer' as dev;
import 'dart:math';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:podcasks/data/entities/podcast/podcast_entity.dart';
import 'package:podcasks/data/entities/episode/podcast_episode.dart';
import 'package:podcasks/locator.dart';
import 'package:podcasks/repository/history_repo.dart';
import 'package:podcasks/repository/queue_repo.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/vms/vm.dart';
import 'package:podcasks/utils.dart';

class ListViewmodel extends Vm {
  final HistoryRepo historyRepo = locator.get<HistoryRepo>();
  final QueueRepo _queueRepo = locator.get<QueueRepo>();

  int _maxItems = 10;
  int _page = 0;

  List<(MEpisode, MPodcast)>? get episodes => _episodes;
  List<(MEpisode, MPodcast)>? _episodes;

  List<(MEpisode, MPodcast)> get displayingEpisodes => _displayingEpisodes;
  List<(MEpisode, MPodcast)> _displayingEpisodes = [];

  ScrollController get controller => _controller;
  ScrollController _controller = ScrollController();

  init(List<(MEpisode, MPodcast)>? eps, {int? maxItems}) {
    if (maxItems != null) _maxItems = maxItems;
    _episodes = eps;
    _page = 0;
    if (episodes?.isNotEmpty != null) {
      initEpisodesList();
    }
  }

  void initEpisodesList() {
    if (episodes == null) return;
    _page = 0;
    if (episodes!.length < _maxItems) {
      _displayingEpisodes = episodes!;
    } else {
      _displayingEpisodes = episodes!.sublist(0, _maxItems);
    }
    _controller = ScrollController();
    _controller.addListener(loadMoreData);
  }

  void clear() {
    _displayingEpisodes = [];
  }

  @override
  void dispose() {
    _controller.removeListener(loadMoreData);
    super.dispose();
  }

  void loadMoreData() {
    try {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        if (episodes != null) {
          _page += 1;
          _displayingEpisodes.addAll(episodes!.sublist(
            /*start*/
            _page * _maxItems,
            min(episodes!.length, (_page + 1) * _maxItems),
          ));
          notifyListeners();
        }
      }
    } catch (e) {
      dev.log(e.toString());
    }
  }

  (EpisodeState, Duration?) getEpisodeState(MEpisode? ep) {
    if (ep == null) return (EpisodeState.none, null);
    final (remaining, finished) = historyRepo.getPosition(ep) ?? (null, null);
    return finished == true
        ? (EpisodeState.finished, null)
        : (remaining != null && remaining.inSeconds != 0)
            ? (EpisodeState.started, remaining)
            : (EpisodeState.none, null);
  }

  Future<void> markAsFinished(MEpisode? ep, MPodcast? pd) async {
    if (ep != null && pd != null) {
      await historyRepo.setPosition(ep, pd, Duration.zero, true);
      initEpisodesList();
      update();
    }
  }

  Future<void> cancelProgress(MEpisode? ep) async {
    if (ep != null) {
      await historyRepo.removeEpisode(ep);
      initEpisodesList();
      update();
    }
  }

  Future<void> addToQueue(
      MEpisode? ep, MPodcast? pd, BuildContext? context) async {
    bool res = false;
    if (ep != null && pd != null) {
      await _queueRepo.addItem(ep, pd);
      // await audioHandler?.addQueueItem(
      //   MediaItem(
      //     id: ep.contentUrl ?? '',
      //     title: ep.title,
      //     artist: pd.title,
      //     artUri: Uri.parse(ep.imageUrl ?? pd.image ?? ''),
      //     duration: ep.duration,
      //   ),
      // );
      res = true;
    }

    if (context?.mounted == true) {
      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: Row(
            children: [
              Icon(
                res ? Icons.check : Icons.warning,
                color: Theme.of(context).colorScheme.surface,
              ),
              const SizedBox(width: 8),
              Text(
                res ? context.l10n!.addedToQueue : context.l10n!.error,
                style: textStyleBody,
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<void> removeFromQueue(MediaItem track) async {
    await _queueRepo.removeItem(track);
    // await audioHandler?.removeQueueItemAt(index);
    notifyListeners();
  }

  void clearQueue() async {
    await _queueRepo.clearAll();
    // var length = await audioHandler?.queue.length ?? 0;
    // for (int i = 0; i < length; i++) {
    //   await audioHandler?.removeQueueItemAt(i);
    // }
    notifyListeners();
  }
}

enum EpisodeState {
  none,
  started,
  finished,
}

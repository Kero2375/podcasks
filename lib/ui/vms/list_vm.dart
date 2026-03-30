import 'dart:developer' as dev;
import 'dart:math';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcasks/locator.dart';
import 'package:podcasks/repository/history_repo.dart';
import 'package:podcasks/repository/queue_repo.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/vms/home_vm.dart';
import 'package:podcasks/ui/vms/vm.dart';
import 'package:podcasks/utils.dart';

class ListViewmodel extends Vm {
  final HistoryRepo historyRepo = locator.get<HistoryRepo>();
  final QueueRepo _queueRepo = locator.get<QueueRepo>();

  int _maxItems = 10;
  int _page = 0;

  List<(Episode, Podcast)>? get episodes => _episodes;
  List<(Episode, Podcast)>? _episodes;

  List<(Episode, Podcast)> get displayingEpisodes => _displayingEpisodes;
  List<(Episode, Podcast)> _displayingEpisodes = [];

  ScrollController get controller => _controller;
  ScrollController _controller = ScrollController();
  bool _loadingMore = false;

  init(List<(Episode, Podcast)>? eps, {int? maxItems}) {
    if (maxItems != null) _maxItems = maxItems;
    _episodes = eps;
    _page = 0;
    _displayingEpisodes = []; // Clear current list
    if (episodes != null && episodes!.isNotEmpty) {
      initEpisodesList();
    }
  }

  void initEpisodesList() {
    if (episodes == null) return;
    _page = 0;
    if (episodes!.length < _maxItems) {
      _displayingEpisodes = List.from(episodes!);
    } else {
      _displayingEpisodes = List.from(episodes!.sublist(0, _maxItems));
    }
    
    _controller.removeListener(loadMoreData);
    _controller.dispose();
    _controller = ScrollController();
    _controller.addListener(loadMoreData);
  }

  void clear() {
    _displayingEpisodes = [];
  }

  void refreshHomeList(HomeViewmodel homeVm) {}

  @override
  void dispose() {
    _controller.removeListener(loadMoreData);
    _controller.dispose();
    super.dispose();
  }

  void loadMoreData() {
    try {
      if (_controller.position.pixels >= _controller.position.maxScrollExtent - 200) {
        if (episodes != null && !_loadingMore) {
          final int start = (_page + 1) * _maxItems;
          if (start < episodes!.length) {
            _loadingMore = true;
            _page += 1;
            final int end = min(episodes!.length, (_page + 1) * _maxItems);
            _displayingEpisodes.addAll(episodes!.sublist(start, end));
            _loadingMore = false;
            notifyListeners();
          }
        }
      }
    } catch (e) {
      _loadingMore = false;
      dev.log(e.toString());
    }
  }

  (EpisodeState, Duration?) getEpisodeState(Episode? ep) {
    if (ep == null) return (EpisodeState.none, null);
    final (remaining, _, finished) =
        historyRepo.getPosition(ep) ?? (null, null, false);
    return finished == true
        ? (EpisodeState.finished, null)
        : (remaining != null && remaining.inSeconds != 0)
            ? (EpisodeState.started, remaining)
            : (EpisodeState.none, null);
  }

  Future<void> markAsFinished(Episode? ep, Podcast? pd, {HomeViewmodel? homeVm}) async {
    if (ep != null && pd != null) {
      await historyRepo.setPosition(ep, pd, Duration.zero, ep.duration);
      if (homeVm != null) {
        refreshHomeList(homeVm);
      } else {
        initEpisodesList();
      }
      update();
    }
  }

  Future<void> cancelProgress(Episode? ep, {HomeViewmodel? homeVm}) async {
    if (ep != null) {
      await historyRepo.removeEpisode(ep);
      if (homeVm != null) {
        refreshHomeList(homeVm);
      } else {
        initEpisodesList();
      }
      update();
    }
  }

  Future<void> addToQueue(
      Episode? ep, Podcast? pd, BuildContext? context) async {
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

import 'dart:io';
import 'package:collection/collection.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcasks/locator.dart';
import 'package:podcasks/manager/download_manager.dart';
import 'package:podcasks/repository/prefs_repo.dart';
import 'package:podcasks/ui/vms/list_vm.dart';

final downloadsViewmodel = ChangeNotifierProvider((ref) {
  final vm = DownloadsViewmodel(ref);
  ref.listen(downloadManager, (previous, next) {
    if (next.status == 3) { // DownloadTaskStatus.complete
      vm.loadFiles();
    }
  });
  return vm;
});

class DownloadsViewmodel extends ListViewmodel {
  final _prefsRepo = locator.get<PrefsRepo>();
  Ref<Object?> ref;

  String? _downloadsPath;
  
  List<Podcast> get podcasts => _podcasts;
  final List<Podcast> _podcasts = [];

  Podcast? get selectedPodcast => _selectedPodcast;
  Podcast? _selectedPodcast;

  final Podcast _dummyPodcast = Podcast(
    title: 'Downloads',
    episodes: [],
  );

  String? get downloadsPath => _downloadsPath;
  Podcast get dummyPodcast => _dummyPodcast;

  DownloadsViewmodel(this.ref);

  Future<void> initDownloads() async {
    loading();

    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      if (deviceInfo.version.sdkInt < 33) {
        if (deviceInfo.version.sdkInt >= 30) {
          await Permission.manageExternalStorage.request();
        } else {
          await Permission.storage.request();
        }
      }
    }

    _downloadsPath = await _prefsRepo.getDownloadsPath();
    if (_downloadsPath == null || _downloadsPath!.isEmpty) {
      _downloadsPath = (await getExternalStorageDirectory())?.path;
    }

    if (_downloadsPath != null && _downloadsPath!.isNotEmpty) {
      await loadFiles();
    } else {
      success();
    }
  }

  void selectPodcast(Podcast? podcast) {
    _selectedPodcast = podcast;
    if (podcast == null) {
      final List<(Episode, Podcast)> allEpisodes = [];
      for (var p in _podcasts) {
        allEpisodes.addAll(p.episodes.map((e) => (e, p)));
      }
      super.init(allEpisodes);
    } else {
      super.init(podcast.episodes.map((e) => (e, podcast)).toList());
    }
    notifyListeners();
  }

  Future<void> pickDirectory() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {
      _downloadsPath = selectedDirectory;
      await _prefsRepo.setDownloadsPath(selectedDirectory);
      await loadFiles();
      notifyListeners();
    }
  }

  Future<void> loadFiles() async {
    if (_downloadsPath == null || _downloadsPath!.isEmpty) return;

    final dir = Directory(_downloadsPath!);
    try {
      if (await dir.exists()) {
        _podcasts.clear();
        final List<(Episode, Podcast)> allEpisodePodcastList = [];

        final List<FileSystemEntity> entities = await dir.list().toList();
        
        // 1. Process Root Files (Legacy)
        final rootEpisodes = _processDirectory(dir, _dummyPodcast);
        if (rootEpisodes.isNotEmpty) {
          _dummyPodcast.episodes.clear();
          _dummyPodcast.episodes.addAll(rootEpisodes);
          _podcasts.add(_dummyPodcast);
          allEpisodePodcastList.addAll(rootEpisodes.map((e) => (e, _dummyPodcast)));
        }

        // 2. Process Sub-directories
        for (var entity in entities) {
          if (entity is Directory) {
            final dirName = entity.path.split(Platform.pathSeparator).last;
            if (dirName.startsWith('.')) continue; // Skip hidden dirs

            final podcast = Podcast(
              title: dirName,
              episodes: [],
            );

            final episodes = _processDirectory(entity, podcast);

            if (episodes.isNotEmpty) {
              podcast.episodes.addAll(episodes);
              _podcasts.add(podcast);
              allEpisodePodcastList.addAll(episodes.map((e) => (e, podcast)));
            }
          }
        }
        
        // Sort podcasts by title
        _podcasts.sort((a, b) => (a.title ?? '').compareTo(b.title ?? ''));

        // Sort all episodes by publication date (newest first)
        allEpisodePodcastList.sort((a, b) => (b.$1.publicationDate ?? DateTime.fromMillisecondsSinceEpoch(0)).compareTo(a.$1.publicationDate ?? DateTime.fromMillisecondsSinceEpoch(0)));
        
        if (_selectedPodcast != null) {
          // Try to find the updated version of the selected podcast
          final updatedSelected = _podcasts.firstWhereOrNull((p) => p.title == _selectedPodcast!.title);
          if (updatedSelected != null) {
            _selectedPodcast = updatedSelected;
            super.init(_selectedPodcast!.episodes.map((e) => (e, _selectedPodcast!)).toList());
          } else {
            _selectedPodcast = null;
            super.init(allEpisodePodcastList);
          }
        } else {
          super.init(allEpisodePodcastList);
        }
      } else {
        _downloadsPath = null;
        await _prefsRepo.setDownloadsPath('');
        super.init([]);
      }
    } catch (e) {
      debugPrint('Error loading files: $e');
      super.init([]);
    }
    success();
    notifyListeners();
  }

  List<Episode> _processDirectory(Directory dir, Podcast podcast) {
    final List<FileSystemEntity> entities = dir.listSync();
    final episodes = entities
        .where((entity) => entity is File && entity.path.toLowerCase().endsWith('.mp3'))
        .map((entity) {
          final file = entity as File;
          final fileName = file.path.split(Platform.pathSeparator).last;
          return Episode(
            guid: file.path,
            title: fileName.replaceAll('.mp3', ''),
            contentUrl: file.path,
            publicationDate: file.lastModifiedSync(),
            description: '',
            link: '',
            author: podcast.title ?? 'Local File',
            length: file.lengthSync(),
          );
        })
        .toList();
    
    episodes.sort((a, b) => (b.publicationDate ?? DateTime.fromMillisecondsSinceEpoch(0)).compareTo(a.publicationDate ?? DateTime.fromMillisecondsSinceEpoch(0)));
    return episodes;
  }

  Future<void> deleteEpisode(Episode episode) async {
    final file = File(episode.guid);
    if (await file.exists()) {
      await file.delete();
      await loadFiles();
    }
  }
}

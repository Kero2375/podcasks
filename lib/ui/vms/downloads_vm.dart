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
      if (deviceInfo.version.sdkInt >= 33) {
        await Permission.audio.request();
      } else if (deviceInfo.version.sdkInt >= 30) {
        await Permission.manageExternalStorage.request();
      } else {
        await Permission.storage.request();
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
        final Map<String, List<Episode>> podcastGroups = {};
        final List<(Episode, Podcast)> allEpisodePodcastList = [];

        // Ensure downloadsPath has trailing separator for correct relative path calculation
        final String baseDir = _downloadsPath!.endsWith(Platform.pathSeparator)
            ? _downloadsPath!
            : _downloadsPath! + Platform.pathSeparator;

        // Use a more robust listing that handles errors per-file
        await for (var entity in dir.list(recursive: true, followLinks: false).handleError((e) {
          debugPrint('Error listing file: $e');
        })) {
          if (entity is File && entity.path.toLowerCase().endsWith('.mp3')) {
            final file = entity;
            final relativePath = file.path.replaceFirst(baseDir, '');
            final pathParts = relativePath.split(Platform.pathSeparator).where((s) => s.isNotEmpty).toList();
            
            String groupName;
            if (pathParts.length <= 1) {
              groupName = 'Downloads';
            } else {
              groupName = pathParts.first;
            }

            final fileName = file.path.split(Platform.pathSeparator).last;
            final episode = Episode(
              guid: file.path,
              title: fileName.replaceAll('.mp3', '').replaceAll('.MP3', ''),
              contentUrl: file.path,
              publicationDate: file.lastModifiedSync(),
              description: '',
              link: '',
              author: groupName,
              length: file.lengthSync(),
            );

            if (!podcastGroups.containsKey(groupName)) {
              podcastGroups[groupName] = [];
            }
            podcastGroups[groupName]!.add(episode);
          }
        }

        for (var entry in podcastGroups.entries) {
          final podcast = Podcast(
            title: entry.key,
            episodes: entry.value,
          );
          // Sort episodes within podcast by date
          podcast.episodes.sort((a, b) => (b.publicationDate ?? DateTime.fromMillisecondsSinceEpoch(0)).compareTo(a.publicationDate ?? DateTime.fromMillisecondsSinceEpoch(0)));
          
          if (entry.key == 'Downloads') {
            _dummyPodcast.episodes.clear();
            _dummyPodcast.episodes.addAll(entry.value);
            _podcasts.insert(0, _dummyPodcast);
          } else {
            _podcasts.add(podcast);
          }
          
          allEpisodePodcastList.addAll(entry.value.map((e) => (e, podcast)));
        }
        
        // Sort sub-podcasts by title (excluding Downloads which is first)
        if (_podcasts.length > 1) {
          final subPodcasts = _podcasts.sublist(1);
          subPodcasts.sort((a, b) => (a.title ?? '').compareTo(b.title ?? ''));
          _podcasts.removeRange(1, _podcasts.length);
          _podcasts.addAll(subPodcasts);
        }

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



  Future<void> deleteEpisode(Episode episode) async {
    final file = File(episode.guid);
    if (await file.exists()) {
      await file.delete();
      await loadFiles();
    }
  }
}

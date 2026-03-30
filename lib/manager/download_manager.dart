import 'dart:isolate';
import 'dart:ui';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcasks/locator.dart';
import 'package:podcasks/repository/prefs_repo.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/vms/vm.dart';
import 'package:podcasks/utils.dart';

final downloadManager = ChangeNotifierProvider((ref) => DownloadManager());

class DownloadManager extends Vm {
  final ReceivePort _port = ReceivePort();

  String? id;
  int? status;
  int? progress;

  DownloadManager() {
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      id = data[0];
      status = data[1];
      progress = data[2];
      update();
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  static void downloadCallback(String id, int status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  Future<void> download(Episode? episode, Podcast? podcast, BuildContext context) async {
    final status = await Permission.notification.request();
    bool storageGranted = true;

    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      if (deviceInfo.version.sdkInt < 33) {
        if (deviceInfo.version.sdkInt >= 30) {
          final manageStatus = await Permission.manageExternalStorage.request();
          storageGranted = manageStatus.isGranted;
        } else {
          final storageStatus = await Permission.storage.request();
          storageGranted = storageStatus.isGranted;
        }
      }
    }

    String? dir = await locator.get<PrefsRepo>().getDownloadsPath();
    bool saveInPublicStorage = false;

    if (dir == null || dir.isEmpty) {
      dir = (await getExternalStorageDirectory())?.path;
      saveInPublicStorage = true;
    }

    if (status.isGranted && storageGranted && episode?.contentUrl != null && dir != null) {
      String finalDir = dir;
      if (podcast != null && podcast.title != null) {
        final sanitizedTitle = podcast.title!.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_').trim();
        final podcastDir = Directory('$dir/$sanitizedTitle');
        if (!await podcastDir.exists()) {
          await podcastDir.create(recursive: true);
        }
        finalDir = podcastDir.path;
        saveInPublicStorage = false; // Always false for subfolders
      }

      await FlutterDownloader.enqueue(
        url: episode!.contentUrl!,
        fileName: '${episode.title}.mp3'.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_'),
        headers: {},
        savedDir: finalDir,
        showNotification: true,
        openFileFromNotification: true,
        saveInPublicStorage: saveInPublicStorage,
      );
    } else if (context.mounted) {
      _showSnack(context, context.l10n!.error);
    }
  }

  Future<void> downloadAll(List<Episode> episodes, Podcast? podcast, BuildContext context) async {
    for (Episode ep in episodes) {
      await download(ep, podcast, context);
    }
  }

  Future<void> cancelDownloads() async {
    await FlutterDownloader.cancelAll();
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: textStyleBody),
        action: SnackBarAction(
            label: context.l10n!.settings,
            onPressed: () {
              AppSettings.openAppSettings(type: AppSettingsType.notification);
            }),
      ),
    );
  }
}

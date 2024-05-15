import 'dart:isolate';
import 'dart:ui';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:podcasks/data/entities/episode/podcast_episode.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/vms/vm.dart';
import 'package:podcasks/utils.dart';
import 'package:podcast_search/podcast_search.dart';

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

  Future<void> download(MEpisode? episode, BuildContext context) async {
    final status = await Permission.notification.request();

    final dir = (await getExternalStorageDirectory())?.path;
    if (status.isGranted && episode?.contentUrl != null && dir != null) {
      await FlutterDownloader.enqueue(
        url: episode!.contentUrl!,
        fileName: '${episode.title}.mp3',
        headers: {},
        savedDir: dir,
        showNotification: true,
        openFileFromNotification: true,
        saveInPublicStorage: true,
      );
    } else if (context.mounted) {
      _showSnack(context, context.l10n!.error);
    }
  }

  Future<void> downloadAll(List<MEpisode> episodes, BuildContext context) async {
    for (MEpisode ep in episodes) {
      download(ep, context);
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

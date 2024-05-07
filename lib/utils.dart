import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension ParsableDuration on Duration {
  String toTime() {
    var time = toString().split('.').first.padLeft(8, "0");
    if (time.startsWith('00')) time = time.substring(3);
    if (time.startsWith('-0')) time = "-${time.substring(3)}";
    return time;
  }
}

extension ParsableDateTime on DateTime {
  String toDate() {
    return '${day <= 9 ? '0' : ''}$day/${month <= 9 ? '0' : ''}$month/$year';
  }
}

String parseRemainingTime(Duration time) {
  if (time > const Duration(hours: 1)) {
    return '-${time.inHours}h';
  } else {
    return '-${time.inMinutes}m';
  }
}

extension LocalizationContext on BuildContext {
  AppLocalizations? get l10n => AppLocalizations.of(this);
}

// Future<void> checkNotificationPermission({
//   required Function() then,
//   required BuildContext context,
// }) async {
//   WidgetsFlutterBinding.ensureInitialized();
//   bool granted = await Permission.notification.isGranted;
//   if (!granted) {
//     granted = (await Permission.notification.request()).isGranted;
//     if (!granted && context.mounted) {
//       _showSnack(context, "Notification permission not granted");
//       return;
//     } else if (granted) {
//       then();
//     }
//   } else {
//     then();
//   }
// }
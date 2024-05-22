import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const int maxDropdownLength = 15;

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

extension CountryString on String {
  String capitalize(BuildContext context) {
    final s = split(RegExp(r"(?=[A-Z])"))
        .map((e) => e[0].toUpperCase() + e.substring(1))
        .join(' ');
    if (s == 'None' || s == 'All') {
      return context.l10n!.all;
    }
    // return s;
    if (s.length < maxDropdownLength + 3) {
      return s;
    } else {
      return '${s.substring(0, min(s.length, maxDropdownLength))}...';
    }
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
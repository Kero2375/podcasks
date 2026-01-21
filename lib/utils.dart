import 'dart:math';

import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';

const int maxDropdownLength = 15;

ShapeBorder popupMenuShape(BuildContext context) => RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    side: BorderSide(
      color: Theme.of(context).dividerColor,
      width: 1,
    )
);

extension ParsableDuration on Duration {
  String toTime() {
    var time = toString().split('.').first.padLeft(8, "0");
    if (time.startsWith('00')) time = time.substring(3);
    if (time.startsWith('-0')) time = "-${time.substring(3)}";
    return time;
  }
  String? toEnlapsed() {
    if (this.inMinutes < 2) {
      return null;
    }
    return parseRemainingTime(this);
  }
}

extension ParsableDateTime on DateTime {
  String toDate() {
    return '${day <= 9 ? '0' : ''}$day/${month <= 9 ? '0' : ''}$month/$year';
  }

  String toTimeAgo() {
    final now = DateTime.now();
    if (now.difference(this).inDays < 1) {
      return "today";
    }
    else if (now.difference(this).inDays < 7) {
      return "${now.difference(this).inDays}d ago";
    }
    else if (now.difference(this).inDays < 31) {
      return "${(now.difference(this).inDays/7).round()}w ago";
    } 
    else if (now.difference(this).inDays < 365) {
      return "${(now.difference(this).inDays/31).round()}m ago";
    }
    else {
      return "${(now.difference(this).inDays/365).round()}y ago";
    }
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
    return '${time.inHours}h';
  } else {
    return '${time.inMinutes}m';
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
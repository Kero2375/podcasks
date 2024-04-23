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

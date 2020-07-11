
String videoTime(int duration) {
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }
  String twoDigitHours =
      twoDigits((duration ~/ (1000 * 60 * 60)).remainder(24));
  String twoDigitMinutes = twoDigits((duration ~/ (1000 * 60)).remainder(60));
  String twoDigitSeconds = twoDigits((duration ~/ (1000)).remainder(60));
  return twoDigitHours == '00'
      ? "$twoDigitMinutes:$twoDigitSeconds"
      : "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
}
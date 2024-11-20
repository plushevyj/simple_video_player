extension DurationUtils on Duration {
  String prettyFormat() {
    String hours = inHours.toString().padLeft(0, '2');
    String minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds = inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}

class DaylyWeather {
  final String dayOfWeek;
  final String date;
  final String dayIconPath;
  final String nightIconPath;
  final String maxTempTitle;
  final String minTempTitle;
  final double windDegree;
  final String windSpeedTitle;

  DaylyWeather({
    required this.dayOfWeek,
    required this.date,
    required this.dayIconPath,
    required this.nightIconPath,
    required this.maxTempTitle,
    required this.minTempTitle,
    required this.windDegree,
    required this.windSpeedTitle,
  });
}

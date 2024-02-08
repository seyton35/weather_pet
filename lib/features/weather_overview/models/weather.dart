import 'package:weather_pet/features/weather_overview/models/models.dart';

class Weather {
  final String id;
  final String lcoationTitle;
  final String iconPath;
  final String tempTitle;
  final String minTempTitle;
  final String maxTempTitle;
  final List<HourlyWeather> hourWeatherList;

  Weather({
    required this.id,
    required this.lcoationTitle,
    required this.iconPath,
    required this.tempTitle,
    required this.minTempTitle,
    required this.maxTempTitle,
    required this.hourWeatherList,
  });
}

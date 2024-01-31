import 'package:weather_api/weather_api.dart';

class CurrentWeatherData extends CurrentWeather {
  final String id;
  CurrentWeatherData({
    required this.id,
    required super.location,
    required super.current,
    required super.forecast,
  });
}

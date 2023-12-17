import 'package:weather_pet/domain/api_clients/weather_api_client.dart';
import 'package:weather_pet/domain/entity/weather_response_current.dart';

class WeatherRepository {
  WeatherResponceCurrent? _currentWeather;

  Future<void> getCurrentWeather({required String location}) async {
    _currentWeather =
        await WeatherApiClient().currentWeather(location: location);
  }
}

import 'package:weather_pet/domain/api_clients/api_clients_exception.dart';
import 'package:weather_pet/domain/api_clients/weather_api_client.dart';
import 'package:weather_pet/domain/data_providers/track_location_data_provider.dart';
import 'package:weather_pet/domain/entity/location_response.dart';
import 'package:weather_pet/domain/entity/weather_response_current.dart';
import 'package:weather_pet/domain/entity/weather_response_forecast.dart';

class WeatherRepository {
  final weatherApiClient = WeatherApiClient();
  final trackLocationDataProvider = TrackLocationDataProvider();

  List<TrackingLocation> get locationTrackList =>
      trackLocationDataProvider.locationTrackList;
  var _weather = WeatherResponceCurrent();
  WeatherResponceCurrent get weather => _weather;
  List<LocationResponse> _locationsList = [];
  List<LocationResponse> get locationsList => _locationsList;

  Future<void> init() async {
    trackLocationDataProvider.loadTrackList();
  }

  Future<List<Forecastday>> getTargetLocationDaysList(
      {required String location, required int days}) async {
    _weather = await weatherApiClient.forecastWeather(
      location: location,
      days: days.toString(),
    );
    return _weather.forecast!.forecastday;
  }

  Future<WeatherResponceCurrent> getTargetLocationForecast(
      {required String location, required int days}) async {
    try {
      final forecast = await weatherApiClient.forecastWeather(
        location: location,
        days: days.toString(),
      );
      return forecast;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<LocationResponse>> searchQueryLocations({
    required String query,
  }) async {
    try {
      _locationsList = await weatherApiClient.searchLocation(
        query: query,
      );
      if (_locationsList.isEmpty) {
        throw ApiClientExeption(ApiClientExeptionType.emptyResponse);
      }
      return _locationsList;
    } catch (e) {
      rethrow;
    }
  }

  void startTrackingLocation({required TrackingLocation location}) {
    trackLocationDataProvider.addLocation(location);
  }

  Future<bool> hasStoredLocations() async {
    final trackList = await trackLocationDataProvider.loadTrackList();
    return trackList.isNotEmpty;
  }
}

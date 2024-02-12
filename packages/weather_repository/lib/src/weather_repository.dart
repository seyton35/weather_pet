import 'dart:async';

import 'package:local_storage_tracking_locations_api/local_storage_tracking_locations_api.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:weather_api/weather_api.dart';
import 'package:weather_repository/weather_repository.dart';

class WeatherRepository {
  WeatherRepository({
    required TrackLocationDataProvider trackLocationApi,
    WeatherApiClient? weatherApiClient,
  })  : _trackLocationDataProvider = trackLocationApi,
        _weatherApiClient = weatherApiClient ?? WeatherApiClient();

  final WeatherApiClient _weatherApiClient;
  final TrackLocationDataProvider _trackLocationDataProvider;

  Stream<List<TrackingLocation>> get trackingLocations =>
      _trackLocationDataProvider.getLocations();

  final _currentWeatherStreamController =
      BehaviorSubject<List<CurrentWeatherData>>.seeded(const []);

  Stream<List<CurrentWeatherData>> get currentWeatherList =>
      _currentWeatherStreamController.asBroadcastStream();

  Stream<List<dynamic>> get weatherDataList => Rx.zip2(
        trackingLocations,
        currentWeatherList,
        (a, b) => [a, b],
      );

  getCurrentWeatherList() async {
    final List<TrackingLocation> locations = await trackingLocations.first;
    final List<CurrentWeatherData> curWeatherList = [];
    for (var location in locations) {
      final currentWeather = await getCurrentWeather(
          location: "${location.lat},${location.lon}", days: 7);

      final currentWeatherData = CurrentWeatherData(
        id: location.id,
        current: currentWeather.current,
        forecast: currentWeather.forecast,
        location: currentWeather.location,
      );
      curWeatherList.add(currentWeatherData);
    }
    _currentWeatherStreamController.add([...curWeatherList]);
  }

  void saveTrackingLocationsList(List<TrackingLocation> locations) {
    _trackLocationDataProvider.saveAllLocation(locations);
  }

  void saveAllCurrentWeatherList(List<CurrentWeatherData> weatherList) {
    _currentWeatherStreamController.add(weatherList);
  }

  Future<CurrentWeather> getCurrentWeather(
      {required String location, required int days}) async {
    final weather = await _weatherApiClient.currentWeather(
      location: location,
      days: days.toString(),
    );
    return weather;
  }

  Future<void> getAndStoreCurrentWeather(
      {required TrackingLocation location}) async {
    final res = await getCurrentWeather(
        location: "${location.lat},${location.lon}", days: 7);
    final currentWeatherList = await _currentWeatherStreamController.first;

    final currentWeatherData = CurrentWeatherData(
      id: location.id,
      location: res.location,
      current: res.current,
      forecast: res.forecast,
    );
    currentWeatherList.add(currentWeatherData);
    _currentWeatherStreamController.add(currentWeatherList);
  }

  Future<List<Forecastday>> getWeatherByDays(
      {required String location, required int days}) async {
    final weather = await getCurrentWeather(
      location: location,
      days: days,
    );
    return weather.forecast.forecastday;
  }

  Future<List<Hour>> getWeatherByHours(
      {required String location, required int days}) async {
    List<Hour> weatherByHours = [];
    try {
      final weather = await getCurrentWeather(
        location: location,
        days: days,
      );
      for (var day = 0; day < days; day++) {
        for (var hour = 0; hour < 24; hour++) {
          final weatherByHour = weather.forecast.forecastday[day].hour[hour];
          weatherByHours.add(weatherByHour);
        }
      }
      return weatherByHours;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<SearchLocation>> searchQueryLocations({
    required String query,
  }) async {
    try {
      final queryLocations = await _weatherApiClient.searchLocation(
        query: query,
      );
      if (queryLocations.isEmpty) {
        throw ApiClientExeption(ApiClientExeptionType.emptyResponse);
      }
      return queryLocations;
    } catch (e) {
      rethrow;
    }
  }

  startTrackingLocation({
    required TrackingLocation location,
  }) {
    try {
      _trackLocationDataProvider.saveLocation(location);
    } catch (e) {
      throw Exception();
    }
  }

  // List<StoredLocationWeather> storeLocationWeather({
  //   required StoredLocationWeather locationWeather,
  // }) {
  //   storedLocationWeatherDataProvider.addWeather(locationWeather);
  //   return locationWeatherList;
  // }

  // Future<bool> hasStoredLocations() async {
  //   final trackList = await _trackLocationDataProvider.loadTrackList();
  //   return trackList.isNotEmpty;
  // }

  // bool deleteTrackingLocations(List<TrackingLocation> locationsList) {
  //   locationsList
  //       .map((location) =>
  //           _trackLocationDataProvider.deleteLocation(location.id))
  //       .toList();
  //   return true;
  // }
}

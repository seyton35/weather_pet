import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_pet/domain/entity/weather_response_current.dart';

class StoredLocationWeather {
  final String id;
  final WeatherResponceCurrent weather;

  StoredLocationWeather({required this.id, required this.weather});

  Map<String, dynamic> _toMap() {
    return <String, dynamic>{
      'id': id,
      'weather': weather,
    };
  }

  factory StoredLocationWeather._fromMap(Map<String, dynamic> map) {
    return StoredLocationWeather(
      id: map['id'] as String,
      weather: map['weather'] as WeatherResponceCurrent,
    );
  }

  String toJson() => json.encode(_toMap());

  factory StoredLocationWeather.fromJson(String source) =>
      StoredLocationWeather._fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class StoredLocationWeatherDataProvider {
  final Future<SharedPreferences> _sP = SharedPreferences.getInstance();

  List<StoredLocationWeather> locationWeatherList = [];

  Future<void> _storeLocationWeatherList() async {
    final list =
        locationWeatherList.map((location) => location.toJson()).toList();
    await (await _sP).setStringList('weather_list', list);
  }

  Future<List<StoredLocationWeather>> loadLocationWeatherList() async {
    final list = (await _sP).getStringList('weather_list') ?? [];
    return locationWeatherList =
        list.map((string) => StoredLocationWeather.fromJson(string)).toList();
  }

  Future<void> addWeather(StoredLocationWeather location) async {
    locationWeatherList.add(location);
    _storeLocationWeatherList();
  }

  Future<void> deleteLocation(String id) async {
    locationWeatherList.removeWhere((location) => location.id == id);
    _storeLocationWeatherList();
  }
}

import 'package:flutter/material.dart';

import 'package:weather_pet/domain/api_clients/api_clients_exception.dart';
import 'package:weather_pet/domain/data_providers/track_location_data_provider.dart';
import 'package:weather_pet/domain/entity/weather_response_current.dart';
import 'package:weather_pet/domain/entity/weather_response_forecast.dart';
import 'package:weather_pet/domain/repositories/weather_repository.dart';
import 'package:weather_pet/library/parsers/weather.dart';
import 'package:weather_pet/ui/navigation/main_navigartion.dart';

class MainScreenHourWeather {
  final String tempTitle;
  final String windSpeedTitle;
  final String time;
  final String iconPath;

  MainScreenHourWeather({
    required this.tempTitle,
    required this.windSpeedTitle,
    required this.time,
    required this.iconPath,
  });
}

class MainScreenWeather {
  final String iconPath;
  final String tempTitle;
  final String minTempTitle;
  final String maxTempTitle;
  final List<MainScreenHourWeather> hourWeatherList;

  MainScreenWeather({
    required this.iconPath,
    required this.tempTitle,
    required this.minTempTitle,
    required this.maxTempTitle,
    required this.hourWeatherList,
  });
}

class MainScreenViewModelState {
  List<TrackingLocation> trackLocationsList = [];
  List<MainScreenWeather> locationsWeatherList = [];
  String screenTitle = '';
}

class MainScreenViewModel extends ChangeNotifier {
  final _weatherRepo = WeatherRepository();
  final _date = DateTime.now();
  final BuildContext _context;

  final _state = MainScreenViewModelState();
  MainScreenViewModelState get state => _state;

  MainScreenViewModel(this._context) {
    init();
  }

  void init() async {
    await _weatherRepo.init();
    _state.trackLocationsList = _weatherRepo.locationTrackList;
    _state.screenTitle = _state.trackLocationsList[0].title;
    _state.trackLocationsList.map((location) async {
      try {
        final res = await _weatherRepo.getTargetLocationForecast(
            location: location.title, days: 2);
        final currentWeather = parser(res);
        _state.locationsWeatherList.add(currentWeather);
        notifyListeners();
      } on ApiClientExeption catch (e) {
        switch (e.type) {
          case ApiClientExeptionType.emptyResponse:
            break;
          default:
        }
      }
    }).toList();
  }

  void setScreenTitle({required int index}) {
    final title = _state.trackLocationsList[index].title;
    _state.screenTitle = title;
    notifyListeners();
  }

  void onWeeklyWeatherButtonTap() {
    Navigator.of(_context).pushNamed(MainNavigationRouteNames.weeklyWeather,
        arguments: _state.screenTitle);
  }

  void onAppBarLeadingButtonTap() {
    Navigator.of(_context).pushNamed(MainNavigationRouteNames.chooseLocation);
  }

  MainScreenWeather parser(WeatherResponceCurrent weather) {
    List<MainScreenHourWeather> hourWeatherList = [];
    final forecastday = weather.forecast!.forecastday;
    List<Hour> hourList = [];
    hourList.addAll(forecastday[0].hour + forecastday[1].hour);
    bool firstLoop = true;
    for (var i = _date.hour; i <= _date.hour + 24; i++) {
      final hour = hourList[i];
      final tempTitle = hour.tempC.round().toString();
      final windSpeedTitle = hour.windKph.toString();
      String time = hour.time.substring(11);
      if (firstLoop) {
        firstLoop = false;
        time = 'Сейчас';
      }

      final iconPath = hour.condition.icon
          .replaceFirst('//cdn.weatherapi.com/', 'lib/domain/resources/');
      hourWeatherList.add(
        MainScreenHourWeather(
            tempTitle: tempTitle,
            windSpeedTitle: windSpeedTitle,
            time: time,
            iconPath: iconPath),
      );
    }
    final current = weather.current!;
    final iconPath = current.condition.icon
        .replaceFirst('//cdn.weatherapi.com/', 'lib/domain/resources/');
    final tempTitle = current.tempC.round().toString();
    final map = WeatherParser()
        .getMinMaxDayTemperatureInt(hourList: forecastday[0].hour);
    final minTempTitle = map['min_temp'].toString();
    final maxTempTitle = map['max_temp'].toString();

    final currentWeather = MainScreenWeather(
        iconPath: iconPath,
        tempTitle: tempTitle,
        minTempTitle: minTempTitle,
        maxTempTitle: maxTempTitle,
        hourWeatherList: hourWeatherList);

    return currentWeather;
  }
}

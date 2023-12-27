import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_pet/domain/api_clients/api_clients_exception.dart';
import 'package:weather_pet/domain/entity/weather_response_current.dart';
import 'package:weather_pet/domain/repositories/weather_repository.dart';
import 'package:weather_pet/library/parsers/date_parser.dart';
import 'package:weather_pet/library/parsers/wind_dirrection.dart';

class WeeklyWeatherViewModelDay {
  final String dayOfWeek;
  final String date;
  final String dayIconPath;
  final String nightIconPath;
  final String maxTempTitle;
  final String minTempTitle;
  final double windDegree;
  final String windSpeedTitle;

  WeeklyWeatherViewModelDay({
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

class _ViewModelState {
  final String errorTitle;
  final String locationTitle;
  final List<WeeklyWeatherViewModelDay> daysWeatherList;

  _ViewModelState({
    this.errorTitle = '',
    required this.locationTitle,
    this.daysWeatherList = const [],
  });

  _ViewModelState copyWith({
    String? errorTitle,
    String? locationTitle,
    List<WeeklyWeatherViewModelDay>? daysWeatherList,
  }) {
    return _ViewModelState(
      errorTitle: errorTitle ?? this.errorTitle,
      locationTitle: locationTitle ?? this.locationTitle,
      daysWeatherList: daysWeatherList ?? this.daysWeatherList,
    );
  }
}

class WeeklyWeatherViewModel extends ChangeNotifier {
  final _weatherRepository = WeatherRepository();
  final _dateFormat = DateFormat();

  late _ViewModelState _state;
  _ViewModelState get state => _state;

  WeeklyWeatherViewModel({required String locationTitle}) {
    init(locationTitle: locationTitle);
  }

  Future<void> init({required String locationTitle}) async {
    _state = _ViewModelState(locationTitle: locationTitle);
    await getWeeklyWeather();
  }

  Future<void> getWeeklyWeather() async {
    try {
      final weather = await _weatherRepository.getTargetLocationForecast(
          location: _state.locationTitle, days: 7);
      parseWeatherDaysList(weather);
    } on ApiClientExeption catch (e) {
      switch (e.type) {
        case ApiClientExeptionType.emptyResponse:
          _state = _state.copyWith(errorTitle: 'не удалось загрузить прогноз');
          notifyListeners();
          break;
        default:
          break;
      }
    } catch (e) {
      _state = _state.copyWith(errorTitle: 'неизвестная ошибка');
      notifyListeners();
    }
  }

  void parseWeatherDaysList(WeatherResponceCurrent weather) {
    List<WeeklyWeatherViewModelDay> daysList = [];
    final forecastList = weather.forecast!.forecastday;

    forecastList.map((forecastday) {
      final dayRaw = forecastday.day;
      //todo change to day of week
      final dayOfWeek = DateParser()
          .dayOfWeekRu(date: forecastday.date, upperCaseFirst: true);
      final date = _dateFormat.format(forecastday.date);
      final maxnTemp = dayRaw.maxtempC.round().toString();
      final minTemp = dayRaw.mintempC.round().toString();

      final hours = forecastday.hour;
      final dayIconPath = dayRaw.condition.icon
          .replaceFirst('//cdn.weatherapi.com/', 'lib/domain/resources/');
      final nightIconPath = hours[3]
          .condition
          .icon
          .replaceFirst('//cdn.weatherapi.com/', 'lib/domain/resources/');
      final windDegree = WindDirrectionParser.rountWindDirrection(
        windDegree: hours[15].windDegree.toDouble(),
      );
      final windSpeed = dayRaw.maxwindKph.toString();

      final day = WeeklyWeatherViewModelDay(
          dayOfWeek: dayOfWeek,
          date: date,
          dayIconPath: dayIconPath,
          nightIconPath: nightIconPath,
          maxTempTitle: maxnTemp,
          minTempTitle: minTemp,
          windDegree: windDegree,
          windSpeedTitle: windSpeed);
      daysList.add(day);
    }).toList();
    _state = _state.copyWith(daysWeatherList: daysList);
    notifyListeners();
  }
}

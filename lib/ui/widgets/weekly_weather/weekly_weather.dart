import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:weather_pet/domain/api_clients/api_clients_exception.dart';
import 'package:weather_pet/domain/data_providers/store_weather_data_provider.dart';
import 'package:weather_pet/domain/entity/weather_response_current.dart';
import 'package:weather_pet/domain/repositories/weather_repository.dart';
import 'package:weather_pet/library/parsers/date_parser.dart';
import 'package:weather_pet/library/parsers/wind_dirrection.dart';
import 'package:weather_pet/ui/widgets/main_app/main_app.dart';

class _Day {
  final String dayOfWeek;
  final String date;
  final String dayIconPath;
  final String nightIconPath;
  final String maxTempTitle;
  final String minTempTitle;
  final double windDegree;
  final String windSpeedTitle;

  _Day({
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
  final String locationId;
  final bool alreadyTracking;
  final List<_Day> daysWeatherList;
  final List<StoredLocationWeather> locationWeatherList;

  _ViewModelState({
    this.errorTitle = '',
    required this.locationTitle,
    required this.locationId,
    required this.alreadyTracking,
    this.daysWeatherList = const [],
    required this.locationWeatherList,
  });

  _ViewModelState copyWith({
    String? errorTitle,
    String? locationTitle,
    String? locationId,
    bool? alreadyTracking,
    List<_Day>? daysWeatherList,
    List<StoredLocationWeather>? locationWeatherList,
  }) {
    return _ViewModelState(
      errorTitle: errorTitle ?? this.errorTitle,
      locationTitle: locationTitle ?? this.locationTitle,
      locationId: locationId ?? this.locationId,
      alreadyTracking: alreadyTracking ?? this.alreadyTracking,
      daysWeatherList: daysWeatherList ?? this.daysWeatherList,
      locationWeatherList: locationWeatherList ?? this.locationWeatherList,
    );
  }
}

class _ViewModel extends ChangeNotifier {
  final _weatherRepository = WeatherRepository();
  final _dateFormat = DateFormat();

  late _ViewModelState _state;
  _ViewModelState get state => _state;

  _ViewModel({
    required String locationTitle,
    required String locationId,
    required bool alreadyTracking,
    required List<StoredLocationWeather> locationWeatherList,
  }) {
    _state = _ViewModelState(
        locationTitle: locationTitle,
        locationId: locationId,
        alreadyTracking: alreadyTracking,
        locationWeatherList: locationWeatherList);
    init();
  }

  Future<void> init() async {
    await getWeeklyWeather();
  }

  Future<void> getWeeklyWeather() async {
    bool weatherFound = false;
    late WeatherResponceCurrent weather;
    for (var locationWeather in _state.locationWeatherList) {
      if (locationWeather.id == _state.locationId) {
        weatherFound = true;
        print('stored');
        weather = locationWeather.weather;
        break;
      }
    }
    if (weatherFound == false) {
      print('reqested');
      try {
        weather = await _weatherRepository.getTargetLocationForecast(
            location: _state.locationTitle, days: 7);
      } on ApiClientExeption catch (e) {
        switch (e.type) {
          case ApiClientExeptionType.emptyResponse:
            _state =
                _state.copyWith(errorTitle: 'не удалось загрузить прогноз');
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
    final daysList = parseWeatherDaysList(weather);
    _state = _state.copyWith(daysWeatherList: daysList);
    notifyListeners();
  }

  List<_Day> parseWeatherDaysList(WeatherResponceCurrent weather) {
    List<_Day> daysList = [];
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

      final day = _Day(
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
    return daysList;
  }
}

class WeeklyWeather extends StatelessWidget {
  const WeeklyWeather({super.key});

  static Widget create({
    required String locationTitle,
    required String locationId,
    required bool alreadyTracking,
  }) {
    return ChangeNotifierProvider(
      create: (context) {
        final locationWeatherList =
            context.read<MainAppModel>().locationWeatherList;
        return _ViewModel(
          locationTitle: locationTitle,
          locationId: locationId,
          alreadyTracking: alreadyTracking,
          locationWeatherList: locationWeatherList ?? [],
        );
      },
      child: const WeeklyWeather(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const _AppBarTitle()),
      body: _DaylyWeather(),
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle();

  @override
  Widget build(BuildContext context) {
    final title = context.select((_ViewModel vm) => vm.state.locationTitle);
    return Text(title);
  }
}

class _DaylyWeather extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final daysWeatherList =
        context.select((_ViewModel vm) => vm.state.daysWeatherList);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: daysWeatherList.length,
          itemBuilder: (context, index) => _DayWeatherWidget(
              dayWeather: daysWeatherList[index], index: index),
        ),
      ),
    );
  }
}

class _DayWeatherWidget extends StatelessWidget {
  final _Day dayWeather;
  final int index;
  const _DayWeatherWidget({required this.dayWeather, required this.index});

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 14);
    // todo: calculate width correctly
    final width = MediaQuery.of(context).size.width / 4;
    final decoration = index != 0
        ? null
        : BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[200],
          );
    final weekTitle = index == 0 ? 'Сегодня' : dayWeather.dayOfWeek;
    return Container(
        width: width,
        height: double.infinity,
        decoration: decoration,
        child: Column(
          children: [
            const SizedBox(height: 30),
            Text(weekTitle, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 10),
            Text(dayWeather.date),
            const SizedBox(height: 20),
            Image.asset(
              (dayWeather.dayIconPath),
              width: 50,
              height: 50,
            ),
            const SizedBox(height: 10),
            Text('${dayWeather.maxTempTitle}°',
                style: const TextStyle(fontSize: 18)),
            const Spacer(),
            Text('${dayWeather.minTempTitle}°',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Image.asset(
              (dayWeather.nightIconPath),
              width: 50,
              height: 50,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Transform.rotate(
                  angle: (dayWeather.windDegree - 90) * -3.14 / 180,
                  child: const Icon(
                    Icons.navigation,
                  ),
                ),
                Text('${dayWeather.windSpeedTitle} км/ч', style: textStyle),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ));
  }
}

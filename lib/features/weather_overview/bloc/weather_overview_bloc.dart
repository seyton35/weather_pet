import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:weather_pet/domain/navigation/main_navigartion.dart';
import 'package:weather_pet/features/weather_overview/models/models.dart';
import 'package:weather_pet/domain/parsers/weather.dart';
import 'package:weather_repository/weather_repository.dart';

part 'weather_overview_event.dart';
part 'weather_overview_state.dart';

class WeatherOverviewBloc
    extends Bloc<WeatherOverviewEvent, WeatherOverviewState> {
  final WeatherRepository _weatherRepository;
  final BuildContext _context;
  WeatherOverviewBloc(
      {required WeatherRepository weatherRepository,
      required BuildContext context})
      : _context = context,
        _weatherRepository = weatherRepository,
        super(const WeatherOverviewState()) {
    on<WeatherOverviewEventSubscription>(_onSubscriptionRequest);
    on<WeatherOverviewEventTitleChange>(_onTitleChange);
    on<WeatherOverviewEventAddLocationButtonTap>(_onAddLocationButtonTap);
    on<WeatherOverviewEventWeeklyWeatherButtonTap>(_onWeeklyWeatherTap);
    on<WeatherOverviewEventSettingsButtonTap>(_onSettingsButtonTap);
  }

  Future<void> _onSubscriptionRequest(
    WeatherOverviewEventSubscription event,
    Emitter<WeatherOverviewState> emit,
  ) async {
    try {
      await _weatherRepository.getCurrentWeatherList();
      final trackLocationsList =
          await _weatherRepository.trackingLocations.first;
      final locationTitle = trackLocationsList[0].title;
      emit(state.copyWith(
        status: () => WeatherOverviewStatus.loading,
        locationTitle: () => locationTitle,
      ));
      await emit.forEach<List<CurrentWeatherData>>(
        _weatherRepository.currentWeatherList,
        onData: (data) => state.copyWith(
          status: () => WeatherOverviewStatus.success,
          weatherList: () => _listWeatherParser(data),
        ),
      );
    } on ApiClientExeption catch (e) {
      switch (e.type) {
        case ApiClientExeptionType.network:
          emit(state.copyWith(
            status: () => WeatherOverviewStatus.error,
            errorTitle: () => 'Проверьте интернет-соеденение',
          ));
          break;
        default:
          throw Error();
      }
    } catch (e) {
      emit(state.copyWith(
        status: () => WeatherOverviewStatus.error,
        errorTitle: () => 'неизвестная ошибка',
      ));
    }
  }

  Future<void> _onTitleChange(
    WeatherOverviewEventTitleChange event,
    Emitter<WeatherOverviewState> emit,
  ) async {
    final location = await _weatherRepository.trackingLocations.first;
    final locationTitle = location[event.index].title;
    emit(state.copyWith(
      locationTitle: () => locationTitle,
    ));
  }

  void _onAddLocationButtonTap(
    WeatherOverviewEventAddLocationButtonTap event,
    Emitter<WeatherOverviewState> emit,
  ) {
    Navigator.of(_context).pushNamed(
      MainNavigationRouteNames.locationSettings,
    );
  }

  _onWeeklyWeatherTap(
    WeatherOverviewEventWeeklyWeatherButtonTap event,
    Emitter<WeatherOverviewState> emit,
  ) {
    Navigator.of(_context).pushNamed(MainNavigationRouteNames.weeklyWeather,
        arguments: <String, dynamic>{
          "location_id": event.locationId,
          "location_title": event.locationTitle,
        });
  }

  void _onSettingsButtonTap(
    WeatherOverviewEventSettingsButtonTap event,
    Emitter<WeatherOverviewState> emit,
  ) {
    Navigator.of(_context).pushNamed(MainNavigationRouteNames.settings);
  }

  List<Weather> _listWeatherParser(List<CurrentWeatherData> rawList) {
    final List<Weather> list = [];
    for (var weather in rawList) {
      list.add(_parser(weather));
    }
    return list;
  }

  Weather _parser(CurrentWeatherData weather) {
    final date = DateTime.now();
    List<HourlyWeather> hourWeatherList = [];
    final forecastday = weather.forecast.forecastday;
    List<Hour> hourList = [];
    hourList.addAll(forecastday[0].hour + forecastday[1].hour);
    bool firstLoop = true;
    for (var i = date.hour; i <= date.hour + 24; i++) {
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
        HourlyWeather(
            tempTitle: tempTitle,
            windSpeedTitle: windSpeedTitle,
            time: time,
            iconPath: iconPath),
      );
    }
    final current = weather.current;
    final iconPath = current.condition.icon
        .replaceFirst('//cdn.weatherapi.com/', 'lib/domain/resources/');
    final tempTitle = current.tempC.round().toString();
    final map = WeatherParser()
        .getMinMaxDayTemperatureInt(hourList: forecastday[0].hour);
    final minTempTitle = map['min_temp'].toString();
    final maxTempTitle = map['max_temp'].toString();
    final id = weather.id;
    final locationTitle = weather.location.name;

    final currentWeather = Weather(
        id: id,
        lcoationTitle: locationTitle,
        iconPath: iconPath,
        tempTitle: tempTitle,
        minTempTitle: minTempTitle,
        maxTempTitle: maxTempTitle,
        hourWeatherList: hourWeatherList);

    return currentWeather;
  }
}

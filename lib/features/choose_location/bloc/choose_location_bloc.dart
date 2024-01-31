import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:local_storage_tracking_locations_api/local_storage_tracking_locations_api.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weather_pet/domain/navigation/main_navigartion.dart';
import 'package:weather_pet/domain/parsers/date_parser.dart';
import 'package:weather_repository/weather_repository.dart' hide Location, Day;
import 'package:weather_pet/features/choose_location/choose_location.dart';

part 'choose_location_event.dart';
part 'choose_location_state.dart';

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}

class ChooseLocationBloc
    extends Bloc<ChooseLocationEvent, ChooseLocationState> {
  final WeatherRepository _weatherRepository;
  final BuildContext _context;
  final bool isRootRoute;
  List<SearchLocation> searchedLocationsListRaw = [];
  ChooseLocationBloc({
    required weatherRepository,
    required context,
    required this.isRootRoute,
  })  : _weatherRepository = weatherRepository,
        _context = context,
        super(const ChooseLocationState()) {
    on<ChooseLocationEventChangeQuery>(_onChangeSearchQuery,
        transformer: debounce(const Duration(milliseconds: 700)));
    on<ChooseLocationEventCanselButtonTap>(_onCanselButtonTap);
    on<ChooseLocationEventButtonTap>(_onLocationButtonTap);
    on<ChooseLocationEventItemTap>(_onLocationItemTap);
  }

  Future<void> _onChangeSearchQuery(
    ChooseLocationEventChangeQuery event,
    Emitter<ChooseLocationState> emit,
  ) async {
    final text = event.textQuery.trim();
    final searchQuery = text.isNotEmpty ? text : null;
    if (searchQuery != null && searchQuery.length < 3) return;
    if (searchQuery == state.searchQuery) return;

    emit(state.copyWith(
      status: () => ChooseLocationBlocStatus.loading,
      searchQuery: () => text,
      errorTitle: () => '',
      locationsList: () => [],
      locationDaylyWeatherList: () => [],
    ));
    try {
      searchedLocationsListRaw = await _weatherRepository.searchQueryLocations(
          query: state.searchQuery);
      final locationsList = await _parserLocationList(searchedLocationsListRaw);
      emit(state.copyWith(
        status: () => ChooseLocationBlocStatus.success,
        locationsList: () => locationsList,
      ));
    } on ApiClientExeption catch (e) {
      switch (e.type) {
        case ApiClientExeptionType.emptyResponse:
          emit(state.copyWith(
            status: () => ChooseLocationBlocStatus.error,
            errorTitle: () => 'по вашему запросу ничего не найдено',
          ));
          break;
        default:
          emit(state.copyWith(
            status: () => ChooseLocationBlocStatus.error,
            errorTitle: () => 'неизвестная ошибка',
          ));
          break;
      }
    } catch (e) {
      emit(state.copyWith(
        status: () => ChooseLocationBlocStatus.error,
        errorTitle: () => 'неизвестная ошибка',
      ));
    }
    if (state.locationsList.isEmpty) return;
    try {
      final currentWeather = await _weatherRepository.getCurrentWeather(
          location: state.locationsList.first.locationTitle, days: 5);
      final forecastDaysList = currentWeather.forecast.forecastday;
      final daysList = _parseWeatherDaysList(forecastDaysList);
      emit(state.copyWith(
        status: () => ChooseLocationBlocStatus.success,
        locationDaylyWeatherList: () => daysList,
      ));
      // } on ApiClientExeption catch (e) {
      //   switch (e.type) {
      //     case ApiClientExeptionType.emptyResponse:
      //       state.errorDayWeatherTitle = 'не удалось загрузить прогноз';
      //       break;
      //     default:
      //       state.errorDayWeatherTitle = 'ApiClientExeption';
      //       break;
      //   }
    } catch (e) {
      // state.errorDayWeatherTitle = 'неизвестная ошибка';
    }
  }

  void _onCanselButtonTap(
    ChooseLocationEventCanselButtonTap event,
    Emitter<ChooseLocationState> emit,
  ) {
    if (isRootRoute) {
      exit(0);
    } else {
      Navigator.of(_context).maybePop();
    }
  }

  void _onLocationItemTap(
    ChooseLocationEventItemTap event,
    Emitter<ChooseLocationState> emit,
  ) {
    if (isRootRoute) {
      // app first start
      _trackLocation(event.location);
      _navigateToMainScreen();
    } else {
      _navigateToDaylyWeather(
        locationId: event.location.id,
        locationTitle: event.location.locationTitle,
      );
    }
  }

  Future<void> _onLocationButtonTap(
    ChooseLocationEventButtonTap event,
    Emitter<ChooseLocationState> emit,
  ) async {
    if (isRootRoute) {
      // app first start
      _trackLocation(event.location);
      _navigateToMainScreen();
    } else {
      final locationsList = await _trackLocation(event.location);
      emit(state.copyWith(locationsList: () => locationsList));
    }
  }

  Future<List<Location>> _parserLocationList(
      List<SearchLocation> listRaw) async {
    final locationsList = await _weatherRepository.trackingLocations.first;
    final List<Location> list = listRaw.map((location) {
      final locationTitle = location.name;
      final regionTitle = location.country;
      final id = location.id.toString();
      var alreadyTracking = false;
      for (var track in locationsList) {
        if (track.id == location.id.toString()) {
          alreadyTracking = true;
          break;
        }
      }
      return Location(
        id: id,
        locationTitle: locationTitle,
        regionTitle: regionTitle,
        alreadyTracking: alreadyTracking,
      );
    }).toList();
    return list;
  }

  Future<List<Location>> _trackLocation(Location loc) async {
    final locationId = int.tryParse(loc.id);
    final searchLocation = searchedLocationsListRaw
        .firstWhere((element) => element.id == locationId);
    final location = TrackingLocation(
      id: searchLocation.id.toString(),
      title: searchLocation.name,
      lat: searchLocation.lat,
      lon: searchLocation.lon,
    );
    _weatherRepository.startTrackingLocation(location: location);
    final trackingLocationsList =
        await _weatherRepository.trackingLocations.first;
    final locationsList = state.locationsList;
    for (var i = 0; i < locationsList.length; i++) {
      var l = locationsList[i];
      for (var track in trackingLocationsList) {
        if (track.id == l.id) {
          locationsList[i] = Location(
            id: l.id,
            locationTitle: l.locationTitle,
            regionTitle: l.regionTitle,
            alreadyTracking: true,
          );
          break;
        }
      }
    }
    return locationsList;
  }

  void _navigateToDaylyWeather({
    required String locationTitle,
    required String locationId,
  }) {
    final location = searchedLocationsListRaw
        .firstWhere((element) => element.id == int.tryParse(locationId));
    Navigator.of(_context).pushNamed(
      MainNavigationRouteNames.weeklyWeather,
      arguments: {
        'location_title': locationTitle,
        'location_id': locationId,
        'lat': location.lat.toString(),
        'lon': location.lon.toString(),
      },
    );
  }

  void _navigateToMainScreen() {
    Navigator.of(_context).pushNamedAndRemoveUntil(
        MainNavigationRouteNames.weatherOverview, (route) => false);
  }

  List<Day> _parseWeatherDaysList(List<Forecastday> list) {
    List<Day> daysList = [];
    for (var forecastday in list) {
      final dayRaw = forecastday.day;
      final dayOfWeek = DateParser().dayOfWeekRu(
        date: forecastday.date,
        short: true,
        upperCaseFirst: true,
      );
      final iconPath = dayRaw.condition.icon
          .replaceFirst('//cdn.weatherapi.com/', 'lib/domain/resources/');
      final maxnTemp = dayRaw.maxtempC.round().toString();
      final minTemp = dayRaw.mintempC.round().toString();

      final day = Day(
        dayOfWeekTitle: dayOfWeek,
        iconPath: iconPath,
        maxTempTitle: maxnTemp,
        minTempTitle: minTemp,
      );
      daysList.add(day);
    }
    return daysList;
  }
}

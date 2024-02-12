import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:local_storage_tracking_locations_api/local_storage_tracking_locations_api.dart';
import 'package:weather_pet/domain/navigation/main_navigartion.dart';
import 'package:weather_pet/domain/parsers/weather.dart';
import 'package:weather_repository/weather_repository.dart' hide Location;
import 'package:weather_pet/features/locations_settings/location_settings.dart';

part 'location_settings_event.dart';
part 'location_settings_state.dart';

class LocationSettingsBloc
    extends Bloc<LocationSettingsEvent, LocationSettingsState> {
  final BuildContext _context;
  final WeatherRepository _weatherRepository;
  LocationSettingsBloc(
      {required WeatherRepository weatherRepository,
      required BuildContext context})
      : _context = context,
        _weatherRepository = weatherRepository,
        super(const LocationSettingsState()) {
    on<LocationSettingsEventSubscription>(_onSubscription);
    on<LocationSettingsEventSearchButtonTap>(_onSearchButtonTap);
    on<LocationSettingsEventEditing>(_onEditing);
    on<LocationSettingsEventDragging>(_onDragging);
    on<LocationSettingsEventToggleCheck>(_onToggleCheck);
    on<LocationSettingsEventDeleteButtonTap>(_onDeleteButtonTap);
    on<LocationSettingsEventCheckAll>(_onCheckAll);
  }

  Future<void> _onSubscription(
    LocationSettingsEventSubscription event,
    Emitter<LocationSettingsState> emit,
  ) async {
    try {
      await emit.forEach<List<dynamic>>(
        _weatherRepository.weatherDataList,
        onData: (data) {
          final trackingLocations = data[0] as List<TrackingLocation>;
          final currentWeatherList = data[1] as List<CurrentWeatherData>;
          return state.copyWith(
            status: () => LocationSettingsStatus.success,
            locationsList: () => _lcoationListParser(
              weatherlistRaw: currentWeatherList,
              locationlistRaw: trackingLocations,
            ),
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(
        status: () => LocationSettingsStatus.error,
        errorTitle: () => 'неизвестная ошибка',
      ));
    }
  }

  void _onSearchButtonTap(
    LocationSettingsEventSearchButtonTap event,
    Emitter<LocationSettingsState> emit,
  ) {
    Navigator.of(_context).pushNamed(
      MainNavigationRouteNames.chooseLocation,
      arguments: false,
    );
  }

  Future<void> _onEditing(
    LocationSettingsEventEditing event,
    Emitter<LocationSettingsState> emit,
  ) async {
    if (event.editing) {
      emit(state.copyWith(
        status: () => LocationSettingsStatus.editing,
      ));
      return;
    }
    final trackList = await _weatherRepository.trackingLocations.first;
    final weatherList = await _weatherRepository.currentWeatherList.first;
    final List<TrackingLocation> newTrackList = [];
    final List<CurrentWeatherData> newWeatherList = [];
    for (var index = 0; index < state.locationsList.length; index++) {
      final id = state.locationsList[index].id;
      final track = trackList.firstWhere((element) => element.id == id);
      newTrackList.add(track);
      final weather = weatherList.firstWhere((element) => element.id == id);
      newWeatherList.add(weather);
    }
    try {
      _weatherRepository.saveAllCurrentWeatherList(newWeatherList);
      _weatherRepository.saveTrackingLocationsList(newTrackList);
    } catch (e) {
      emit(state.copyWith(
          status: () => LocationSettingsStatus.error,
          errorTitle: () => 'что-то пошло не так'));
    }
    emit(state.copyWith(
      status: () => LocationSettingsStatus.success,
    ));
  }

  void _onDragging(
    LocationSettingsEventDragging event,
    Emitter<LocationSettingsState> emit,
  ) {
    int newIndex = event.newIndex;
    int oldIndex = event.oldIndex;
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final locations = [...state.locationsList];
    final element = locations.removeAt(oldIndex);
    locations.insert(newIndex, element);
    emit(state.copyWith(
      locationsList: () => locations,
    ));
  }

  void _onToggleCheck(
    LocationSettingsEventToggleCheck event,
    Emitter<LocationSettingsState> emit,
  ) {
    final locations = [...state.locationsList];
    bool check = !locations[event.index].check;
    locations[event.index] = locations[event.index].copyWith(check: check);
    emit(state.copyWith(
      locationsList: () => locations,
      checkedItemsCount: () =>
          check ? state.checkedItemsCount + 1 : state.checkedItemsCount - 1,
    ));
  }

  Future<void> _onDeleteButtonTap(
    LocationSettingsEventDeleteButtonTap event,
    Emitter<LocationSettingsState> emit,
  ) async {
    final trackList = await _weatherRepository.trackingLocations.first;
    final weatherList = await _weatherRepository.currentWeatherList.first;
    final locations = [...state.locationsList];
    if (locations.length == state.checkedItemsCount) {
      _weatherRepository.saveTrackingLocationsList([]);
      _weatherRepository.saveAllCurrentWeatherList([]);
      Navigator.of(_context).pushNamedAndRemoveUntil(
          MainNavigationRouteNames.chooseLocation, (route) => false);
    } else {
      for (var index = 0; index < locations.length; index++) {
        final item = state.locationsList[index];
        if (item.check) {
          trackList.removeWhere((element) => element.id == item.id);
          weatherList.removeWhere((element) => element.id == item.id);
          locations.removeAt(index);
        }
      }
      _weatherRepository.saveTrackingLocationsList(trackList);
      _weatherRepository.saveAllCurrentWeatherList(weatherList);
      emit(state.copyWith(
        checkedItemsCount: () => 0,
        status: () => LocationSettingsStatus.success,
        locationsList: () => locations,
      ));
    }
  }

  void _onCheckAll(
    LocationSettingsEventCheckAll event,
    Emitter<LocationSettingsState> emit,
  ) {
    final isAllMarked = state.locationsList.length == state.checkedItemsCount;
    final locations = state.locationsList
        .map((element) => element.copyWith(check: isAllMarked ? false : true))
        .toList();
    emit(state.copyWith(
      checkedItemsCount: () => isAllMarked ? 0 : locations.length,
      locationsList: () => locations,
    ));
  }

  List<Location> _lcoationListParser({
    required List<CurrentWeatherData> weatherlistRaw,
    required List<TrackingLocation> locationlistRaw,
  }) {
    final List<Location> list = [];
    for (var index = 0; index < weatherlistRaw.length; index++) {
      final item = weatherlistRaw[index];
      final map = WeatherParser().getMinMaxDayTemperatureInt(
        hourList: item.forecast.forecastday[0].hour,
      );
      final maxTempTitle = map['max_temp'].toString();
      final minTempTitle = map['min_temp'].toString();

      list.add(Location(
        id: item.id,
        locationTitle: locationlistRaw[index].title,
        regionTitle: item.location.country,
        currentTempTitle: '${item.current.tempC.round()}°',
        maxTempTitle: '$maxTempTitle°',
        minTempTitle: '$minTempTitle°/',
        iconPath: item.current.condition.icon
            .replaceFirst('//cdn.weatherapi.com/', 'lib/domain/resources/'),
      ));
    }
    return list;
  }
}

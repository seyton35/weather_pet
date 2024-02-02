import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:local_storage_tracking_locations_api/local_storage_tracking_locations_api.dart';
import 'package:weather_pet/domain/navigation/main_navigartion.dart';
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
    on<LocationSettingsEventEditingButtonTap>(_onEditingButtonTap);
    on<LocationSettingsEventDragging>(_onDragging);
    on<LocationSettingsEventToggleCheck>(_onToggleCheck);
  }

  Future<void> _onSubscription(
    LocationSettingsEventSubscription event,
    Emitter<LocationSettingsState> emit,
  ) async {
    try {
      final currentWeatherList =
          await _weatherRepository.currentWeatherList.first;
      final trackingLocations =
          await _weatherRepository.trackingLocations.first;
      emit(state.copyWith(
        status: () => LocationSettingsStatus.success,
        locationsList: () => _lcoationListParser(
          weatherlistRaw: currentWeatherList,
          locationlistRaw: trackingLocations,
        ),
      ));
      // await emit.forEach<List<CurrentWeatherData>>(
      //   _weatherRepository.currentWeatherList,
      //   onData: (data) => state.copyWith(
      //     status: () => LocationSettingsStatus.success,
      //     locationsList: () => _lcoationListParser(
      //       weatherlistRaw: currentWeatherList,
      //       locationlistRaw: trackingLocations,
      //     ),
      //   ),
      // );
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

  void _onEditingButtonTap(
    LocationSettingsEventEditingButtonTap event,
    Emitter<LocationSettingsState> emit,
  ) {
    emit(state.copyWith(
      status: () => state.status == LocationSettingsStatus.success
          ? LocationSettingsStatus.editing
          : LocationSettingsStatus.success,
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
    locations[event.index].check = !locations[event.index].check;
    emit(state.copyWith(locationsList: () => locations));
  }

  List<Location> _lcoationListParser({
    required List<CurrentWeatherData> weatherlistRaw,
    required List<TrackingLocation> locationlistRaw,
  }) {
    final List<Location> list = [];
    for (var index = 0; index < weatherlistRaw.length; index++) {
      final item = weatherlistRaw[index];
      list.add(Location(
        id: item.id,
        locationTitle: locationlistRaw[index].title,
        regionTitle: item.location.country,
        currentTempTitle: item.current.tempC.toString(),
        maxTempTitle: '0',
        minTempTitle: '0',
        iconPath: item.current.condition.icon
            .replaceFirst('//cdn.weatherapi.com/', 'lib/domain/resources/'),
      ));
    }
    return list;
  }
}

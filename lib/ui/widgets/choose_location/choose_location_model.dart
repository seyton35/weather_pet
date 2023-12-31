import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:weather_pet/domain/api_clients/api_clients_exception.dart';
import 'package:weather_pet/domain/data_providers/track_location_data_provider.dart';
import 'package:weather_pet/domain/entity/location_response.dart';
import 'package:weather_pet/domain/entity/weather_response_forecast.dart';
import 'package:weather_pet/domain/repositories/weather_repository.dart';
import 'package:weather_pet/library/parsers/date_parser.dart';
import 'package:weather_pet/ui/navigation/main_navigartion.dart';

class _Day {
  final String dayOfWeekTitle;
  final String iconPath;
  final String maxTempTitle;
  final String minTempTitle;
  _Day({
    required this.dayOfWeekTitle,
    required this.iconPath,
    required this.maxTempTitle,
    required this.minTempTitle,
  });
}

class ChooseLocationViewModelLocation {
  final String id;
  final String locationTitle;
  final String regionTitle;
  final bool alreadyTracking;

  ChooseLocationViewModelLocation({
    required this.id,
    required this.locationTitle,
    required this.regionTitle,
    required this.alreadyTracking,
  });
}

class _ViewModelState {
  String? searchQuery;
  String? errorTitle;
  String? errorDayWeatherTitle;
  List<_Day> locationDaysList;
  List<ChooseLocationViewModelLocation> _locationsList;
  List<ChooseLocationViewModelLocation> get locationsList =>
      [..._locationsList];
  List<TrackingLocation> tracklocationsList;

  _ViewModelState({
    this.errorDayWeatherTitle,
    this.errorTitle,
    this.searchQuery = '',
    this.locationDaysList = const [],
    List<ChooseLocationViewModelLocation> locationsList = const [],
    this.tracklocationsList = const [],
  }) : _locationsList = locationsList;
}

class ChooseLocationViewModel extends ChangeNotifier {
  final _weatherRepository = WeatherRepository();
  var _state = _ViewModelState();
  _ViewModelState get state => _state;
  final BuildContext _context;
  Timer? searchDebounce;

  Future<void> _loadValue() async {
    await _weatherRepository.init();
    _state.tracklocationsList = _weatherRepository.locationTrackList;
  }

  ChooseLocationViewModel({required BuildContext context})
      : _context = context {
    _loadValue();
  }

  void onCancelButtonTap() {
    final parentRoute = ModalRoute.of(_context);
    if (parentRoute?.impliesAppBarDismissal ?? false) {
      Navigator.of(_context).maybePop();
    } else {
      exit(0);
    }
  }

  void onLocationWidgetTap(ChooseLocationViewModelLocation locationResponse) {
    final parentRoute = ModalRoute.of(_context);
    if (parentRoute?.impliesAppBarDismissal ?? false) {
      _navToDaylyWeather(locationTitle: locationResponse.locationTitle);
    } else {
      // app first start
      _trackLocation(locationResponse);
      _navigateToMainScreen();
    }
  }

  void onAddLocationButtonTap(
      ChooseLocationViewModelLocation locationResponse) {
    final parentRoute = ModalRoute.of(_context);
    if (parentRoute?.impliesAppBarDismissal ?? false) {
      _trackLocation(locationResponse);
    } else {
      // app first start
      _trackLocation(locationResponse);
      _navigateToMainScreen();
    }
  }

  Future<void> onTextFieldEdit({
    required String text,
  }) async {
    searchDebounce?.cancel();
    searchDebounce = Timer(const Duration(milliseconds: 1000), () async {
      text = text.trim();
      final searchQuery = text.isNotEmpty ? text : null;
      if (searchQuery != null && searchQuery.length < 3) return;
      if (searchQuery == _state.searchQuery) return;

      _state.searchQuery = searchQuery;
      _state.locationDaysList = [];
      _state._locationsList = [];
      _state.errorTitle = null;
      _state.errorDayWeatherTitle = null;
      notifyListeners();
      if (searchQuery == null) return;
      try {
        final locationList =
            await _weatherRepository.searchQueryLocations(query: searchQuery);
        _state._locationsList = _parserLocationList(locationList);
        notifyListeners();
      } on ApiClientExeption catch (e) {
        switch (e.type) {
          case ApiClientExeptionType.emptyResponse:
            _state.errorTitle = 'по вашему запросу ничего не найдено';
            notifyListeners();
            break;
          default:
            _state.errorTitle = 'неизвестная ошибка';
            notifyListeners();
            break;
        }
      }
      if (_state._locationsList.isEmpty) return;
      try {
        final forecastDaysList =
            await _weatherRepository.getTargetLocationDaysList(
                location: _state._locationsList.first.locationTitle, days: 5);
        final daysList = _parseWeatherDaysList(forecastDaysList);
        _state.locationDaysList = daysList;
        notifyListeners();
      } on ApiClientExeption catch (e) {
        switch (e.type) {
          case ApiClientExeptionType.emptyResponse:
            _state.errorDayWeatherTitle = 'не удалось загрузить прогноз';
            notifyListeners();
            break;
          default:
            _state.errorDayWeatherTitle = 'ApiClientExeption';
            notifyListeners();
            break;
        }
      } catch (e) {
        _state.errorDayWeatherTitle = 'неизвестная ошибка';
        notifyListeners();
      }
    });
  }

  List<ChooseLocationViewModelLocation> _parserLocationList(
      List<LocationResponse> listRaw) {
    final List<ChooseLocationViewModelLocation> list = listRaw.map((location) {
      final locationTitle = location.name;
      final regionTitle = location.country;
      final id = location.id.toString();
      var alreadyTracking = false;
      for (var track in _state.tracklocationsList) {
        if (track.id == location.id.toString()) {
          alreadyTracking = true;
          break;
        }
      }
      return ChooseLocationViewModelLocation(
        id: id,
        locationTitle: locationTitle,
        regionTitle: regionTitle,
        alreadyTracking: alreadyTracking,
      );
    }).toList();
    return list;
  }

  List<_Day> _parseWeatherDaysList(List<Forecastday> list) {
    List<_Day> daysList = [];
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

      final day = _Day(
        dayOfWeekTitle: dayOfWeek,
        iconPath: iconPath,
        maxTempTitle: maxnTemp,
        minTempTitle: minTemp,
      );
      daysList.add(day);
    }
    return daysList;
  }

  void _trackLocation(ChooseLocationViewModelLocation locationResponse) {
    final location = TrackingLocation(
      id: locationResponse.id,
      title: locationResponse.locationTitle,
    );
    _state.tracklocationsList =
        _weatherRepository.startTrackingLocation(location: location);
    _checkAlreadyTracking();
  }

  _checkAlreadyTracking() {
    for (var i = 0; i < _state._locationsList.length; i++) {
      var location = _state._locationsList[i];
      var alreadyTracking = false;
      for (var track in _state.tracklocationsList) {
        if (track.id == location.id) {
          alreadyTracking = true;
          break;
        }
      }
      if (alreadyTracking) {
        _state._locationsList[i] = ChooseLocationViewModelLocation(
          id: location.id,
          locationTitle: location.locationTitle,
          regionTitle: location.regionTitle,
          alreadyTracking: alreadyTracking,
        );
      }
    }
    notifyListeners();
  }

  void _navToDaylyWeather({required String locationTitle}) {
    Navigator.of(_context).pushNamed(
      MainNavigationRouteNames.weeklyWeather,
      arguments: locationTitle,
    );
  }

  void _navigateToMainScreen() {
    Navigator.of(_context).pushNamedAndRemoveUntil(
        MainNavigationRouteNames.mainScreen, (route) => false);
  }
}

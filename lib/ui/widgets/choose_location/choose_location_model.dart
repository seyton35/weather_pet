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
  List<_Day> locationDaysList;
  List<ChooseLocationViewModelLocation> locationsList;
  List<TrackingLocation> tracklocationsList;

  _ViewModelState({
    this.errorTitle,
    this.searchQuery = '',
    this.locationDaysList = const [],
    this.locationsList = const [],
    this.tracklocationsList = const [],
  });
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

  ChooseLocationViewModel(this._context) {
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
      if (searchQuery == _state.searchQuery) return;

      _state.searchQuery = searchQuery;
      _state.locationDaysList = [];
      _state.locationsList = [];
      _state.errorTitle = null;
      notifyListeners();
      if (searchQuery == null) return;
      try {
        _state.errorTitle = null;
        notifyListeners();
        final locationList =
            await _weatherRepository.searchQueryLocations(query: searchQuery);
        _state.locationsList = _parserLocationList(locationList);
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
      if (_state.locationsList.isEmpty) return;
      try {
        final forecastDaysList =
            await _weatherRepository.getTargetLocationDaysList(
                location: _state.tracklocationsList.first.title, days: 5);
        final daysList = _parseWeatherDaysList(forecastDaysList);
        _state.locationDaysList = daysList;
        notifyListeners();
      } on ApiClientExeption catch (e) {
        switch (e.type) {
          case ApiClientExeptionType.emptyResponse:
            _state.errorTitle = 'не удалось загрузить прогноз';
            notifyListeners();
            break;
          default:
            break;
        }
      } catch (e) {
        _state.errorTitle = 'неизвестная ошибка';
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
    _weatherRepository.startTrackingLocation(location: location);
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

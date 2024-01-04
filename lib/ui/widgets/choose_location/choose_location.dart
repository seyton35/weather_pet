import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:weather_pet/domain/api_clients/api_clients_exception.dart';
import 'package:weather_pet/domain/data_providers/track_location_data_provider.dart';
import 'package:weather_pet/domain/entity/location_response.dart';
import 'package:weather_pet/domain/entity/weather_response_forecast.dart';
import 'package:weather_pet/domain/repositories/weather_repository.dart';
import 'package:weather_pet/library/parsers/date_parser.dart';
import 'package:weather_pet/ui/navigation/main_navigartion.dart';
import 'package:weather_pet/ui/widgets/main_app/main_app.dart';

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

class _Location {
  final String id;
  final String locationTitle;
  final String regionTitle;
  final bool alreadyTracking;

  _Location({
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
  List<_Location> _locationsList;
  List<_Location> get locationsList => [..._locationsList];

  _ViewModelState({
    this.errorDayWeatherTitle,
    this.errorTitle,
    this.searchQuery = '',
    this.locationDaysList = const [],
    List<_Location> locationsList = const [],
  }) : _locationsList = locationsList;
}

class _ViewModel extends ChangeNotifier {
  List<TrackingLocation>? _trackLocationsList;

  final WeatherRepository _weatherRepo;
  var _state = _ViewModelState();
  _ViewModelState get state => _state;
  final BuildContext _context;
  Timer? searchDebounce;

  _ViewModel({
    required context,
    weatherRepository,
    state,
  })  : _weatherRepo = weatherRepository ?? WeatherRepository(),
        _context = context,
        _state = state ?? _ViewModelState() {
    if (weatherRepository != null) {
      _trackLocationsList = _weatherRepo.locationTrackList;
    }
  }

  _ViewModel copyWith({
    required BuildContext context,
    WeatherRepository? weatherRepository,
  }) {
    return _ViewModel(
      context: context,
      weatherRepository: weatherRepository,
      state: _state,
    );
  }

  void onCancelButtonTap() {
    final parentRoute = ModalRoute.of(_context);
    if (parentRoute?.impliesAppBarDismissal ?? false) {
      Navigator.of(_context).maybePop();
    } else {
      exit(0);
    }
  }

  void onLocationWidgetTap(_Location locationResponse) {
    final parentRoute = ModalRoute.of(_context);
    if (parentRoute?.impliesAppBarDismissal ?? false) {
      _navToDaylyWeather(locationTitle: locationResponse.locationTitle);
    } else {
      // app first start
      _trackLocation(locationResponse);
      _navigateToMainScreen();
    }
  }

  void onAddLocationButtonTap(_Location locationResponse) {
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
            await _weatherRepo.searchQueryLocations(query: searchQuery);
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
      } catch (e) {
        _state.errorTitle = '$e';
        notifyListeners();
      }
      if (_state._locationsList.isEmpty) return;
      try {
        final forecastDaysList = await _weatherRepo.getTargetLocationDaysList(
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

  List<_Location> _parserLocationList(List<LocationResponse> listRaw) {
    final List<_Location> list = listRaw.map((location) {
      final locationTitle = location.name;
      final regionTitle = location.country;
      final id = location.id.toString();
      var alreadyTracking = false;
      for (var track in _trackLocationsList!) {
        if (track.id == location.id.toString()) {
          alreadyTracking = true;
          break;
        }
      }
      return _Location(
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

  void _trackLocation(_Location locationResponse) {
    final location = TrackingLocation(
      id: locationResponse.id,
      title: locationResponse.locationTitle,
    );
    // _weatherRepo.startTrackingLocation(location: location);
    _context.read<MainAppModel>().trackLocation(location);
    _checkAlreadyTracking();
  }

  _checkAlreadyTracking() {
    for (var i = 0; i < _state._locationsList.length; i++) {
      var location = _state._locationsList[i];
      var alreadyTracking = false;
      for (var track in _trackLocationsList!) {
        if (track.id == location.id) {
          alreadyTracking = true;
          break;
        }
      }
      if (alreadyTracking) {
        _state._locationsList[i] = _Location(
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

class ChooseLocation extends StatelessWidget {
  const ChooseLocation({super.key});

  static Widget create() {
    return ChangeNotifierProxyProvider<MainAppModel, _ViewModel>(
      create: (context) => _ViewModel(context: context),
      update: (context, mainApp, chooseLocationModel) =>
          chooseLocationModel!.copyWith(
        context: context,
        weatherRepository: mainApp.weatherRepository,
      ),
      child: const ChooseLocation(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const _AppBarWidget(),
        automaticallyImplyLeading: false,
        titleSpacing: 10,
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
      ),
      body: const _BodyWidget(),
    );
  }
}

class _AppBarWidget extends StatelessWidget {
  const _AppBarWidget();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      child: const Row(
        children: [
          Expanded(
            child: Column(
              children: [
                _AppBarrSearchTextField(),
              ],
            ),
          ),
          _AppBarCancelButton(),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}

class _AppBarrSearchTextField extends StatelessWidget {
  const _AppBarrSearchTextField();

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return TextField(
      autofocus: true,
      onChanged: (text) => model.onTextFieldEdit(text: text),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[300],
        prefixIcon: const Icon(Icons.search),
        contentPadding: EdgeInsets.zero,
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(9999)),
            borderSide: BorderSide.none),
      ),
    );
  }
}

class _AppBarCancelButton extends StatelessWidget {
  const _AppBarCancelButton();

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return TextButton(
      onPressed: () => model.onCancelButtonTap(),
      child: const Text(
        'отмена',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final errorTitle = context.select((_ViewModel vm) => vm.state.errorTitle);
    if (errorTitle != null) {
      return Center(
        child: Text(
          errorTitle,
          style: const TextStyle(fontSize: 18),
        ),
      );
    }
    return ListView(children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: size.width,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FirstLocationWidget(),
            _LocationListWidget(),
          ],
        ),
      ),
    ]);
  }
}

class _FirstLocationWidget extends StatelessWidget {
  const _FirstLocationWidget();

  @override
  Widget build(BuildContext context) {
    final isListEmpty =
        context.select((_ViewModel value) => value.state.locationsList.isEmpty);
    if (isListEmpty) {
      return const SizedBox.shrink();
    }
    final location =
        context.select((_ViewModel value) => value.state.locationsList[0]);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LocationListItem(index: 0, item: location),
        const _DaysWeatherListWidget(),
      ],
    );
  }
}

class _DaysWeatherListWidget extends StatelessWidget {
  const _DaysWeatherListWidget();
  @override
  Widget build(BuildContext context) {
    final errorTitle =
        context.select((_ViewModel vm) => vm.state.errorDayWeatherTitle);
    if (errorTitle != null) return Text(errorTitle);
    final daysList =
        context.select((_ViewModel vm) => vm.state.locationDaysList);
    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: daysList
                .map((day) => Column(
                      children: [
                        Text(day.dayOfWeekTitle),
                        Image.asset(
                          (day.iconPath),
                          height: 50,
                        ),
                        Text('${day.maxTempTitle}°'),
                        Text('${day.minTempTitle}°'),
                      ],
                    ))
                .toList()),
        const SizedBox(height: 20),
        const Divider(thickness: 1),
      ],
    );
  }
}

class _LocationListWidget extends StatelessWidget {
  const _LocationListWidget();

  @override
  Widget build(BuildContext context) {
    var locationsList =
        context.select((_ViewModel vm) => vm.state.locationsList);
    final children = <Widget>[];
    for (var i = 1; i < locationsList.length; i++) {
      children.add(_LocationListItem(
        index: i,
        item: locationsList[i],
      ));
    }
    return Column(
      children: children,
    );
  }
}

class _LocationListItem extends StatelessWidget {
  final int index;
  final _Location item;
  const _LocationListItem({required this.index, required this.item});

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();

    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () => model.onLocationWidgetTap(item),
      child: Container(
        height: 88,
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: size.width / 10 * 5.5,
                  child: Text(
                    item.locationTitle,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                Text(
                  item.regionTitle,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            item.alreadyTracking
                ? _AddLocationButtonGap()
                : _AddLocationButton(location: item),
          ],
        ),
      ),
    );
  }
}

class _AddLocationButton extends StatelessWidget {
  const _AddLocationButton({
    required this.location,
  });

  final _Location location;

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return IconButton(
      onPressed: () => model.onAddLocationButtonTap(location),
      icon: const Icon(Icons.add),
      padding: EdgeInsets.zero,
    );
  }
}

class _AddLocationButtonGap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Text('Добавлено'),
        Icon(Icons.keyboard_arrow_right_outlined),
      ],
    );
  }
}

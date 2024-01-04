import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_pet/domain/api_clients/api_clients_exception.dart';
import 'package:weather_pet/domain/data_providers/track_location_data_provider.dart';
import 'package:weather_pet/domain/entity/weather_response_current.dart';
import 'package:weather_pet/domain/entity/weather_response_forecast.dart';
import 'package:weather_pet/domain/repositories/weather_repository.dart';
import 'package:weather_pet/library/parsers/weather.dart';
import 'package:weather_pet/ui/navigation/main_navigartion.dart';
import 'package:weather_pet/ui/widgets/main_app/main_app.dart';

class _HourWeather {
  final String tempTitle;
  final String windSpeedTitle;
  final String time;
  final String iconPath;

  _HourWeather({
    required this.tempTitle,
    required this.windSpeedTitle,
    required this.time,
    required this.iconPath,
  });
}

class _Weather {
  final String iconPath;
  final String tempTitle;
  final String minTempTitle;
  final String maxTempTitle;
  final List<_HourWeather> hourWeatherList;

  _Weather({
    required this.iconPath,
    required this.tempTitle,
    required this.minTempTitle,
    required this.maxTempTitle,
    required this.hourWeatherList,
  });
}

class _ViewModel extends ChangeNotifier {
  final List<TrackingLocation> _trackLocationsList;
  List<_Weather> locationsWeatherList = [];
  String locationTitle = '';
  String? locationId;

  final _date = DateTime.now();
  final BuildContext _context;
  final WeatherRepository _weatherRepo;

  _ViewModel({required context, weatherRepository, trackLocationsList})
      : _context = context,
        _weatherRepo = weatherRepository ?? WeatherRepository(),
        _trackLocationsList = trackLocationsList ?? [] {
    init();
  }

  void init() async {
    if (_trackLocationsList.isNotEmpty) {
      if (_weatherRepo.locationWeatherList.isNotEmpty) {
        locationTitle = _trackLocationsList[0].title;
        locationId = _trackLocationsList[0].id;
        locationsWeatherList = _trackLocationsParse();
        notifyListeners();
      }
    }
  }

  void setScreenTitle({required int index}) {
    locationTitle = _trackLocationsList[index].title;
    locationId = _trackLocationsList[index].id;
    notifyListeners();
  }

  void onWeeklyWeatherButtonTap() {
    Navigator.of(_context)
        .pushNamed(MainNavigationRouteNames.weeklyWeather, arguments: {
      'location_title': locationTitle,
      'location_id': locationId,
      'already_tracking': true,
    });
  }

  void onAppBarLeadingButtonTap() {
    Navigator.of(_context).pushNamed(MainNavigationRouteNames.chooseLocation);
  }

  void onSettingsButtonTap() {
    Navigator.of(_context).pushNamed(MainNavigationRouteNames.settings);
  }

  List<_Weather> _trackLocationsParse() {
    final List<_Weather> weatherList = [];
    for (var track in _trackLocationsList) {
      final locationWeatherList = _weatherRepo.locationWeatherList;
      for (var locationWeather in locationWeatherList) {
        if (track.id == locationWeather.id) {
          final currentWeather = _parser(locationWeather.weather);
          weatherList.add(currentWeather);
          continue;
        }
      }
    }
    return weatherList;
  }

  _Weather _parser(WeatherResponceCurrent weather) {
    List<_HourWeather> hourWeatherList = [];
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
        _HourWeather(
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

    final currentWeather = _Weather(
        iconPath: iconPath,
        tempTitle: tempTitle,
        minTempTitle: minTempTitle,
        maxTempTitle: maxTempTitle,
        hourWeatherList: hourWeatherList);

    return currentWeather;
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static Widget create() {
    return ChangeNotifierProxyProvider<MainAppModel, _ViewModel>(
      create: (context) => _ViewModel(
        context: context,
      ),
      update: (context, mainApp, mainScreen) => _ViewModel(
        context: context,
        weatherRepository: mainApp.weatherRepository,
        trackLocationsList: mainApp.trackList,
      ),
      child: const MainScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const _AppBarrTitleWidget(),
        leading: const _AppBarLeadingButton(),
        actions: const [_AppBarSettingsButton()],
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: const _BodyWidget(),
    );
  }
}

class _AppBarLeadingButton extends StatelessWidget {
  const _AppBarLeadingButton();

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: model.onAppBarLeadingButtonTap,
    );
  }
}

class _AppBarSettingsButton extends StatelessWidget {
  const _AppBarSettingsButton();

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return IconButton(
      onPressed: model.onSettingsButtonTap,
      icon: const Icon(Icons.settings),
    );
  }
}

class _AppBarrTitleWidget extends StatelessWidget {
  const _AppBarrTitleWidget();

  @override
  Widget build(BuildContext context) {
    final locationTitle = context.select((_ViewModel vm) => vm.locationTitle);
    return Text(locationTitle);
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget();

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    final weatherList =
        context.select((_ViewModel value) => value.locationsWeatherList);
    final size = MediaQuery.of(context).size;
    final items = weatherList
        .asMap()
        .entries
        .map((e) => _ScreenWidget(
              weather: e.value,
              index: e.key,
            ))
        .toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: CarouselSlider(
        items: items,
        options: CarouselOptions(
          enlargeCenterPage: true,
          viewportFraction: 1,
          height: size.height,
          enableInfiniteScroll: false,
          onPageChanged: (index, reason) => model.setScreenTitle(index: index),
        ),
      ),
    );
  }
}

class _ScreenWidget extends StatelessWidget {
  final int index;
  final _Weather weather;
  const _ScreenWidget({
    required this.weather,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: ListView(
        children: [
          _CurrentWeather(index: index, weather: weather),
          const _GetWeeklyWeatherButton(),
          _HourlyWeather(hourWeatherList: weather.hourWeatherList),
        ],
      ),
    );
  }
}

class _CurrentWeather extends StatelessWidget {
  final _Weather weather;
  final int index;
  const _CurrentWeather({
    required this.weather,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height / 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${weather.tempTitle}°',
            style: const TextStyle(fontSize: 90),
          ),
          Image.asset(weather.iconPath),
          Text(
            '${weather.maxTempTitle}°/${weather.minTempTitle}°',
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}

class _GetWeeklyWeatherButton extends StatelessWidget {
  const _GetWeeklyWeatherButton();

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return OutlinedButton(
      onPressed: () => model.onWeeklyWeatherButtonTap(),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 12),
        ),
        backgroundColor: MaterialStateProperty.all(Colors.grey[400]),
        side: const MaterialStatePropertyAll(BorderSide.none),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999),
          ),
        ),
      ),
      child: const Text(
        'Прогноз на 7 дней',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}

class _HourlyWeather extends StatelessWidget {
  final List<_HourWeather> hourWeatherList;
  const _HourlyWeather({
    required this.hourWeatherList,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[400],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.access_time),
              SizedBox(width: 5),
              Text(
                'прогноз на 24 ч',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: hourWeatherList.length,
              itemBuilder: (context, index) =>
                  _HourWeatherWidget(hourWeather: hourWeatherList[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class _HourWeatherWidget extends StatelessWidget {
  final _HourWeather hourWeather;
  const _HourWeatherWidget({required this.hourWeather});

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 16);
    // todo: calculate width correctly
    final width = MediaQuery.of(context).size.width / 4.5;
    return SizedBox(
      width: width,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 10),
          Text('${hourWeather.tempTitle}°',
              style: const TextStyle(fontSize: 18)),
          Image.asset(hourWeather.iconPath),
          Text('${hourWeather.windSpeedTitle} км/ч', style: textStyle),
          Text(hourWeather.time),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

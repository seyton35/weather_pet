import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_pet/features/weekly_weather/weekly_weather.dart';
import 'package:weather_repository/weather_repository.dart';

class WeeklyWeatherPage extends StatelessWidget {
  const WeeklyWeatherPage({super.key});

  static Widget create({
    required String locationTitle,
    required String locationId,
    String? lat,
    String? lon,
  }) {
    return BlocProvider(
      create: (context) => WeeklyWeatherBloc(
        locationTitle: locationTitle,
        locationId: locationId,
        lat: lat,
        lon: lon,
        weatherRepository: context.read<WeatherRepository>(),
      )..add(const WeeklyWeatherEventLoading()),
      child: const WeeklyWeatherPage(),
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
    return BlocBuilder<WeeklyWeatherBloc, WeeklyWeatherState>(
      buildWhen: (previous, current) =>
          previous.locationTitle != current.locationTitle,
      builder: (context, state) {
        return Text(state.locationTitle);
      },
    );
  }
}

class _DaylyWeather extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeeklyWeatherBloc, WeeklyWeatherState>(
      buildWhen: (previous, current) =>
          previous.locationDaylyWeatherList != current.locationDaylyWeatherList,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.locationDaylyWeatherList.length,
              itemBuilder: (context, index) => _DayWeatherWidget(
                daylyWeather: state.locationDaylyWeatherList[index],
                index: index,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DayWeatherWidget extends StatelessWidget {
  final DaylyWeather daylyWeather;
  final int index;
  const _DayWeatherWidget({required this.daylyWeather, required this.index});

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
    final weekTitle = index == 0 ? 'Сегодня' : daylyWeather.dayOfWeek;
    return Container(
        width: width,
        height: double.infinity,
        decoration: decoration,
        child: Column(
          children: [
            const SizedBox(height: 30),
            Text(weekTitle, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 10),
            Text(daylyWeather.date),
            const SizedBox(height: 20),
            Image.asset(
              (daylyWeather.dayIconPath),
              width: 50,
              height: 50,
            ),
            const SizedBox(height: 10),
            Text('${daylyWeather.maxTempTitle}°',
                style: const TextStyle(fontSize: 18)),
            const Spacer(),
            Text('${daylyWeather.minTempTitle}°',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Image.asset(
              (daylyWeather.nightIconPath),
              width: 50,
              height: 50,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Transform.rotate(
                  angle: (daylyWeather.windDegree - 90) * -3.14 / 180,
                  child: const Icon(
                    Icons.navigation,
                  ),
                ),
                Text('${daylyWeather.windSpeedTitle} км/ч', style: textStyle),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ));
  }
}

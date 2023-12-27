import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_pet/ui/widgets/weekly_weather/weekly_weather_model.dart';

class WeeklyWeather extends StatelessWidget {
  const WeeklyWeather({super.key});

  static Widget create({required String locationTitle}) {
    return ChangeNotifierProvider(
      create: (_) => WeeklyWeatherViewModel(locationTitle: locationTitle),
      lazy: false,
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
    final title =
        context.select((WeeklyWeatherViewModel vm) => vm.state.locationTitle);
    return Text(title);
  }
}

class _DaylyWeather extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final daysWeatherList =
        context.select((WeeklyWeatherViewModel vm) => vm.state.daysWeatherList);
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
  final WeeklyWeatherViewModelDay dayWeather;
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

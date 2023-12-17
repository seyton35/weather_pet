import 'package:flutter/material.dart';

class WeeklyWeather extends StatelessWidget {
  final String location;

  const WeeklyWeather({super.key, required this.location});

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
    return const Text('Прогноз на 7 дней');
  }
}

class TemperatureByDay {
  final int temp_c;
  final double wind_kph;
  final String day;
  final int cloud;

  TemperatureByDay({
    required this.temp_c,
    required this.wind_kph,
    required this.day,
    required this.cloud,
  });
}

class _DaylyWeather extends StatelessWidget {
  List<TemperatureByDay> tempHourly = [
    TemperatureByDay(
      temp_c: 1,
      cloud: 82,
      wind_kph: 8.4,
      day: '16.12',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 8,
          itemBuilder: (context, index) =>
              _DayWeatherWidget(hourWeather: tempHourly[0]),
        ),
      ),
    );
  }
}

class _DayWeatherWidget extends StatelessWidget {
  final TemperatureByDay hourWeather;
  const _DayWeatherWidget({required this.hourWeather});

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 14);
    // todo: calculate width correctly
    final width = MediaQuery.of(context).size.width / 4;
    return Container(
        width: width,
        height: double.infinity,
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(10),
        //   color: Colors.grey[200],
        // ),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text('день', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text(hourWeather.day),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud),
                Text('${hourWeather.cloud}', style: textStyle),
              ],
            ),
            const SizedBox(height: 10),
            Text('${hourWeather.temp_c}°',
                style: const TextStyle(fontSize: 18)),
            const Spacer(),
            Text('${hourWeather.temp_c}°',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud),
                Text('${hourWeather.cloud}', style: textStyle),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.navigation),
                Text('${hourWeather.wind_kph} км/ч', style: textStyle),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ));
  }
}

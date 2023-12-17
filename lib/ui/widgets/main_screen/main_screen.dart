import 'package:flutter/material.dart';
import 'package:weather_pet/domain/api_clients/weather_api_client.dart';
import 'package:weather_pet/ui/navigation/main_navigartion.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const _AppBarrTitleWidget(),
        // leading: _AppBarrLeadingButton(),
        leading: const _AppBarrLeadingButton(),
      ),
      body: const _BodyWIdget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final cur = WeatherApiClient().forecastWeather(location: 'moscow');
        },
      ),
    );
  }
}

class _AppBarrLeadingButton extends StatelessWidget {
  const _AppBarrLeadingButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () => Navigator.of(context)
          .pushNamed(MainNavigationRouteNames.locationSettings),
    );
  }
}

class _AppBarrTitleWidget extends StatelessWidget {
  const _AppBarrTitleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Text('city'),
      ],
    );
  }
}

class TemperatureByHour {
  final int temp_c;
  final double wind_kph;
  final String time;
  final int cloud;

  TemperatureByHour({
    required this.temp_c,
    required this.wind_kph,
    required this.time,
    required this.cloud,
  });
}

class _BodyWIdget extends StatelessWidget {
  const _BodyWIdget();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView(
        children: [
          const _CurrentWeather(),
          const _GetWeeklyWeatherButton(),
          _HourlyWeather(),
        ],
      ),
    );
  }
}

class _CurrentWeather extends StatelessWidget {
  const _CurrentWeather();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height / 2,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '6°',
            style: TextStyle(fontSize: 90),
          ),
          Text(
            'Облачно 8°/-3°',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            'икв 33',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}

class _GetWeeklyWeatherButton extends StatelessWidget {
  const _GetWeeklyWeatherButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => Navigator.of(context)
          .pushNamed(MainNavigationRouteNames.weeklyWeather),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 12),
        ),
        backgroundColor: MaterialStateProperty.all(Colors.grey[400]),
        side: const MaterialStatePropertyAll(BorderSide.none),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
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
  List<TemperatureByHour> tempHourly = [
    TemperatureByHour(
      temp_c: 1,
      cloud: 82,
      wind_kph: 8.4,
      time: '00:00',
    ),
  ];

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
              itemCount: 24,
              itemBuilder: (context, index) =>
                  _HourWeatherWidget(hourWeather: tempHourly[0]),
            ),
          ),
        ],
      ),
    );
  }
}

class _HourWeatherWidget extends StatelessWidget {
  final TemperatureByHour hourWeather;
  const _HourWeatherWidget({required this.hourWeather});

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 16);
    // todo: calculate width correctly
    final width = MediaQuery.of(context).size.width / 4;
    return Container(
        width: width,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 10),
            Text('${hourWeather.temp_c}°',
                style: const TextStyle(fontSize: 18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud),
                Text('${hourWeather.cloud}', style: textStyle),
              ],
            ),
            Text('${hourWeather.wind_kph} км/ч', style: textStyle),
            Text(hourWeather.time),
            const SizedBox(height: 10),
          ],
        ));
  }
}

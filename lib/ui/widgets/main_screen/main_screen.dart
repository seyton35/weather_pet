import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_pet/ui/widgets/main_screen/main_screen_model.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (context) => MainScreenViewModel(context),
      lazy: false,
      child: const MainScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const _AppBarrTitleWidget(),
        leading: const _AppBarLeadingButton(),
        backgroundColor: Colors.transparent,
        // shadowColor: Colors.transparent,
        centerTitle: true,
      ),
      body: const _BodyWIdget(),
    );
  }
}

class _AppBarLeadingButton extends StatelessWidget {
  const _AppBarLeadingButton();

  @override
  Widget build(BuildContext context) {
    final model = context.read<MainScreenViewModel>();
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () => model.onAppBarLeadingButtonTap(),
    );
  }
}

class _AppBarrTitleWidget extends StatelessWidget {
  const _AppBarrTitleWidget();

  @override
  Widget build(BuildContext context) {
    final locationTitle =
        context.select((MainScreenViewModel vm) => vm.state.screenTitle);
    return Text(locationTitle);
  }
}

class _BodyWIdget extends StatelessWidget {
  const _BodyWIdget();

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MainScreenViewModel>();
    final weatherList = model.state.locationsWeatherList;
    final size = MediaQuery.of(context).size;
    final items = weatherList
        .map((weather) => _ScreenWidget(
              weather: weather,
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
  final MainScreenWeather weather;
  const _ScreenWidget({
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView(
        children: [
          _CurrentWeather(weather: weather),
          const _GetWeeklyWeatherButton(),
          _HourlyWeather(hourWeatherList: weather.hourWeatherList),
        ],
      ),
    );
  }
}

class _CurrentWeather extends StatelessWidget {
  final MainScreenWeather weather;
  const _CurrentWeather({
    required this.weather,
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
    final model = context.read<MainScreenViewModel>();
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
  final List<MainScreenHourWeather> hourWeatherList;
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
  final MainScreenHourWeather hourWeather;
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

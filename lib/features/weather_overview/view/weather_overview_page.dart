import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_pet/features/weather_overview/weather_overview.dart';
import 'package:weather_repository/weather_repository.dart' hide CurrentWeather;

class WeatherOverview extends StatelessWidget {
  const WeatherOverview({super.key});

  static Widget create() {
    return BlocProvider(
      create: (context) => WeatherOverviewBloc(
        context: context,
        weatherRepository: context.read<WeatherRepository>(),
      )..add(const WeatherOverviewEventSubscription()),
      child: const WeatherOverview(),
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
      body: BlocBuilder<WeatherOverviewBloc, WeatherOverviewState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          switch (state.status) {
            case WeatherOverviewStatus.initial:
              return const SizedBox.shrink();
            case WeatherOverviewStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case WeatherOverviewStatus.success:
              return const _BodyWidget();
            case WeatherOverviewStatus.error:
            default:
              return Center(child: Text(state.errorTitle));
          }
        },
      ),
    );
  }
}

class _AppBarLeadingButton extends StatelessWidget {
  const _AppBarLeadingButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () => context
          .read<WeatherOverviewBloc>()
          .add(const WeatherOverviewEventAddLocationButtonTap()),
    );
  }
}

class _AppBarSettingsButton extends StatelessWidget {
  const _AppBarSettingsButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => context
          .read<WeatherOverviewBloc>()
          .add(const WeatherOverviewEventSettingsButtonTap()),
      icon: const Icon(Icons.settings),
    );
  }
}

class _AppBarrTitleWidget extends StatelessWidget {
  const _AppBarrTitleWidget();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherOverviewBloc, WeatherOverviewState>(
        buildWhen: (previous, current) =>
            previous.locationTitle != current.locationTitle,
        builder: (context, state) => Text(state.locationTitle));
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: BlocBuilder<WeatherOverviewBloc, WeatherOverviewState>(
          buildWhen: (previous, current) =>
              previous.weatherList != current.weatherList,
          builder: (context, state) => CarouselSlider.builder(
            itemCount: state.weatherList.length,
            itemBuilder: (context, index, realIndex) => _ScreenWidget(
              weather: state.weatherList[index],
              index: index,
            ),
            options: CarouselOptions(
              enlargeCenterPage: true,
              viewportFraction: 1,
              height: size.height,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) => context
                  .read<WeatherOverviewBloc>()
                  .add(WeatherOverviewEventTitleChange(index: index)),
            ),
          ),
        ));
  }
}

class _ScreenWidget extends StatelessWidget {
  final int index;
  final Weather weather;
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
          _WeeklyWeatherButton(
            locationId: weather.id,
            locationTitle: weather.lcoationTitle,
          ),
          _HourlyWeather(hourWeatherList: weather.hourWeatherList),
        ],
      ),
    );
  }
}

class _CurrentWeather extends StatelessWidget {
  final Weather weather;
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
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Image.asset(weather.iconPath),
          Text(
            '${weather.maxTempTitle}°/${weather.minTempTitle}°',
          ),
        ],
      ),
    );
  }
}

class _WeeklyWeatherButton extends StatelessWidget {
  final String locationId;
  final String locationTitle;
  const _WeeklyWeatherButton({
    required this.locationId,
    required this.locationTitle,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => context
          .read<WeatherOverviewBloc>()
          .add(WeatherOverviewEventWeeklyWeatherButtonTap(
            locationId: locationId,
            locationTitle: locationTitle,
          )),
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
  final List<HourlyWeather> hourWeatherList;
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
          Row(
            children: [
              const Icon(Icons.access_time),
              const SizedBox(width: 5),
              Text(
                'прогноз на 24 ч',
                style: Theme.of(context).textTheme.bodyMedium,
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
  final HourlyWeather hourWeather;
  const _HourWeatherWidget({required this.hourWeather});

  @override
  Widget build(BuildContext context) {
    // todo: calculate width correctly
    final width = MediaQuery.of(context).size.width / 4.5;
    return SizedBox(
      width: width,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 10),
          Text('${hourWeather.tempTitle}°'),
          Image.asset(hourWeather.iconPath),
          Text(
            '${hourWeather.windSpeedTitle} км/ч',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(hourWeather.time),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

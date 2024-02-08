import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_storage_tracking_locations_api/local_storage_tracking_locations_api.dart';
import 'package:weather_pet/domain/observer/weather_observer.dart';
import 'package:weather_repository/weather_repository.dart';

import 'package:weather_pet/features/main_app/main_app.dart';

void main() async {
  Bloc.observer = WeatherBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  final trackLocationsApi =
      TrackLocationDataProvider(plugin: await SharedPreferences.getInstance());
  final weatherApiClient = WeatherApiClient();
  final weatherRepository = WeatherRepository(
    trackLocationApi: trackLocationsApi,
    weatherApiClient: weatherApiClient,
  );
  final trackingLocations = await weatherRepository.trackingLocations.first;
  final app = RepositoryProvider.value(
    value: weatherRepository,
    child: MainApp(
      hasLocationsToShow: trackingLocations.isNotEmpty,
    ),
  );

  runApp(app);
}

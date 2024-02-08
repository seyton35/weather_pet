import 'package:flutter/material.dart';

import 'package:weather_pet/features/choose_location/choose_location.dart';
import 'package:weather_pet/features/locations_settings/view/view.dart';
// import 'package:weather_pet/features/settings/settings.dart';
import 'package:weather_pet/features/weather_overview/weather_overview.dart';
import 'package:weather_pet/features/weekly_weather/weekly_weather.dart';

abstract class MainNavigationRouteNames {
  // static const loader = '/loader';
  static const weatherOverview = '/weather_overview';
  static const weeklyWeather = '/weekly_weather';
  static const locationSettings = '/location_settings';
  static const chooseLocation = '/choose_location';
  static const settings = '/settings';
}

class MainNavigation {
  String initialRoute({required bool hasLocationsToShow}) => hasLocationsToShow
      ? MainNavigationRouteNames.weatherOverview
      : MainNavigationRouteNames.chooseLocation;

  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.weatherOverview: (context) =>
        WeatherOverview.create(),
    // MainNavigationRouteNames.chooseLocation: (context) =>
    //     ChooseLocation.create()
    MainNavigationRouteNames.locationSettings: (context) =>
        LocationSettingsPage.create(),
    // MainNavigationRouteNames.settings: (context) => SettingsPage.create(),
  };
  Route<Object> onGeneratedRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.weeklyWeather:
        final arguments = settings.arguments as Map<String, dynamic>;

        final locationTitle = arguments['location_title'] as String;
        final locationId = arguments['location_id'] as String;
        final lat = arguments['lat'] as String?;
        final lon = arguments['lon'] as String?;

        return MaterialPageRoute(
          builder: (context) => WeeklyWeatherPage.create(
            locationTitle: locationTitle,
            locationId: locationId,
            lat: lat,
            lon: lon,
          ),
        );
      case MainNavigationRouteNames.chooseLocation:
        return MaterialPageRoute(
          builder: (context) => ChooseLocation.create(
            isRootRoute: settings.arguments as bool? ?? true,
          ),
        );
      default:
        const widget = Text('Navigation Error!');
        return MaterialPageRoute(builder: (context) => widget);
    }
  }
}

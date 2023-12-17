import 'package:flutter/material.dart';
import 'package:weather_pet/ui/widgets/choose_location/choose_location.dart';
import 'package:weather_pet/ui/widgets/locations_settings/locations_settings.dart';
import 'package:weather_pet/ui/widgets/main_screen/main_screen.dart';
import 'package:weather_pet/ui/widgets/weekly_weather/weekly_weather.dart';

abstract class MainNavigationRouteNames {
  static const mainScreen = '/main_screen';
  static const weeklyWeather = '/weekly_weather';
  static const locationSettings = '/location_settings';
  static const chooseLocation = '/choose_location';
}

class MainNavigation {
  String initialRoute(bool isLocationSeted) => isLocationSeted
      ? MainNavigationRouteNames.mainScreen
      : MainNavigationRouteNames.chooseLocation;
  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.mainScreen: (context) => const MainScreen(),
    MainNavigationRouteNames.locationSettings: (context) =>
        const LocationSettings(),
    MainNavigationRouteNames.chooseLocation: (context) =>
        const ChooseLocation(),
  };
  Route<Object> onGeneratedRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.weeklyWeather:
        final arguments = settings.arguments;
        final location = arguments is String ? arguments : '';
        return MaterialPageRoute(
            builder: (context) => WeeklyWeather(location: location));
      default:
        const widget = Text('Navigation Error!');
        return MaterialPageRoute(builder: (context) => widget);
    }
  }
}

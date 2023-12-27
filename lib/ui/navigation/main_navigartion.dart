import 'package:flutter/material.dart';
import 'package:weather_pet/ui/widgets/choose_location/choose_location.dart';
import 'package:weather_pet/ui/widgets/loader/loader.dart';
import 'package:weather_pet/ui/widgets/locations_settings/locations_settings.dart';
import 'package:weather_pet/ui/widgets/main_screen/main_screen.dart';
import 'package:weather_pet/ui/widgets/weekly_weather/weekly_weather.dart';

abstract class MainNavigationRouteNames {
  static const loader = '/loader';
  static const mainScreen = '/main_screen';
  static const weeklyWeather = '/weekly_weather';
  static const locationSettings = '/location_settings';
  static const chooseLocation = '/choose_location';
}

class MainNavigation {
  String initialRoute() => MainNavigationRouteNames.loader;

  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.mainScreen: (context) => MainScreen.create(),
    MainNavigationRouteNames.locationSettings: (context) =>
        const LocationSettings(),
    MainNavigationRouteNames.chooseLocation: (context) =>
        ChooseLocation.create(),
    MainNavigationRouteNames.loader: (context) => Loader.create()
  };
  Route<Object> onGeneratedRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.weeklyWeather:
        final arguments = settings.arguments;
        final locationTitle = arguments is String ? arguments : '';
        return MaterialPageRoute(
            builder: (context) =>
                WeeklyWeather.create(locationTitle: locationTitle));
      default:
        const widget = Text('Navigation Error!');
        return MaterialPageRoute(builder: (context) => widget);
    }
  }
}

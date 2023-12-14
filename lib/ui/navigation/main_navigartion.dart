import 'package:flutter/material.dart';
import 'package:weather_pet/ui/widgets/choose_location/choose_location.dart';
import 'package:weather_pet/ui/widgets/location_preview/location_preview.dart';
import 'package:weather_pet/ui/widgets/locations_settings/locations_settings.dart';
import 'package:weather_pet/ui/widgets/main_screen/main_screen.dart';

abstract class MainNavigationRouteNames {
  static const mainScreen = '/';
  static const locationSettings = '/location_settings';
  static const chooseLocation = '/location_settings/choose_location';
  static const locationPreview = '/location_settings/choose_location/preview';
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
        const ChooseLocatrion(),
  };
  Route<Object> onGeneratedRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.locationPreview:
        final arguments = settings.arguments;
        final location = arguments is String ? arguments : '';
        return MaterialPageRoute(builder: (context) => LocationPreview());
      default:
        const widget = Text('Navigation Error!');
        return MaterialPageRoute(builder: (context) => widget);
    }
  }
}

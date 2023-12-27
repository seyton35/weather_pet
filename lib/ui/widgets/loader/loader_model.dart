import 'package:flutter/material.dart';
import 'package:weather_pet/domain/repositories/weather_repository.dart';
import 'package:weather_pet/ui/navigation/main_navigartion.dart';

class LoaderViewModel {
  BuildContext context;
  final _weatherRepository = WeatherRepository();

  LoaderViewModel(this.context) {
    init();
  }

  void init() async {
    final hasLocationToShow = await _weatherRepository.hasStoredLocations();
    if (hasLocationToShow) {
      navigateToMainScreen();
    } else {
      navigateToChooseLocation();
    }
  }

  void navigateToChooseLocation() {
    Navigator.of(context).pushNamedAndRemoveUntil(
        MainNavigationRouteNames.chooseLocation, (route) => false);
  }

  void navigateToMainScreen() {
    Navigator.of(context).pushNamedAndRemoveUntil(
        MainNavigationRouteNames.mainScreen, (route) => false);
  }
}

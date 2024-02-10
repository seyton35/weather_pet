import 'package:flutter/material.dart';
import 'package:weather_pet/domain/navigation/main_navigartion.dart';
import 'package:weather_pet/domain/theme/theme.dart';

class MainApp extends StatefulWidget {
  static final mainNavigation = MainNavigation();
  final bool hasLocationsToShow;
  const MainApp({
    required this.hasLocationsToShow,
    super.key,
  });

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      theme: lightTheme,
      initialRoute: MainApp.mainNavigation
          .initialRoute(hasLocationsToShow: widget.hasLocationsToShow),
      routes: MainApp.mainNavigation.routes,
      onGenerateRoute: MainApp.mainNavigation.onGeneratedRoute,
    );
  }
}

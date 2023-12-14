import 'package:flutter/material.dart';
import 'package:weather_pet/ui/navigation/main_navigartion.dart';

class MainApp extends StatelessWidget {
  static final mainNavigation = MainNavigation();
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      initialRoute: mainNavigation.initialRoute(false),
      routes: mainNavigation.routes,
      onGenerateRoute: mainNavigation.onGeneratedRoute,
    );
  }
}

import 'package:flutter/material.dart';

const TextTheme textTheme = TextTheme(
  bodyLarge: TextStyle(fontSize: 90),
  bodyMedium: TextStyle(fontSize: 18), //default textStyle
  bodySmall: TextStyle(fontSize: 16),
  titleSmall: TextStyle(fontSize: 14),
  labelLarge: TextStyle(fontSize: 25),
  labelMedium: TextStyle(fontSize: 20),
  displaySmall: TextStyle(fontSize: 18),
  headlineSmall: TextStyle(fontSize: 18),
);

final lightTheme = ThemeData(
  primaryColor: Colors.amber,
  textTheme: textTheme,
  primaryTextTheme: textTheme,
);

import 'package:flutter/material.dart';

const kBorderRadius = 6.0;
const kHorizontalPadding = 14.0;
const kVerticalPadding = 10.0;
const kChartLeftSpace = 40.0;
const kChartBottomSpace = 30.0;

const kBackgroundColorLight = Colors.white;
const kBackgroundColorDark = Color.fromARGB(255, 16, 20, 24);

final appThemeLight = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: Colors.blue.shade400,
  primaryColorLight: Colors.blue.shade200,
  primaryColorDark: const Color.fromARGB(255, 20, 93, 167),
  scaffoldBackgroundColor: kBackgroundColorLight,
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: Colors.blue.shade400,
    onPrimary: Colors.white,
    secondary: Colors.blue.shade700,
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    surface: kBackgroundColorLight,
    onSurface: Colors.black,
  ),
);

final appThemeDark = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: Colors.blue.shade400,
  primaryColorLight: Colors.blue.shade200,
  primaryColorDark: const Color.fromARGB(255, 20, 93, 167),
  scaffoldBackgroundColor: kBackgroundColorDark,
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: Colors.blue.shade400,
    onPrimary: Colors.white,
    secondary: Colors.blue.shade700,
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    surface: kBackgroundColorDark,
    onSurface: Colors.white,
  ),
);

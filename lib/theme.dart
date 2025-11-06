import 'package:flutter/material.dart';

ThemeData _themeData = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  useMaterial3: true,
  bottomAppBarTheme: BottomAppBarThemeData(color: Colors.white, elevation: 0),
);

get appTheme => _themeData;

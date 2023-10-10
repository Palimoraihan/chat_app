import 'package:flutter/material.dart';

import '../colors.dart';

ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    appBarTheme: const AppBarTheme(color:  appBarColor,iconTheme: IconThemeData(color: Colors.grey)),
    colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: tabColor,
        onPrimary: tabColor,
        secondary: messageColor,
        onSecondary: messageColor,
        error: Colors.red,
        onError: Colors.red,
        background: backgroundColor,
        onBackground: backgroundColor,
        surface: messageColor,
        onSurface: Colors.white));

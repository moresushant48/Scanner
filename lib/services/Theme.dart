import 'package:theme_provider/theme_provider.dart';
import 'package:flutter/material.dart';

class ThemeService {
  static String THEME_LIGHT = "default_light_theme";
  static String THEME_DARK = "default_dark_theme";

  void switchTheme(BuildContext context, bool isNightMode) {
    isNightMode
        ? ThemeProvider.controllerOf(context).setTheme("default_dark_theme")
        : ThemeProvider.controllerOf(context).setTheme("default_light_theme");
  }
}

final themeService = ThemeService();

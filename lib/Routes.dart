import 'package:flutter/material.dart';
import 'package:scanner/pages/AboutPage.dart';
import 'package:scanner/pages/HomePage.dart';
import 'package:scanner/pages/SettingsPage.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            settings: settings, builder: (_) => HomePage());
      case '/Settings':
        return MaterialPageRoute(
            settings: settings, builder: (_) => SettingsPage());
      case '/About':
        return MaterialPageRoute(
            settings: settings, builder: (_) => AboutPage());
      default:
        return MaterialPageRoute(
            settings: settings, builder: (_) => HomePage());
    }
  }
}

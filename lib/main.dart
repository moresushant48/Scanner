import 'package:flutter/material.dart';
import 'package:scanner/Routes.dart';
import 'package:scanner/services/Theme.dart';
import 'package:theme_provider/theme_provider.dart';

void main() {
  runApp(Index());
}

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      child: ThemeConsumer(
        child: Builder(
          builder: (themeContext) => MaterialApp(
            theme: ThemeProvider.themeOf(themeContext).data,
            initialRoute: "/",
            onGenerateRoute: Routes.generateRoute,
          ),
        ),
      ),
    );
  }
}

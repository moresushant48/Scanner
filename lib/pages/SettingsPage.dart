import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final _horizontalPadding = 18.0;

    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: ListView(
          children: [
            ListTile(
              contentPadding: EdgeInsets.all(_horizontalPadding),
              isThreeLine: true,
              leading: FaIcon(
                FontAwesomeIcons.google,
                color: Colors.green,
              ),
              title: Text("Sign In with Google ?"),
              subtitle: Text("Connect to Google Account & Save docs on Drive."),
            ),

            //
            SizedBox(
              height: 4.0,
            ),
            //

            Padding(
              padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
              child: Text(
                "Security",
                style: TextStyle(
                    color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
            ),

            ListTile(
              contentPadding: EdgeInsets.all(_horizontalPadding),
              leading: FaIcon(
                FontAwesomeIcons.fingerprint,
                color: Colors.indigo,
              ),
              title: Text("Use Fingerprint"),
            ),
          ],
        ));
  }
}

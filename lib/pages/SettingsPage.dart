import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scanner/services/Auth.dart';
import 'package:scanner/services/Prefs.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _size = 18.0;

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(
        children: [
          StatefulBuilder(
            builder: (context, setState) {
              return FutureBuilder(
                future: authService.signIn(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.data.displayName != null)
                    return Card(
                      margin: EdgeInsets.all(_size),
                      child: Container(
                        padding: EdgeInsets.all(_size),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            ClipPath(
                              clipper: OvalBottomBorderClipper(),
                              child: Image(
                                fit: BoxFit.cover,
                                image: NetworkImage(snapshot.data.photoUrl),
                                height: 100.0,
                                width: 100.0,
                              ),
                            ),
                            //
                            SizedBox(
                              height: 14.0,
                            ),
                            //
                            Text(
                              snapshot.data.displayName,
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            //
                            SizedBox(
                              height: 10.0,
                            ),
                            //
                            Text(
                              snapshot.data.email,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal),
                            )
                          ],
                        ),
                      ),
                    );
                  else
                    return ListTile(
                      contentPadding: EdgeInsets.all(_size),
                      isThreeLine: true,
                      leading: FaIcon(
                        FontAwesomeIcons.google,
                        color: Colors.green,
                      ),
                      title: Text("Sign In with Google ?"),
                      subtitle: Text(
                          "Connect to Google Account & Save docs on Drive."),
                    );
                },
              );
            },
          ),
          //

          StatefulBuilder(
            builder: (context, setState) => Column(
              children: [
                SizedBox(
                  height: 4.0,
                ),
                //
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: _size),
                  child: Text(
                    "Security",
                    style: TextStyle(
                        color: Colors.redAccent, fontWeight: FontWeight.bold),
                  ),
                ),
                // fingerprint
                FutureBuilder(
                  future: prefService.getSharedBool("isFpOn"),
                  builder: (context, snapshot) => SwitchListTile(
                    title: Text("Use Fingerprint"),
                    secondary: FaIcon(
                      FontAwesomeIcons.fingerprint,
                      color: Colors.indigo,
                    ),
                    value: snapshot.data,
                    onChanged: (value) {
                      setState(() {
                        prefService.putSharedBool("isFpOn", value);
                      });
                    },
                  ),
                ),

                //
                SizedBox(
                  height: 4.0,
                ),
                //
                Text(
                  "Theme",
                  style: TextStyle(
                      color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),

                FutureBuilder(
                  future: prefService.getSharedBool("isNightMode") ?? false,
                  builder: (context, snapshot) => SwitchListTile(
                    title: Text("Dark/Night Mode"),
                    secondary: FaIcon(
                      FontAwesomeIcons.solidMoon,
                      color: Colors.indigo,
                    ),
                    value: snapshot.data,
                    onChanged: (value) {
                      setState(() {
                        prefService.putSharedBool("isNightMode", value);
                      });
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

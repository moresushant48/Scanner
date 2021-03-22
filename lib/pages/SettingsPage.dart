import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scanner/services/Auth.dart';
import 'package:scanner/services/Prefs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:scanner/services/Theme.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isSignedIn;
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
        elevation: 0.0,
      ),
      body: ListView(
        padding: EdgeInsets.all(_size),
        children: [
          Card(
            child: FutureBuilder(
              future: authService.getCurrentUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  print("IsLoggedIn : " + authService.isLoggedIn.toString());
                  if (snapshot.data != null)
                    return Column(
                      children: [
                        SizedBox(
                          height: _size,
                        ),
                        ClipPath(
                          clipper: OvalBottomBorderClipper(),
                          child: CachedNetworkImage(
                            height: 100,
                            width: 100,
                            imageUrl: snapshot.data.photoUrl,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    LinearProgressIndicator(
                                        value: downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
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
                        ),

                        SizedBox(
                          height: _size,
                        )
                      ],
                    );
                  else
                    return Container(
                      padding: EdgeInsets.all(_size),
                      child: Column(
                        children: [
                          //
                          ListTile(
                            isThreeLine: true,
                            leading: FaIcon(
                              FontAwesomeIcons.google,
                              color: Colors.green,
                            ),
                            title: Text("Sign In with Google ?"),
                            subtitle: Text(
                                "Connect to Google Account & Save docs on Drive."),
                          ),
                          //
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              child: Text("Sign In"),
                              onPressed: () async {
                                GoogleSignInAccount account =
                                    await authService.signIn();
                                if (account != null) setState(() {});
                              },
                            ),
                          )
                        ],
                      ),
                    );
                } else
                  return LinearProgressIndicator();
              },
            ),
          ),

          SizedBox(height: _size),

          //
          StatefulBuilder(
            builder: (context, setState) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  future: prefService.getSharedBool(PrefService.IS_FP_ON),
                  builder: (context, snapshot) => SwitchListTile(
                    title: Text("Use Fingerprint"),
                    secondary: FaIcon(
                      FontAwesomeIcons.fingerprint,
                      color: Colors.indigo,
                    ),
                    value: snapshot.data,
                    onChanged: (value) {
                      setState(() {
                        prefService.putSharedBool(PrefService.IS_FP_ON, value);
                      });
                    },
                  ),
                ),

                //
                SizedBox(
                  height: _size,
                ),
                //
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: _size),
                  child: Text(
                    "Theme",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.redAccent, fontWeight: FontWeight.bold),
                  ),
                ),

                FutureBuilder(
                  future:
                      prefService.getSharedBool(PrefService.IS_NIGHT_MODE) ??
                          false,
                  builder: (ctx, snapshot) => SwitchListTile(
                    title: Text("Dark/Night Mode"),
                    secondary: FaIcon(
                      FontAwesomeIcons.solidMoon,
                      color: Colors.indigo,
                    ),
                    value: snapshot.data,
                    onChanged: (value) {
                      setState(() {
                        prefService.putSharedBool(
                            PrefService.IS_NIGHT_MODE, value);
                        themeService.switchTheme(context, value);
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

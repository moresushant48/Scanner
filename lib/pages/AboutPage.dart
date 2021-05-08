import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:one_context/one_context.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  LiquidController liquidController;
  final pages = [
    Card(
      elevation: 0.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage("assets/icon/icon.png"),
            height: 200,
            width: 200,
          ),
          SizedBox(
            height: 12.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: Text(
              "BRAINY VISION",
              style: GoogleFonts.bitter(
                  textStyle: TextStyle(fontSize: 22.0, letterSpacing: 4.0)),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Opacity(
              opacity: 0.6,
              child: Text(
                "Brainy Vision is an idea of introducing Easy & Convinient Document Access. Capture Documents, Make PDFs, Share & Access them Online on our Web Platform too.",
                style: GoogleFonts.bitter(
                    textStyle: TextStyle(
                  fontSize: 16.0,
                )),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    ),
    Card(
      elevation: 0.0,
      child: Column(
        children: [
          ClipPath(
            clipper: WaveClipperTwo(),
            child: Image.asset("assets/images/sushant.png"),
          ),
          Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sushant More",
                    style: GoogleFonts.bitter(
                        textStyle: TextStyle(fontSize: 30.0)),
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    "Developer",
                    style: GoogleFonts.bitter(fontSize: 16),
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  Opacity(
                    opacity: 0.5,
                    child: Text(
                      "@moresushant48",
                      style: GoogleFonts.bitter(),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  FaIcon(
                    FontAwesomeIcons.github,
                    size: 28.0,
                  ),
                ],
              ))
        ],
      ),
    ),
    Card(
      elevation: 0.0,
      child: Column(
        children: [
          ClipPath(
            clipper: WaveClipperTwo(),
            child: Image.asset("assets/images/neha.jpg"),
          ),
          Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Neha Gadodia",
                    style: GoogleFonts.bitter(
                        textStyle: TextStyle(fontSize: 30.0)),
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    "Designer",
                    style: GoogleFonts.bitter(fontSize: 16),
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  Opacity(
                    opacity: 0.5,
                    child: Text(
                      "@neha.gadodia99",
                      style: GoogleFonts.bitter(),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  FaIcon(
                    FontAwesomeIcons.github,
                    size: 28.0,
                  ),
                ],
              ))
        ],
      ),
    )
  ];
  var titleVal = 0;
  var _title = ["ABOUT", "TEAM", "TEAM"];

  @override
  void initState() {
    liquidController = LiquidController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Text(_title[titleVal],
                  style: GoogleFonts.bitter(fontSize: 22)),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Card(
                elevation: 30.0,
                child: Container(
                  height: OneContext.instance.mediaQuery.size.height - 150,
                  child: LiquidSwipe(
                    liquidController: liquidController,
                    pages: pages,
                    positionSlideIcon: 0.95,
                    slideIconWidget: Icon(Icons.arrow_back_ios),
                    waveType: WaveType.liquidReveal,
                    ignoreUserGestureWhileAnimating: true,
                    onPageChangeCallback: (val) {
                      titleVal = val;
                      setState(() {});
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*
    HOME SLIDE
  */

  /*
    SUSHANT SLIDE
  */

  /*
    NEHA SLIDE
  */
}

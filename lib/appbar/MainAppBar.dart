import 'package:flutter/material.dart';

AppBar mainAppBar(BuildContext context, String appBarTitle) {
  List<String> choices = [];
  choices.add("Settings");
  return AppBar(
    title: Text(appBarTitle != null ? appBarTitle : "Brainy Vision"),
    centerTitle: true,
    elevation: 0.0,
    actions: [
      PopupMenuButton<String>(
        onSelected: (value) {
          Navigator.pushNamed(context, value);
        },
        itemBuilder: (context) {
          return choices.map((String choice) {
            print("Path : /" + choice);
            return PopupMenuItem<String>(
              child: Text(choice),
              value: "/" + choice,
            );
          }).toList();
        },
      )
    ],
  );
}

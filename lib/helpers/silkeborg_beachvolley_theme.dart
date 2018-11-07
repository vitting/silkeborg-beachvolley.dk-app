import 'package:flutter/material.dart';

class SilkeborgBeachvolleyTheme {
  static Color headerBackground = Color(0xffaaacb5);
  static Color blueBlack = Color.fromARGB(255, 7, 15, 21);
  static Color gold = Color.fromRGBO(212, 175, 5, 1.0);
  static Color silver = Color.fromRGBO(192, 192, 192, 1.0);
  static Color bronze = Color.fromRGBO(205, 127, 50, 1.0);
  static Color drawerIconColor = Colors.blue[700];
  static Color buttonTextColor = Colors.deepOrange[700];
  static Color buttonDisabledTextColor = Colors.deepOrange[200];
  static BoxDecoration gradientColorBoxDecoration = BoxDecoration(
      gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.1, 0.5, 0.7, 0.9],
    colors: [
      Colors.blue[300],
      Colors.blue[500],
      Colors.blue[700],
      Colors.blue[900],
    ],
  ));
  static BoxDecoration gradientColorBoxDecorationDarkBlue2Step = BoxDecoration(
      gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.1, 0.9],
    colors: [
      // Colors.blue[800],
      Colors.blue[900],
      Colors.black
    ],
  ));
  static String scoreboardFont = "Scoreboard";
}

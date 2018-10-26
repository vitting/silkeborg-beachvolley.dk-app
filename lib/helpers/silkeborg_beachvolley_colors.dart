import 'package:flutter/material.dart';

class SilkeborgBeachvolleyColors {
  static Color headerBackground = Color(0xffaaacb5);
  static Color blueBlack = Color.fromARGB(255, 7, 15, 21);
  static Color gold = Color.fromRGBO(212, 175, 5, 1.0);
  static Color silver = Color.fromRGBO(192, 192, 192, 1.0);
  static Color bronze = Color.fromRGBO(205, 127, 50, 1.0);
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
}

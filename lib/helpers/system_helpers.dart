import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screen/screen.dart';
import 'package:silkeborgbeachvolley/main_inheretedwidget.dart';

class SystemHelpers {
  static void hideKeyboardWithNoFocus(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static Future<dynamic> hideKeyboardWithFocus() {
    return SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  static Future<void> setScreenOn() async {
    bool isScreenOn = await Screen.isKeptOn;
    if (isScreenOn == false) {
      Screen.keepOn(true);
    }
  }

  static Future<void> setScreenOff() async {
    bool isScreenOn = await Screen.isKeptOn;

    if (isScreenOn == true) {
      Screen.keepOn(false);
    }
  }

  static Future<Null> showNavigationButtons(bool show) {
    if (show) {
      return SystemChrome.setEnabledSystemUIOverlays(
          [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    } else {
      return SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    }
  }

  static Future<Map<String, dynamic>> getConfig(BuildContext context) async {
    
    Map<String, dynamic> config;
    try {
      String data = "";
      switch (MainInherited.of(context).modeProfile) {
        case SystemMode.debug:
          data = await DefaultAssetBundle.of(context).loadString("assets/files/config_debug.json");          
          break;
        case SystemMode.release:
          data = await DefaultAssetBundle.of(context).loadString("assets/files/config_release.json");          
          break;
      }

      config = json.decode(data);
    } catch (e) {
      print(e);
    }

    return config;
  }
}

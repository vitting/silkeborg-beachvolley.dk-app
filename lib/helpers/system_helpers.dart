import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screen/screen.dart';

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
}

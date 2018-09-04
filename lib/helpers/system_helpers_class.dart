import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SystemHelpers {
  static hideKeyboardWithNoFocus(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static hideKeyboardWithFocus() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
}
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class BulletinSharedPref {
  static const String _dateCheckKey = "bulletins_checked";
  static SharedPreferences _prefs;
  
  static Future<SharedPreferences> get sharedPrefInstance async {
    if (_prefs != null) return _prefs;

    _prefs = await SharedPreferences.getInstance();
    
    return _prefs;
  }

  static void setLastCheckedDateInMilliSeconds(int dateInMilliSeconds) async {
    SharedPreferences prefs = await sharedPrefInstance;
    prefs.setInt(_dateCheckKey, dateInMilliSeconds);
  }

  static Future<int> getLastCheckedDateInMilliSeconds() async {
    SharedPreferences prefs = await sharedPrefInstance;
    return prefs.getInt(_dateCheckKey);
  } 
}
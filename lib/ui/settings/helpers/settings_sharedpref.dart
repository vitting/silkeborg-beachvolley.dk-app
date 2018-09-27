// import 'dart:async';
// import 'dart:convert';

// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
// import 'package:silkeborgbeachvolley/ui/settings/helpers/settings_data_class.dart';

// class SettingsSharedPref {
//   static SharedPreferences _prefs;
//   static String _userId = Home.loggedInUser.uid;
//   static String _key = "${_userId}_settings"; 
//   static Future<SharedPreferences> get sharedPrefInstance async {
//     if (_prefs != null) return _prefs;

//     _prefs = await SharedPreferences.getInstance();
    
//     return _prefs;
//   }

//   static void setSettings(SettingsData settingsData) async {
//     SharedPreferences prefs = await sharedPrefInstance;
//     String data = json.encode(settingsData.toJson());
//     prefs.setString(_key, data);
//   }

//   static Future<SettingsData> getSettings() async {
//     SettingsData settingsData = SettingsData();
//     SharedPreferences prefs = await sharedPrefInstance;
//     String jsonobj = prefs.getString(_key);
    
//     if (jsonobj != null) {
//       Map<String, dynamic> data = json.decode(jsonobj);
//       settingsData = SettingsData.fromJson(data);
//     }
    
//     return settingsData;
//   }
// }
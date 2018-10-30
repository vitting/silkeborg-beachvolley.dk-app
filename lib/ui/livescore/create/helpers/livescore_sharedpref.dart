import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class LivescoreSharedPref {
  static const String _livescoreKey = "livescore_names";
  static SharedPreferences _sharedPref;

  static Future<SharedPreferences> get sharedPrefInstance async {
    if (_sharedPref == null) {
      _sharedPref = await SharedPreferences.getInstance();
    }

    return _sharedPref;
  }

  static Future<bool> setPlayerNames(List<String> names) async {
    List<String> tempNames = [];
    SharedPreferences shared = await sharedPrefInstance;
    if (names != null && names.length != 0) {
      List<String> storedNames = await getPlayerNames();
      if (storedNames != null && storedNames.length != 0) {
        names.forEach((String name) {
          if (name != null && !storedNames.contains(name)) {
            tempNames.add(name);
          }
        });

        tempNames.addAll(storedNames);
      } else {
        tempNames = names;
      }
    }

    tempNames.sort((String name1, String name2) => name1.compareTo(name2));

    return shared.setStringList(_livescoreKey, tempNames);
  }

  static Future<List<String>> getPlayerNames() async {
    SharedPreferences shared = await sharedPrefInstance;
    return shared.getStringList(_livescoreKey);
  }

  static Future<bool> removePlayerNames() async {
    SharedPreferences shared = await sharedPrefInstance;
    return shared.remove(_livescoreKey);
  }
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_firestore.dart';

class RankingSharedPref {
  static const String _isItFirstTimeKey = "ranking_firsttime";
  static SharedPreferences _sharedPref;

  static Future<SharedPreferences> get sharedPrefInstance async {
    if (_sharedPref == null) {
      _sharedPref = await SharedPreferences.getInstance();
    }

    return _sharedPref;
  }

  static Future<bool> isItfirstTime() async {
    SharedPreferences shared = await sharedPrefInstance;
    bool value = shared.getBool(_isItFirstTimeKey);
    if (value == null) {
      DocumentSnapshot snapshot =
          await RankingFirestore.getPlayer(Home.loggedInUser.uid);
      value = !snapshot.exists;
      shared.setBool(_isItFirstTimeKey, value);
    }

    return value;
  }

  static Future<bool> setIsItFirsttime(bool isItFirstTime) async {
    SharedPreferences shared = await sharedPrefInstance;
    return shared.setBool(_isItFirstTimeKey, isItFirstTime);
  }

  static Future<bool> removeIsItFirstTime() async {
    SharedPreferences shared = await sharedPrefInstance;
    return shared.remove(_isItFirstTimeKey);
  }
}

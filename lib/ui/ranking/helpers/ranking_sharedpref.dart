import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_firestore.dart';

class RankingSharedPref {
  static SharedPreferences _sharedPref;

static Future<SharedPreferences> get sharedPrefInstance async {
    if (_sharedPref == null) {
      _sharedPref = await SharedPreferences.getInstance();
    }

    return _sharedPref;
  }

  static Future<bool> isItfirstTime() async {
    SharedPreferences shared = await sharedPrefInstance;
    bool value = shared.getBool("ranking_firsttime");
    if (value == null) {
      DocumentSnapshot snapshot = await RankingFirestore.getPlayer(Home.loggedInUser.uid);
      value = !snapshot.exists;
      shared.setBool("ranking_firsttime", value);
    }

    return value;
  }

  static Future<void> setIsItFirsttime(bool isItFirstTime) async {
    await sharedPrefInstance..setBool("ranking_firsttime", isItFirstTime);
  }
}
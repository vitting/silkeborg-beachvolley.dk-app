import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_data_class.dart';
import 'package:silkeborgbeachvolley/ui/settings/helpers/settings_firestore.dart';

class SettingsData {
  bool showWeather;
  String rankingName;
  String sex;
  bool notificationsShowNews;
  bool notificationsShowEvent;
  bool notificationsShowPlay;

  SettingsData(
      {this.showWeather = true,
      this.rankingName = "",
      this.sex = "male",
      this.notificationsShowNews = true,
      this.notificationsShowPlay = true,
      this.notificationsShowEvent = true});

  Map<String, dynamic> toMap() {
    return {
      "showWeather": showWeather, 
      "rankingName": rankingName, 
      "sex": sex,
      "notificationsShowNews": notificationsShowNews,
      "notificationsShowEvent": notificationsShowEvent,
      "notificationsShowPlay": notificationsShowPlay
    };
  }

  factory SettingsData.fromMap(Map<String, dynamic> item) {
    return SettingsData(
        showWeather: item["showWeather"] ?? true,
        rankingName: item["rankingName"] ?? "",
        sex: item["sex"] ?? "",
        notificationsShowNews: item["notificationsShowNews"] ?? true,
        notificationsShowEvent: item["notificationsShowEvent"] ?? true,
        notificationsShowPlay: item["notificationsShowPlay"] ?? true
        );
  }

  Future<void> save() async {
    RankingPlayerData data =
        await RankingPlayerData.getPlayer(Home.loggedInUser.uid);

    if (data != null) {
      data.name = rankingName;
      data.sex = sex;
    } else {
      data = RankingPlayerData(
        userId: Home.loggedInUser.uid,
        name: rankingName,
        sex: sex,
        photoUrl: Home.loggedInUser.photoUrl
      );
    }

    data.save();

    return SettingsFirestore.saveSettings(this, Home.loggedInUser.uid);
  }

  static Future<SettingsData> getSettings(String userId) async {
    SettingsData data;
    DocumentSnapshot snapshot = await SettingsFirestore.getSettings(userId);
    if (snapshot.exists) {
      data = SettingsData.fromMap(snapshot.data);
    }

    return data;
  }
}

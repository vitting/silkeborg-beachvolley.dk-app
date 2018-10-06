import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silkeborgbeachvolley/helpers/userauth.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_data_class.dart';
import 'package:silkeborgbeachvolley/ui/settings/helpers/settings_firestore.dart';

class SettingsData {
  bool showWeather;
  String rankingName;
  String sex;

  SettingsData(
      {this.showWeather = true, this.rankingName = "", this.sex = "male"});

  Map<String, dynamic> toMap() {
    return {"showWeather": showWeather, "rankingName": rankingName, "sex": sex};
  }

  factory SettingsData.fromMap(Map<String, dynamic> item) {
    return SettingsData(
        showWeather: item["showWeather"] ?? true,
        rankingName: item["rankingName"] ?? "",
        sex: item["sex"] ?? "");
  }

  Future<void> save() async {
    RankingPlayerData data =
        await RankingPlayerData.get(UserAuth.loggedInUserId);

    if (data != null) {
      data.name = rankingName;
      data.sex = sex;
      data.save();
    }
    return SettingsFirestore.saveSettings(this, UserAuth.loggedInUserId);
  }

  static Future<SettingsData> get(String userId) async {
    SettingsData data;
    DocumentSnapshot snapshot = await SettingsFirestore.getSettings(userId);
    if (snapshot.exists) {
      data = SettingsData.fromMap(snapshot.data);
    }

    return data;
  }
}
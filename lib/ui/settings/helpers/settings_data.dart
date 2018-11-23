import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_data_class.dart';
import 'package:silkeborgbeachvolley/ui/settings/helpers/settings_firestore.dart';

class SettingsData {
  bool showWeather;
  String rankingName;
  String sex;
  bool notificationsShowNews;
  bool notificationsShowEvent;
  bool notificationsShowPlay;
  bool notificationsShowWriteTo;
  bool notificationsShowWriteToAdmin;
  bool livescorePublicBoardKeepScreenOn;
  bool livescoreControlBoardKeepScreenOn;

  SettingsData(
      {this.showWeather = true,
      this.rankingName = "",
      this.sex = "male",
      this.notificationsShowNews = true,
      this.notificationsShowPlay = true,
      this.notificationsShowEvent = true,
      this.notificationsShowWriteTo = true,
      this.notificationsShowWriteToAdmin = true,
      this.livescorePublicBoardKeepScreenOn = true,
      this.livescoreControlBoardKeepScreenOn = true});

  Map<String, dynamic> toMap() {
    return {
      "showWeather": showWeather,
      "rankingName": rankingName,
      "sex": sex,
      "notificationsShowNews": notificationsShowNews,
      "notificationsShowEvent": notificationsShowEvent,
      "notificationsShowPlay": notificationsShowPlay,
      "notificationsShowWriteTo": notificationsShowWriteTo,
      "notificationsShowWriteToAdmin": notificationsShowWriteToAdmin,
      "livescorePublicBoardKeepScreenOn": livescorePublicBoardKeepScreenOn,
      "livescoreControlBoardKeepScreenOn": livescoreControlBoardKeepScreenOn
    };
  }

  factory SettingsData.fromMap(Map<String, dynamic> item) {
    return SettingsData(
        showWeather: item["showWeather"] ?? true,
        rankingName: item["rankingName"] ?? "",
        sex: item["sex"] ?? "",
        notificationsShowNews: item["notificationsShowNews"] ?? true,
        notificationsShowEvent: item["notificationsShowEvent"] ?? true,
        notificationsShowPlay: item["notificationsShowPlay"] ?? true,
        notificationsShowWriteTo: item["notificationsShowWriteTo"] ?? true,
        notificationsShowWriteToAdmin:
            item["notificationsShowWriteToAdmin"] ?? true,
        livescorePublicBoardKeepScreenOn:
            item["livescorePublicBoardKeepScreenOn"] ?? true,
        livescoreControlBoardKeepScreenOn:
            item["livescoreControlBoardKeepScreenOn"] ?? true);
  }

  Future<SettingsData> setShowWeather(String userId, bool showWeather) async {
    this.showWeather = showWeather;
    await SettingsFirestore.setShowWeather(userId, showWeather);
    return this;
  }

  Future<SettingsData> setNotificationNews(String userId, bool showNews) async {
    this.notificationsShowNews = showNews;
    await SettingsFirestore.setNotificationNews(userId, showNews);
    return this;
  }

  Future<SettingsData> setNotificationEvent(
      String userId, bool showEvent) async {
    this.notificationsShowEvent = showEvent;
    await SettingsFirestore.setNotificationEvent(userId, showEvent);
    return this;
  }

  Future<SettingsData> setNotificationPlay(String userId, bool showPlay) async {
    this.notificationsShowPlay = showPlay;
    await SettingsFirestore.setNotificationPlay(userId, showPlay);
    return this;
  }

  Future<SettingsData> setNotificationWriteTo(
      String userId, bool showWriteTo) async {
    this.notificationsShowWriteTo = showWriteTo;
    await SettingsFirestore.setNotificationWriteTo(userId, showWriteTo);
    return this;
  }

  Future<SettingsData> setNotificationWriteToAdmin(
      String userId, bool showWriteToAdmin) async {
    this.notificationsShowWriteToAdmin = showWriteToAdmin;
    await SettingsFirestore.setNotificationWriteToAdmin(
        userId, showWriteToAdmin);
    return this;
  }

  Future<SettingsData> setRankingName(String userId, String rankingName) async {
    this.rankingName = rankingName;
    await SettingsFirestore.setRankingName(userId, rankingName);
    return this;
  }

  Future<SettingsData> setSex(String userId, String sex) async {
    this.sex = sex;
    await SettingsFirestore.setSex(userId, sex);
    return this;
  }

  Future<SettingsData> setLivescoreBoardKeepScreenOnControl(
      String userId, bool keepScreenOn) async {
    this.livescoreControlBoardKeepScreenOn = keepScreenOn;
    await SettingsFirestore.setLivescoreBoardKeepScreenOnControl(
        userId, keepScreenOn);
    return this;
  }

  Future<SettingsData> setLivescoreBoardKeepScreenOnPublic(
      String userId, bool keepScreenOn) async {
    this.livescorePublicBoardKeepScreenOn = keepScreenOn;
    await SettingsFirestore.setLivescoreBoardKeepScreenOnPublic(
        userId, keepScreenOn);
    return this;
  }

  Future<SettingsData> save(FirebaseUser user) async {
    await SettingsFirestore.saveSettings(this, user.uid);
    return this;
  }

  static Future<SettingsData> getSettings(String userId) async {
    SettingsData data;
    DocumentSnapshot snapshot = await SettingsFirestore.getSettings(userId);
    if (snapshot.exists) {
      data = SettingsData.fromMap(snapshot.data);
    }

    return data;
  }

  static Future<SettingsData> initSettings(FirebaseUser user) async {
    SettingsData settings = await getSettings(user.uid);
    if (settings == null) {
      settings = SettingsData(rankingName: user.displayName);
    }

    RankingPlayerData data = await RankingPlayerData.getPlayer(user.uid);
    if (data == null) {
      data = RankingPlayerData(
          userId: user.uid,
          name: user.displayName,
          sex: "male",
          photoUrl: user.photoUrl);

      await data.save();
    }

    return settings.save(user);
  }
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silkeborgbeachvolley/ui/settings/helpers/settings_data.dart';

class SettingsFirestore {
  static final _collectionName = "settings";
  static Firestore _firestore = Firestore.instance;

  static Future<void> saveSettings(SettingsData settings, String userId) {
    return _firestore
        .collection(_collectionName)
        .document(userId)
        .setData(settings.toMap());
  }

  static Future<DocumentSnapshot> getSettings(String userId) {
    return _firestore.collection(_collectionName).document(userId).get();
  }

  static Future<void> setShowWeather(String userId, bool showWeather) {
    return _firestore.collection(_collectionName).document(userId).updateData({
      "showWeather": showWeather
    });
  }

  static Future<void> setNotificationNews(String userId, bool showNews) {
    return _firestore.collection(_collectionName).document(userId).updateData({
      "notificationsShowNews": showNews
    });
  }

  static Future<void> setNotificationEvent(String userId, bool showEvent) {
    return _firestore.collection(_collectionName).document(userId).updateData({
      "notificationsShowEvent": showEvent
    });
  }

  static Future<void> setNotificationPlay(String userId, bool showPlay) {
    return _firestore.collection(_collectionName).document(userId).updateData({
      "notificationsShowPlay": showPlay
    });
  }

  static Future<void> setNotificationWriteTo(String userId, bool showWriteTo) {
    return _firestore.collection(_collectionName).document(userId).updateData({
      "notificationsShowWriteTo": showWriteTo
    });
  }

  static Future<void> setNotificationWriteToAdmin(String userId, bool showWriteToAdmin) {
    return _firestore.collection(_collectionName).document(userId).updateData({
      "notificationsShowWriteToAdmin": showWriteToAdmin
    });
  }

  static Future<void> setRankingName(String userId, String rankingName) {
    return _firestore.collection(_collectionName).document(userId).updateData({
      "rankingName": rankingName
    });
  }

  static Future<void> setSex(String userId, String sex) {
    return _firestore.collection(_collectionName).document(userId).updateData({
      "set": sex
    });
  }

  static Future<void> setLivescoreBoardKeepScreenOnControl(String userId, bool keepScreenOn) {
    return _firestore.collection(_collectionName).document(userId).updateData({
      "livescoreControlBoardKeepScreenOn": keepScreenOn
    });
  }

  static Future<void> setLivescoreBoardKeepScreenOnPublic(String userId, bool keepScreenOn) {
    return _firestore.collection(_collectionName).document(userId).updateData({
      "livescorePublicBoardKeepScreenOn": keepScreenOn
    });
  }
}

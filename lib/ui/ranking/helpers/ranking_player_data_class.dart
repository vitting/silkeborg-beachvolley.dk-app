import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_firestore.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_stats_data_class.dart';

class RankingPlayerData {
  String name;
  String userId;
  String photoUrl;
  String sex;
  bool deleted;
  RankingPlayerStatsData points;
  RankingPlayerStatsData numberOfPlayedMatches;
  List<dynamic> playerFavorites;

  RankingPlayerData(
      {this.name,
      this.numberOfPlayedMatches,
      this.photoUrl,
      this.points,
      this.sex,
      this.userId,
      this.playerFavorites,
      this.deleted = false});

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "userId": userId,
      "photoUrl": photoUrl,
      "deleted": deleted,
      "sex": sex,
      "points":
          points == null ? RankingPlayerStatsData().toMap() : points.toMap(),
      "numberOfPlayedMatches": numberOfPlayedMatches == null
          ? RankingPlayerStatsData().toMap()
          : numberOfPlayedMatches.toMap(),
      "playerFavorites": playerFavorites ?? []
    };
  }

  Future<void> save() async {
    return RankingFirestore.savePlayer(this);
  }

  Future<void> hide() {
    return RankingFirestore.deletePlayerMarkAsDeleted(userId);
  }

  Future<void> unhide() {
    return RankingFirestore.deletePlayerMarkAsNotDeleted(userId);
  }

  static Stream<QuerySnapshot> getPlayersAsStream(
      bool showOnlyDeleted, int limit) {
    return RankingFirestore.getAllPlayersAsStream(showOnlyDeleted, limit);
  }

  static Stream<QuerySnapshot> getRankingAsStream() {
    return RankingFirestore.getRankingAsStream();
  }

  static Future<RankingPlayerData> getPlayer(String userId) async {
    RankingPlayerData data;
    DocumentSnapshot snapshot = await RankingFirestore.getPlayer(userId);
    if (snapshot.exists) {
      data = RankingPlayerData.fromMap(snapshot.data);
    }

    return data;
  }

  static Future<RankingPlayerData> initPlayer(FirebaseUser user) async {
    RankingPlayerData data = await RankingPlayerData.getPlayer(user.uid);
    if (data == null) {
      data = RankingPlayerData(
          userId: user.uid,
          name: user.displayName,
          sex: "male",
          photoUrl: user.photoUrl);

      await data.save();
    }

    return data;
  }

  static Future<void> setName(String userId, String name) {
    return RankingFirestore.setName(userId, name);
  }

  static Future<void> setSex(String userId, String sex) {
    return RankingFirestore.setSex(userId, sex);
  }

  factory RankingPlayerData.fromMap(Map<String, dynamic> doc) {
    return RankingPlayerData(
        name: doc["name"] ?? "",
        userId: doc["userId"] ?? "",
        photoUrl: doc["photoUrl"] ?? "",
        sex: doc["sex"] ?? "",
        deleted: doc["deleted"],
        points: doc["points"] == null
            ? RankingPlayerStatsData()
            : RankingPlayerStatsData.fromMap(doc["points"]),
        numberOfPlayedMatches: doc["numberOfPlayedMatches"] == null
            ? RankingPlayerStatsData()
            : RankingPlayerStatsData.fromMap(doc["numberOfPlayedMatches"]),
        playerFavorites: doc["playerFavorites"] ?? []);
  }
}

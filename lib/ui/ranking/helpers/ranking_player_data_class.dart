import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silkeborgbeachvolley/helpers/base_data_class.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_firestore.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_stats_data_class.dart';

class RankingPlayerData implements BaseData {
  String name;
  String userId;
  String photoUrl;
  String sex;
  RankingPlayerStatsData points;
  RankingPlayerStatsData numberOfPlayedMatches;
  List<dynamic> playerFavorites;
  
  RankingPlayerData({this.name, this.numberOfPlayedMatches, this.photoUrl, this.points, this.sex, this.userId, this.playerFavorites});

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "userId": userId,
      "photoUrl": photoUrl,
      "sex": sex,
      "points": points == null ? RankingPlayerStatsData().toMap() : points.toMap(),
      "numberOfPlayedMatches": numberOfPlayedMatches == null ? RankingPlayerStatsData().toMap() : numberOfPlayedMatches.toMap(),
      "playerFavorites": playerFavorites ?? []
    };
  }

  Future<void> save() async {
    return RankingFirestore.savePlayer(this);
  }

  Future<void> delete() {
    throw Exception("Delete is not implementet");
  }

  static Future<RankingPlayerData> get(String userId) async {
    RankingPlayerData data;
    DocumentSnapshot snapshot = await RankingFirestore.getPlayer(userId);
    if (snapshot.exists) {
      data = RankingPlayerData.fromMap(snapshot.data);
    }

    return data;
  }
  
  factory RankingPlayerData.fromMap(Map<String, dynamic> doc) {
    return RankingPlayerData(
      name: doc["name"] ?? "",
      userId: doc["userId"] ?? "",
      photoUrl: doc["photoUrl"] ?? "",
      sex: doc["sex"] ?? "",
      points: doc["points"] == null ? RankingPlayerStatsData() : RankingPlayerStatsData.fromMap(doc["points"]),
      numberOfPlayedMatches: doc["numberOfPlayedMatches"] == null ? RankingPlayerStatsData() : RankingPlayerStatsData.fromMap(doc["numberOfPlayedMatches"]), 
      playerFavorites: doc["playerFavorites"] ?? []
    );
  }
}
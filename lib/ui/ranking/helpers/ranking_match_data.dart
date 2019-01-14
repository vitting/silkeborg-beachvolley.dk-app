import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:silkeborgbeachvolley/helpers/system_helpers.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_firestore.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_match_player_data_class.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_data_class.dart';

class RankingMatchData {
  String id;
  String userId;
  DateTime matchDate;
  Timestamp createdDate;
  int year;
  bool enabled;
  RankingMatchPlayerData winner1;
  RankingMatchPlayerData winner2;
  RankingMatchPlayerData loser1;
  RankingMatchPlayerData loser2;

  RankingMatchData(
      {this.userId,
      this.id,
      @required this.matchDate,
      @required this.winner1,
      @required this.winner2,
      @required this.loser1,
      @required this.loser2,
      this.createdDate,
      this.year,
      this.enabled = true});

  Future<RankingPlayerData> getPlayerCreatedMatch() {
    print(id);
    return RankingPlayerData.getPlayer(userId);  
  }

  Future<void> save(String userId) async {
    id = id ?? SystemHelpers.generateUuid();
    this.userId = this.userId ?? userId;
    createdDate = createdDate ?? Timestamp.now();
    year = year ?? matchDate.year;
    
    await RankingFirestore.saveMatch(this);
  }

  Future<void> delete() async {
    return RankingFirestore.deleteMatch(id);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userId": userId,
      "matchDate": Timestamp.fromDate(matchDate),
      "winner1": winner1.toMap(),
      "winner2": winner2.toMap(),
      "loser1": loser1.toMap(),
      "loser2": loser2.toMap(),
      "createdDate": createdDate,
      "year": year,
      "enabled": enabled
    };
  }

  static Stream<QuerySnapshot> getMatchesAsStreamWithLimit(int limit) {
    return RankingFirestore.getMatchesAsStreamWithLimit(limit);
  }

  static Stream<QuerySnapshot> getMatchesAsStream(int limit) {
    return RankingFirestore.getMatchesAsStream(true, limit);
  }

  static RankingMatchData fromMap(Map<String, dynamic> item) {
    return RankingMatchData(
        id: item["id"],
        userId: item["userId"] ?? "",
        matchDate: (item["matchDate"] as Timestamp).toDate(),
        winner1: RankingMatchPlayerData.fromMap(item["winner1"]),
        winner2: RankingMatchPlayerData.fromMap(item["winner2"]),
        loser1: RankingMatchPlayerData.fromMap(item["loser1"]),
        loser2: RankingMatchPlayerData.fromMap(item["loser2"]),
        createdDate: item["createdDate"],
        year: item["year"],
        enabled: item["enabled"]);
  }
}

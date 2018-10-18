import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:silkeborgbeachvolley/helpers/base_data_class.dart';
import 'package:silkeborgbeachvolley/helpers/uuid_helpers.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_firestore.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_match_player_data_class.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_data_class.dart';

class RankingMatchData implements BaseData {
  String id;
  String userId;
  DateTime matchDate;
  dynamic createdDate;
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
      this.createdDate});

  Future<RankingPlayerData> getPlayerCreatedMatch() {
    return RankingPlayerData.getPlayer(userId);
  }

  Future<void> save() async {
    id = id ?? UuidHelpers.generateUuid();
    userId = userId ?? Home.loggedInUser.uid;
    createdDate = createdDate ?? FieldValue.serverTimestamp();

    await RankingFirestore.saveMatch(this);
  }

  Future<void> delete() async {
    return RankingFirestore.deleteMatch(id);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userId": userId,
      "matchDate": matchDate,
      "winner1": winner1.toMap(),
      "winner2": winner2.toMap(),
      "loser1": loser1.toMap(),
      "loser2": loser2.toMap(),
      "createdDate": createdDate
    };
  }

  static Stream<QuerySnapshot> getMatchesAsStreamWithLimit(int limit) {
    return RankingFirestore.getMatchesAsStreamWithLimit(limit);
  }

  static Stream<QuerySnapshot> getMatchesAsStream() {
    return RankingFirestore.getMatchesAsStream();
  }

  static RankingMatchData fromMap(Map<String, dynamic> item) {
    return RankingMatchData(
        id: item["id"],
        userId: item["userId"] ?? "",
        matchDate: item["matchDate"] ?? DateTime.now(),
        winner1: RankingMatchPlayerData.fromMap(item["winner1"]),
        winner2: RankingMatchPlayerData.fromMap(item["winner2"]),
        loser1: RankingMatchPlayerData.fromMap(item["loser1"]),
        loser2: RankingMatchPlayerData.fromMap(item["loser2"]),
        createdDate: item["createdDate"]);
  }
}

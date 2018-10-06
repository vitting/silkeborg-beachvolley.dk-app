import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:silkeborgbeachvolley/helpers/base_data_class.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_firestore.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_match_player_data_class.dart';

/// createdDate is of type DateTime, but is marked as dynmic so it's possible to
/// use it with Firestore FieldValue.serverTimestamp().
class RankingMatchData implements BaseData {
  String userId;
  DateTime matchDate;
  dynamic createdDate;
  RankingMatchPlayerData winner1;
  RankingMatchPlayerData winner2;
  RankingMatchPlayerData loser1;
  RankingMatchPlayerData loser2;

  RankingMatchData(
      {this.userId,
      @required this.matchDate,
      @required this.winner1,
      @required this.winner2,
      @required this.loser1,
      @required this.loser2,
      this.createdDate});

  Future<void> save() async {
    userId = userId ?? Home.loggedInUser.uid;
    createdDate = createdDate ?? FieldValue.serverTimestamp();

    await RankingFirestore.saveMatch(this);
  }

  Future<void> delete() async {
    //We don't save matchid
    // await RankingFirestore.deleteMatch(id)
  }

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "matchDate": matchDate,
      "winner1": winner1.toMap(),
      "winner2": winner2.toMap(),
      "loser1": loser1.toMap(),
      "loser2": loser2.toMap(),
      "createdDate": createdDate
    };
  }

  static RankingMatchData fromMap(Map<String, dynamic> item) {
    return RankingMatchData(
        userId: item["userId"] ?? "",
        matchDate: item["matchDate"] ?? DateTime.now(),
        winner1: RankingMatchPlayerData.fromMap(item["winner1"]),
        winner2: RankingMatchPlayerData.fromMap(item["winner2"]),
        loser1: RankingMatchPlayerData.fromMap(item["loser1"]),
        loser2: RankingMatchPlayerData.fromMap(item["loser2"]),
        createdDate: item["createdDate"]);
  }
}

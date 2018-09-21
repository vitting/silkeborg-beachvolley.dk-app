import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_stats_data_class.dart';

class RankingPlayerData {
  String name;
  String userId;
  String photoUrl;
  String sex;
  RankingPlayerStatsData points;
  RankingPlayerStatsData numberOfPlayedMatches;
  
  RankingPlayerData({this.name, this.numberOfPlayedMatches, this.photoUrl, this.points, this.sex, this.userId});

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "userId": userId,
      "photoUrl": photoUrl,
      "sex": sex,
      "points": points == null ? RankingPlayerStatsData().toMap() : points.toMap(),
      "numberOfPlayedMatches": numberOfPlayedMatches == null ? RankingPlayerStatsData().toMap() : numberOfPlayedMatches.toMap()
    };
  }
  
  static RankingPlayerData fromMap(Map<String, dynamic> doc) {
    return RankingPlayerData(
      name: doc["name"] ?? "",
      userId: doc["userId"] ?? "",
      photoUrl: doc["photoUrl"] ?? "",
      sex: doc["sex"] ?? "",
      points: doc["points"] == null ? RankingPlayerStatsData() : RankingPlayerStatsData.fromMap(doc["points"]),
      numberOfPlayedMatches: doc["numberOfPlayedMatches"] == null ? RankingPlayerStatsData() : RankingPlayerStatsData.fromMap(doc["numberOfPlayedMatches"]) 
    );
  }
}
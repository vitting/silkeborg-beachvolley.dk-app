class RankingPlayerDataStats {
  int won;
  int lost;
  int total;

  RankingPlayerDataStats({this.total = 0, this.won = 0, this.lost = 0});

  Map<String, dynamic> toMap() {
    return {
      "total": total,
      "won": won,
      "lost": lost
    };
  }

  static RankingPlayerDataStats fromMap(Map<dynamic, dynamic> item) {
    return RankingPlayerDataStats(
      total: item["total"] == null ? 0 : item["total"],
      won: item["won"] == null ? 0 : item["won"],
      lost: item["lost"] == null ? 0 : item["lost"]
    );
  }
}

class RankingPlayerData {
  String name;
  String userId;
  String photoUrl;
  String sex;
  RankingPlayerDataStats points;
  RankingPlayerDataStats numberOfPlayedMatches;
  
  RankingPlayerData({this.name, this.numberOfPlayedMatches, this.photoUrl, this.points, this.sex, this.userId});

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "userId": userId,
      "photoUrl": photoUrl,
      "sex": sex,
      "points": points == null ? RankingPlayerDataStats().toMap() : points.toMap(),
      "numberOfPlayedMatches": numberOfPlayedMatches == null ? RankingPlayerDataStats().toMap() : numberOfPlayedMatches.toMap()
    };
  }
  
  static RankingPlayerData fromMap(Map<String, dynamic> doc) {
    return RankingPlayerData(
      name: doc["name"] == null ? "" : doc["name"],
      userId: doc["userId"] == null ? "" : doc["userId"],
      photoUrl: doc["photoUrl"] == null ? "" : doc["photoUrl"],
      sex: doc["sex"] == null ? "" : doc["sex"],
      points: doc["points"] == null ? RankingPlayerDataStats() : RankingPlayerDataStats.fromMap(doc["points"]),
      numberOfPlayedMatches: doc["numberOfPlayedMatches"] == null ? RankingPlayerDataStats() : RankingPlayerDataStats.fromMap(doc["numberOfPlayedMatches"]) 
    );
  }
}
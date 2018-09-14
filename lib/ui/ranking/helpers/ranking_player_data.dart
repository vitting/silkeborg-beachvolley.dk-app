class RankingPlayerData {
  String name;
  String userId;
  String photoUrl;
  String sex;
  int points;
  int numberOfPlayedMatches;

  RankingPlayerData({this.name, this.numberOfPlayedMatches = 0, this.photoUrl, this.points = 0, this.sex, this.userId});

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "userId": userId,
      "photoUrl": photoUrl,
      "sex": sex,
      "points": points,
      "numberOfPlayedMatches": numberOfPlayedMatches
    };
  }
  
  static RankingPlayerData fromMap(Map<String, dynamic> doc) {
    return RankingPlayerData(
      name: doc["name"] == null ? "" : doc["name"],
      userId: doc["userId"] == null ? "" : doc["userId"],
      photoUrl: doc["photoUrl"] == null ? "" : doc["photoUrl"],
      sex: doc["sex"] == null ? "" : doc["sex"],
      points: doc["points"] == null ? 0 : doc["points"],
      numberOfPlayedMatches: doc["numberOfPlayedMatches"] == null ? 0 : doc["numberOfPlayedMatches"]
    );
  }
}
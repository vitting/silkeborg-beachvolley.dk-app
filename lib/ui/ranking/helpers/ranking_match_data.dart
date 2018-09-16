import 'package:meta/meta.dart';

class RankingMatchPlayerData {
  String id;
  String name;
  String photoUrl;
  int points;

  RankingMatchPlayerData({@required this.id, @required this.name, @required this.photoUrl, @required this.points});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "photoUrl": photoUrl,
      "points": points
    };
  }

  static RankingMatchPlayerData fromMap(Map<dynamic, dynamic> item) {
    return RankingMatchPlayerData(
      id: item["id"] == null ? "" : item["id"],
      name: item["name"] == null ? "" : item["name"],
      photoUrl: item["photoUrl"] == null ? "" : item["photoUrl"],
      points: item["points"] == null ? 0 : item["points"]
    );
  }
}
/// createdDate is of type DateTime, but is marked as dynmic so it's possible to
/// use it with Firestore FieldValue.serverTimestamp().
class RankingMatchData {
  String userId;
  DateTime matchDate;
  dynamic createdDate;
  RankingMatchPlayerData winner1;
  RankingMatchPlayerData winner2;
  RankingMatchPlayerData loser1;
  RankingMatchPlayerData loser2;

  RankingMatchData({@required this.userId, @required this.matchDate, @required this.winner1, @required this.winner2, @required this.loser1, @required this.loser2, this.createdDate});

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
      userId: item["userId"] == null ? "" : item["userId"],
      matchDate: item["matchDate"] == null ? DateTime.now() : item["matchDate"],
      winner1: RankingMatchPlayerData.fromMap(item["winner1"]),
      winner2: RankingMatchPlayerData.fromMap(item["winner2"]),
      loser1: RankingMatchPlayerData.fromMap(item["loser1"]),
      loser2: RankingMatchPlayerData.fromMap(item["loser2"]),
      createdDate: item["createdDate"]
      
    );
  }
}
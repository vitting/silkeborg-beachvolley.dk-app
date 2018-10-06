import 'package:meta/meta.dart';

class RankingMatchPlayerData {
  String id;
  String name;
  String photoUrl;
  int points;

  RankingMatchPlayerData(
      {@required this.id,
      @required this.name,
      @required this.photoUrl,
      @required this.points});

  Map<String, dynamic> toMap() {
    return {"id": id, "name": name, "photoUrl": photoUrl, "points": points};
  }

  static RankingMatchPlayerData fromMap(Map<dynamic, dynamic> item) {
    return RankingMatchPlayerData(
        id: item["id"] == null ? "" : item["id"],
        name: item["name"] == null ? "" : item["name"],
        photoUrl: item["photoUrl"] == null ? "" : item["photoUrl"],
        points: item["points"] == null ? 0 : item["points"]);
  }
}

import 'package:meta/meta.dart';

class PlayerCommitted {
  String bulletinId;
  String userId;
  String name;
  String photoUrl;

  PlayerCommitted({@required this.bulletinId, @required this.name, @required this.photoUrl, @required this.userId});

  Map<String, dynamic> toMap() {
    return{
      "bulletinId": bulletinId,
      "userId": userId,
      "name": name,
      "photoUrl": photoUrl
    };
  }

  static PlayerCommitted fromMap(Map<String, dynamic> item) {
    return PlayerCommitted(
      bulletinId: item["bulletinId"] == null ? "" : item["bulletinId"],
      name: item["name"] == null ? "" : item["name"],
      userId: item["userId"] == null ? "" : item["userId"],
      photoUrl: item["photoUrl"] == null ? "" : item["photoUrl"]
    );
  }
}
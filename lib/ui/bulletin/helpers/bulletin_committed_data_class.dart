import 'package:meta/meta.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';

class CommittedData {
  String bulletinId;
  String userId;
  String name;
  String photoUrl;
  BulletinType type;
  
  CommittedData({@required this.bulletinId, @required this.name, @required this.photoUrl, @required this.userId, @required this.type});

  Map<String, dynamic> toMap() {
    return{
      "bulletinId": bulletinId,
      "userId": userId,
      "name": name,
      "photoUrl": photoUrl,
      "type": BulletinTypeHelper.getBulletinTypeAsString(type)
    };
  }

  static CommittedData fromMap(Map<String, dynamic> item) {
    return CommittedData(
      bulletinId: item["bulletinId"] == null ? "" : item["bulletinId"],
      name: item["name"] == null ? "" : item["name"],
      userId: item["userId"] == null ? "" : item["userId"],
      photoUrl: item["photoUrl"] == null ? "" : item["photoUrl"],
      type: item["type"] == null ? BulletinType.none : BulletinTypeHelper.getBulletinTypeStringAsType(item["type"])
    );
  }
}
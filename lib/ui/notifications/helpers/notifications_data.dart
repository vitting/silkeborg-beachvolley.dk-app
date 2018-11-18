import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silkeborgbeachvolley/ui/notifications/helpers/notifications_firestore.dart';

class NotificationsData {
  String docId;
  Timestamp creationDate;
  String type;
  String subType;
  String fromUserId;
  String userId;
  bool shown;

  NotificationsData({this.docId, this.creationDate, this.type, this.subType, this.fromUserId, this.userId, this.shown});

  factory NotificationsData.fromMap(Map<String, dynamic> item, String docId) {
    return NotificationsData(
      creationDate: item["creationDate"],
      type: item["type"],
      subType: item["subType"],
      fromUserId: item["fromUserId"],
      userId: item["userId"],
      shown: item["shown"],
      docId: docId
    );
  }

  Future<void> setShownState(bool shown) {
    return NotificationsFirestore.setShownState(docId, shown);
  }
}
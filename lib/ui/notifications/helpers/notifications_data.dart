import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silkeborgbeachvolley/ui/notifications/helpers/notifications_firestore.dart';

class NotificationsData {
  String docId;
  Timestamp creationDate;
  String type;
  String subType;
  String fromUserId;
  String fromName;
  String fromDisplayUrl;
  List<String> userIds;
  String subjectId;

  NotificationsData(
      {this.docId,
      this.creationDate,
      this.type,
      this.subType,
      this.fromUserId,
      this.fromName,
      this.fromDisplayUrl,
      this.subjectId,
      this.userIds
      });

  factory NotificationsData.fromMap(Map<String, dynamic> item, String docId) {
    return NotificationsData(
        creationDate: item["creationDate"],
        type: item["type"],
        subType: item["subType"],
        fromUserId: item["fromUserId"],
        fromName: item["fromName"],
        fromDisplayUrl: item["fromDisplayUrl"],
        userIds: item["userIds"] == null
            ? []
            : (item["userIds"] as List<dynamic>).map((dynamic item) {
                return item.toString();
              }).toList(),
        subjectId: item["subjectId"],
        docId: docId);
  }

  Future<void> setShownState(String userId) {
    return NotificationsFirestore.setShownState(docId, userId);
  }

  static Stream<QuerySnapshot> getUserNotificationsAsStream(String userId, int limit) {
    return NotificationsFirestore.getNotificationsFromUserIdAsStream(userId, limit);
  }
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silkeborgbeachvolley/helpers/base_data_class.dart';
import 'package:silkeborgbeachvolley/helpers/notification_categories_enum.dart';
import 'package:silkeborgbeachvolley/helpers/user_firestore.dart';

class UserMessagingData implements BaseData {
  String userId;
  String token;
  List<NotificationCategory> subscriptions;

  UserMessagingData({this.userId, this.token, this.subscriptions});

  Future<void> addSubscription(NotificationCategory subscription) {
    return UserFirestore.addSubscriptionUserMessaging(
        userId,
        NotificationCategoryHelper.getNotificationCategoryAsString(
            subscription));
  }

  Future<void> removeSubscription(NotificationCategory subscription) {
    return UserFirestore.removeSubscriptionUserMessaging(
        userId,
        NotificationCategoryHelper.getNotificationCategoryAsString(
            subscription));
  }

  @override
  Future<void> delete() async {
    return UserFirestore.deleteUserMessaging(userId);
  }

  @override
  Future<void> save() {
    return UserFirestore.setUserMessaging(this);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "token": token,
      "subscriptions": subscriptions == null
          ? []
          : subscriptions.map<String>((NotificationCategory category) {
              return NotificationCategoryHelper.getNotificationCategoryAsString(
                  category);
            }).toList()
    };
  }

  factory UserMessagingData.formMap(Map<String, dynamic> item) {
    return UserMessagingData(
        userId: item["userId"] ?? "",
        token: item["token"] ?? "",
        subscriptions: item["subscriptions"] == null
            ? []
            : (item["subscriptions"] as List<dynamic>)
                .map<NotificationCategory>((dynamic category) {
                return NotificationCategoryHelper
                    .getNotificationCategoryStringAsType(category);
              }).toList());
  }

  static Future<UserMessagingData> getUserMessaging(String userId) async {
    UserMessagingData data;
    DocumentSnapshot snapshot = await UserFirestore.getUserMessaging(userId);
    if (snapshot.exists) {
      data = UserMessagingData.formMap(snapshot.data);
    }

    return data;
  }
}

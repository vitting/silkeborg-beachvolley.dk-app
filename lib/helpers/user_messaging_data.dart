import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silkeborgbeachvolley/helpers/notification_categories_enum.dart';
import 'package:silkeborgbeachvolley/helpers/user_firestore.dart';

class UserMessagingData {
  final String userId;
  final String token;
  final bool isAdmin1;
  final bool isAdmin2;
  final String languageCode;
  final List<NotificationCategory> subscriptions;
  
  const UserMessagingData(
      {this.userId,
      this.token,
      this.languageCode,
      this.subscriptions,
      this.isAdmin1 = false,
      this.isAdmin2 = false});

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

  Future<void> delete() async {
    return UserFirestore.deleteUserMessaging(userId);
  }

  Future<void> save() async {
    return UserFirestore.setUserMessaging(this);
  }

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "token": token,
      "isAdmin1": isAdmin1,
      "isAdmin2": isAdmin2,
      "languageCode": languageCode,
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
        isAdmin1: item["isAdmin1"],
        isAdmin2: item["isAdmin2"],
        languageCode: item["languageCode"],
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

  static Future<void> deleteUserMessaging(String userId) async {
    return UserFirestore.deleteUserMessaging(userId);
  }
}

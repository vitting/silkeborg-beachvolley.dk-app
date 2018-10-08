import 'dart:async';

import 'package:silkeborgbeachvolley/helpers/base_data_class.dart';
import 'package:silkeborgbeachvolley/helpers/user_firestore.dart';

class UserMessagingData implements BaseData {
  String userId;
  String token;
  List<String> subscriptions;

  UserMessagingData({this.userId, this.token, this.subscriptions});

  Future<void> addSubscription(String subscription) {
    return UserFirestore.addSubscriptionUserMessaging(userId, subscription);
  }

  Future<void> removeSubscription(String subscription) {
    return UserFirestore.removeSubscriptionUserMessaging(userId, subscription);
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
      "subscriptions": subscriptions ?? []
    };
  }

  factory UserMessagingData.formMap(Map<String, dynamic> item) {
    return UserMessagingData(
      userId: item["userId"] ?? "",
      token: item["token"] ?? "",
      subscriptions: item["subscriptions"] ?? []
    );
  }
  
}
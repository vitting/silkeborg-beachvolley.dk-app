import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:silkeborgbeachvolley/helpers/notification_categories_enum.dart';
import 'package:silkeborgbeachvolley/helpers/notification_data.dart';
import 'package:silkeborgbeachvolley/helpers/user_messaging_data.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/settings/helpers/settings_data.dart';

Future<void> initMessaging(
    String userId,
    FirebaseMessaging firebaseMessaging,
    SettingsData settings,
    StreamController<NotificationData> notificationController) async {
  firebaseMessaging.requestNotificationPermissions(
      IosNotificationSettings(alert: true, badge: true, sound: true));

  firebaseMessaging.configure(

      ///OnLaunch er der ikke body og titel med. Bliver executed når appen er termineret
      onLaunch: (Map<String, dynamic> message) {
    NotificationData data;
    if (message != null) {
      data = NotificationData(
          type: message["dataType"] ?? "",
          bulletinType: message["bulletinType"] ?? "",
          state: NotificationState.launch);
    }

    notificationController.add(data);
  },

      ///OnMessage er der body og titel med. Bliver executed når appen er aktiv
      onMessage: (Map<String, dynamic> message) {
    NotificationData data;
    if (message != null && message["data"] != null) {
      data = NotificationData(
          type: message["data"]["dataType"] ?? "",
          bulletinType: message["data"]["bulletinType"] ?? "",
          state: NotificationState.message);
    }

    notificationController.add(data);
  },

      ///OnResume er der ikke body og titel med. Bliver executed når appen er minimeret
      onResume: (Map<String, dynamic> message) {
    NotificationData data;
    if (message != null) {
      data = NotificationData(
          type: message["dataType"] ?? "",
          bulletinType: message["bulletinType"] ?? "",
          state: NotificationState.resume);
    }

    notificationController.add(data);
  });

  firebaseMessaging.onTokenRefresh.listen((token) {
    if (Home.loggedInUser != null) {
      UserMessagingData userMessagingData =
          _createUserMessaging(settings, userId, token);

      userMessagingData.save();
      Home.userMessaging = userMessagingData;
    }
  });

  await firebaseMessaging.getToken();
}

UserMessagingData _createUserMessaging(
    SettingsData settings, String userId, String token) {
  UserMessagingData userMessagingData =
      UserMessagingData(userId: userId, token: token);

  List<NotificationCategory> categories = [];
  if (settings.notificationsShowNews) {
    categories.add(NotificationCategory.news);
  }

  if (settings.notificationsShowEvent) {
    categories.add(NotificationCategory.event);
  }

  if (settings.notificationsShowPlay) {
    categories.add(NotificationCategory.play);
  }

  userMessagingData.subscriptions = categories;

  return userMessagingData;
}

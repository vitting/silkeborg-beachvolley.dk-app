import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:silkeborgbeachvolley/helpers/notification_categories_enum.dart';
import 'package:silkeborgbeachvolley/helpers/user_info_class.dart';
import 'package:silkeborgbeachvolley/helpers/user_messaging_data.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/settings/helpers/settings_data_class.dart';

Future<SettingsData> initSettings(String userId, String displayName) async {
  SettingsData settings = await SettingsData.getSettings(userId);
  if (settings == null) {
    settings = SettingsData(rankingName: displayName);
    settings.save();
  }

  return settings;
}

Future<UserInfoData> loadUserInfo(String userId) {
  return UserInfoData.get(userId);
}

Future<void> initMessaging(String userId, FirebaseMessaging firebaseMessaging,
    SettingsData settings) async {
  firebaseMessaging.requestNotificationPermissions(
      IosNotificationSettings(alert: true, badge: true, sound: true));

  firebaseMessaging.configure(

      ///OnLaunch er der ikke body og titel med. Bliver executed når appen er termineret
      onLaunch: (Map<String, dynamic> message) {
    print("ONLAUNCH: $message");
  },

      ///OnMessage er der body og titel med. Bliver executed når appen er aktiv
      onMessage: (Map<String, dynamic> message) {
    print("ONMESSAGE: $message");
  },

      ///OnResume er der ikke body og titel med. Bliver executed når appen er minimeret
      onResume: (Map<String, dynamic> message) {
    print("ONRESUME: $message");
  });

  firebaseMessaging.onTokenRefresh.listen((token) {
    if (Home.loggedInUser != null) {
      UserMessagingData userMessagingData =
          _createUserMessaging(settings, userId, token);

      userMessagingData.save();
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

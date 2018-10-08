import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:silkeborgbeachvolley/helpers/user_info_class.dart';
import 'package:silkeborgbeachvolley/helpers/user_messaging_data.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/settings/helpers/settings_data_class.dart';

Future<void> initSettings(String userId, String displayName) async {
  SettingsData settings = await SettingsData.get(userId);
  if (settings == null) {
    settings = SettingsData(rankingName: displayName);
    settings.save();
  }
}

Future<UserInfoData> loadUserInfo(String userId) {
  return UserInfoData.get(userId);
}

Future<void> initMessaging(String userId, FirebaseMessaging firebaseMessaging) async {
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
          UserMessagingData(userId: userId, token: token);

      userMessagingData.save();
    }
  });

  await firebaseMessaging.getToken();
}

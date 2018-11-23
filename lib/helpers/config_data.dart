import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/main_inheretedwidget.dart';

class ConfigData {
  final String emailFromName;
  final String emailFromMail;
  final String emailUsername;
  final String emailPassword;
  final String emailDebug;
  final String clubName;
  final String clubEmail;

  ConfigData(
      {this.emailFromName,
      this.emailFromMail,
      this.emailUsername,
      this.emailPassword,
      this.emailDebug,
      this.clubName,
      this.clubEmail
      });

  factory ConfigData.fromMap(Map<String, dynamic> item) {
    return ConfigData(
        emailFromName: item["emailFromName"],
        emailFromMail: item["emailFromMail"],
        emailUsername: item["emailUsername"],
        emailPassword: item["emailPassword"],
        emailDebug: item["emailDebug"],
        clubName: item["clubName"],
        clubEmail: item["clubEmail"]
        );
  }

  static Future<ConfigData> getConfig(
      BuildContext context, SystemMode profile) async {
    ConfigData config;

    try {
      String data = "";
      switch (profile) {
        case SystemMode.develop:
          data = await DefaultAssetBundle.of(context)
              .loadString("assets/files/config_develop.json");
          break;
        case SystemMode.release:
          data = await DefaultAssetBundle.of(context)
              .loadString("assets/files/config_release.json");
          break;
      }

      Map<String, dynamic> jsonDecoded = json.decode(data);
      config = ConfigData.fromMap(jsonDecoded);
    } catch (e) {
      print(e);
    }

    return config;
  }
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silkeborgbeachvolley/ui/settings/helpers/settings_data.dart';

class SettingsFirestore {
  static final _collectionName = "settings";
  static Firestore _firestore = Firestore.instance;

  static Future<void> saveSettings(SettingsData settings, String userId) {
    return _firestore
        .collection(_collectionName)
        .document(userId)
        .setData(settings.toMap());
  }

  static Future<DocumentSnapshot> getSettings(String userId) {
    return _firestore.collection(_collectionName).document(userId).get();
  }
}

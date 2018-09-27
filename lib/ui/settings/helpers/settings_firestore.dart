import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silkeborgbeachvolley/ui/settings/helpers/settings_data_class.dart';

class SettingsFirestore {
  static final _collectionName = "settings";
  static Firestore _firestore;

  static Firestore get firestoreInstance {
    if (_firestore == null) {
      _firestore = Firestore.instance;
    }

    return _firestore;
  }

  static Future<void> saveSettings(SettingsData settings, String userId) {
    return firestoreInstance.collection(_collectionName).document(userId).setData(settings.toMap());  
  }

  static Future<DocumentSnapshot> getSettings(String userId) {
    return firestoreInstance.collection(_collectionName).document(userId).get();
  }
}
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/helpers/enrollment_user_data_class.dart';

class EnrollmentFirestore {
  static final _collectionName = "members";
  static Firestore _firestore;

  static Firestore get firestoreInstance {
    if (_firestore == null) {
      _firestore = Firestore.instance;
    }

    return _firestore;
  }

  static Future<Null> saveEnrollment(EnrollmentUser user) async {
    return await firestoreInstance.collection(_collectionName).add(user.toMap());  
  }
}
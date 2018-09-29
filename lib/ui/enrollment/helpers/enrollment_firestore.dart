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

  static Future<void> saveEnrollment(EnrollmentUserData user) {
    return firestoreInstance.collection(_collectionName).document(user.id).setData(user.toMap()); 
  }

  static Future<void> deleteEnrollment(String id) {
    return firestoreInstance.collection(_collectionName).document(id).delete();
  }

  static Future<DocumentSnapshot> getEnrollment(String id) {
    return firestoreInstance.collection(_collectionName).document(id).get();
  }

  static Future<QuerySnapshot> getAllEnrollments() {
    return firestoreInstance.collection(_collectionName).orderBy("name").getDocuments();
  }
}
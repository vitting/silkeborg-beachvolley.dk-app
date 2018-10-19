import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/helpers/enrollmentExists.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/helpers/enrollment_user_data_class.dart';

class EnrollmentFirestore {
  static final _collectionName = "members";
  static Firestore _firestore = Firestore.instance;

  static Future<void> saveEnrollment(EnrollmentUserData user) {
    return _firestore
        .collection(_collectionName)
        .document(user.id)
        .setData(user.toMap());
  }

  static Future<void> deleteEnrollment(String id) {
    return _firestore.collection(_collectionName).document(id).delete();
  }

  static Future<DocumentSnapshot> getEnrollment(String id) {
    return _firestore.collection(_collectionName).document(id).get();
  }

  static Future<QuerySnapshot> getAllEnrollments() {
    return _firestore
        .collection(_collectionName)
        .orderBy("name")
        .getDocuments();
  }

  static Future<QuerySnapshot> getAllEnrollmentsAddedByUserId(String id) {
    return _firestore
        .collection(_collectionName)
        .where("addedByUserId", isEqualTo: id)
        .orderBy("name")
        .getDocuments();
  }

  static Future<EnrollmentExistsResult> checkIfEmailExists(String email) async {
    EnrollmentExistsResult result = EnrollmentExistsResult();
    QuerySnapshot snapshot = await _firestore
        .collection(_collectionName)
        .where("email", isEqualTo: email)
        .getDocuments();

    if (snapshot.documents.isNotEmpty) {
      result.exists = true;
      result.count = snapshot.documents.length;
    }
    return result;
  }

  static Future<EnrollmentExistsResult> checkIfPhoneExists(int phone) async {
    EnrollmentExistsResult result = EnrollmentExistsResult();
    QuerySnapshot snapshot = await _firestore
        .collection(_collectionName)
        .where("phone", isEqualTo: phone)
        .getDocuments();

    if (snapshot.documents.isNotEmpty) {
      result.exists = true;
      result.count = snapshot.documents.length;
    }
    return result;
  }

  static Future<EnrollmentExists> checkIfExists(String email, int phone) async {
    EnrollmentExistsResult emailResult =
        await EnrollmentFirestore.checkIfEmailExists(email);
    EnrollmentExistsResult phoneResult =
        await EnrollmentFirestore.checkIfPhoneExists(phone);
    return EnrollmentExists(
        emailExists: emailResult.exists,
        emailCount: emailResult.count,
        phoneExists: phoneResult.exists,
        phoneCount: phoneResult.count);
  }
}

class EnrollmentExistsResult {
  bool exists;
  int count;

  EnrollmentExistsResult({this.exists = false, this.count = 0});
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silkeborgbeachvolley/helpers/postcal_codes_data.dart';

class PostalCodesFirestore {
  static Firestore _firestore;
  static String _collectionName = "postalcodes";

  static Firestore get firestoreInstance {
    if (_firestore == null) {
      _firestore = Firestore.instance;
    }
    return _firestore;
  }

  static Future<DocumentSnapshot> getCity(int postalCode) {
    return firestoreInstance
        .collection(_collectionName)
        .document(postalCode.toString())
        .get();
  }

  static Future<void> setPostalCode(PostalCode item) {
    return firestoreInstance
        .collection(_collectionName)
        .document(item.postalCode.toString())
        .setData(item.toMap());
  }

  static Future<void> deletePostalCode(int postalCode) {
    return firestoreInstance
        .collection(_collectionName)
        .document(postalCode.toString())
        .delete();
  }

  static Future<QuerySnapshot> getAllPostalCodes() {
    return firestoreInstance.collection(_collectionName).getDocuments();
  }
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:silkeborgbeachvolley/helpers/postal_codes_firestore.dart';

class PostalCode {
  int postalCode;
  String city;

  PostalCode({@required this.postalCode, @required this.city});

  Map<String, dynamic> toMap() {
    return {
      "postalCode": postalCode,
      "city": city
    };
  }

  factory PostalCode.fromMap(dynamic item) {
    return PostalCode(
      postalCode: int.parse(item["nr"]),
      city: item["navn"]
    );
  }

  Future<void> save() {
    return PostalCodesFirestore.setPostalCode(this);
  }

  Future<void> delete() {
    return PostalCodesFirestore.deletePostalCode(this.postalCode);
  }

  static Future<List<PostalCode>> getAllPostalCodes() async {
    QuerySnapshot snapshot = await PostalCodesFirestore.getAllPostalCodes();

    return snapshot.documents.map<PostalCode>((DocumentSnapshot doc) {
      return PostalCode.fromMap(doc.data);
    }).toList();
  }

  static Future<String> getCity(int postalCode) async {
    String city = "";
    DocumentSnapshot snapshot = await PostalCodesFirestore.getCity(postalCode);

    if (snapshot.exists) {
      city = snapshot.data["city"];
    }

    return city;
  }
}
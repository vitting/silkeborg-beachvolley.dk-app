import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/user_firestore.dart';
import 'package:silkeborgbeachvolley/helpers/user_info_class.dart';
import 'package:silkeborgbeachvolley/helpers/uuid_helpers.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/helpers/enrollment_firestore.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/helpers/enrollment_payment_data.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';

class EnrollmentUserData {
  String id;
  String addedByUserId;
  dynamic creationDate;
  String name;
  String street;
  int postalCode;
  DateTime birthdate;
  String email;
  int phone;
  List<EnrollmentPaymentData> payment;

  EnrollmentUserData({this.addedByUserId, this.id, this.creationDate, this.name, this.street, this.postalCode, this.birthdate, this.email, this.phone, this.payment});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "addedByUserId": addedByUserId,
      "creationDate": creationDate,
      "name": name,
      "street": street,
      "postalCode": postalCode,
      "birthday": birthdate,
      "email": email,
      "phone": phone,
      "payment": payment == null ? [] : payment.map<Map<String, dynamic>>((EnrollmentPaymentData data) {
        return data.toMap();
      }).toList()
    };
  }

  int get age => DateTimeHelpers.getAge(birthdate);

  Future<String> get addedByUserName async {
    String name = "Ikke tilføjet af en bruger";
    if (addedByUserId.isNotEmpty) {
      DocumentSnapshot snapshot = await UserFirestore.getUserInfo(addedByUserId);
      if (snapshot.exists) {
        UserInfoData userInfoData = UserInfoData.fromMap(snapshot.data);
        name = userInfoData.name;
      }
    }
      
    return name;
  }

  Future<void> save() {
    id = id ?? UuidHelpers.generateUuid();
    addedByUserId = Home.loggedInUser?.uid;
    creationDate = creationDate ?? FieldValue.serverTimestamp();
    payment = payment ?? [];
    return EnrollmentFirestore.saveEnrollment(this);
  }

  Future<void> delete() {
    return EnrollmentFirestore.deleteEnrollment(id);
  }

  static Future<EnrollmentUserData> get(String id) async {
    EnrollmentUserData data;
    DocumentSnapshot snapshot = await EnrollmentFirestore.getEnrollment(id);

    if (snapshot.exists) {
      data = EnrollmentUserData.fromMap(snapshot.data);
    }

    return data;
  }

  static Future<List<EnrollmentUserData>> getAll() async {
    QuerySnapshot snapshot = await EnrollmentFirestore.getAllEnrollments();
    return snapshot.documents.map<EnrollmentUserData>((DocumentSnapshot doc) {
      return EnrollmentUserData.fromMap(doc.data);
    }).toList();
  }

  factory EnrollmentUserData.fromMap(Map<String, dynamic> item) {
    return EnrollmentUserData(
      id: item["id"] ?? "",
      addedByUserId: item["addedByUserId"],
      creationDate: item["CreatedDate"] ?? DateTime.now(),
      name: item["name"] ?? "",
      street: item["street"] ?? "",
      postalCode: item["postalCode"] ?? 0,
      birthdate: item["birthday"] ?? DateTime.now(),
      email: item["email"] ?? "",
      phone: item["phone"] ?? 0,
      payment: item["payment"] == null ? [] : (item["payment"] as List<dynamic>).map<EnrollmentPaymentData>((dynamic value) {
        return EnrollmentPaymentData(
          approvedUserId: value["approvedUserId"],
          date: value["date"]
        );
      }).toList()
    );
  }
}
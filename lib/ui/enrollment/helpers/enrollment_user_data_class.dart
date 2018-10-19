import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/user_firestore.dart';
import 'package:silkeborgbeachvolley/helpers/user_info_data.dart';
import 'package:silkeborgbeachvolley/helpers/uuid_helpers.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/helpers/enrollmentExists.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/helpers/enrollment_firestore.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/helpers/enrollment_payment_data.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';

class EnrollmentUserData {
  String id;
  String addedByUserId;
  Timestamp creationDate;
  String name;
  String street;
  int postalCode;
  String city;
  DateTime birthdate;
  String email;
  int phone;
  String comment;
  List<EnrollmentPaymentData> payment;

  EnrollmentUserData(
      {this.addedByUserId,
      this.id,
      this.creationDate,
      this.name,
      this.street,
      this.postalCode,
      this.city,
      this.birthdate,
      this.email,
      this.phone,
      this.payment,
      this.comment = ""});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "addedByUserId": addedByUserId,
      "creationDate": creationDate,
      "name": name,
      "street": street,
      "postalCode": postalCode,
      "city": city,
      "birthday": Timestamp.fromDate(birthdate),
      "email": email,
      "phone": phone,
      "comment": comment,
      "payment": payment == null
          ? []
          : payment.map<Map<String, dynamic>>((EnrollmentPaymentData data) {
              return data.toMap();
            }).toList()
    };
  }

  Future<void> refresh() async {
    DocumentSnapshot snapshot = await EnrollmentFirestore.getEnrollment(id);
    if (snapshot.exists) {
      Map<String, dynamic> item = snapshot.data;
      id = item["id"];
      addedByUserId = item["addedByUserId"];
      creationDate = item["creationDate"];
      name = item["name"];
      street = item["street"];
      postalCode = item["postalCode"];
      city = item["city"];
      birthdate = (item["birthday"] as Timestamp).toDate();
      email = item["email"];
      phone = item["phone"];
      comment = item["comment"] ?? "";
      payment = item["payment"] == null
          ? []
          : (item["payment"] as List<dynamic>)
              .map<EnrollmentPaymentData>((dynamic value) {
              return EnrollmentPaymentData(
                  approvedUserId: value["approvedUserId"],
                  createdDate: value["createdDate"],
                  year: value["year"],
                  comment: value["comment"] ?? "");
            }).toList();
    }
  }

  List<EnrollmentPaymentData> get paymentSorted {
    payment.sort((EnrollmentPaymentData data1, EnrollmentPaymentData data2) {
      return data2.year.compareTo(data1.year);
    });

    return payment;
  }

  void addPayment(int year, {String comment = ""}) {
    payment.add(EnrollmentPaymentData(year: year, comment: comment));
  }

  bool paymentExists(int year) {
    return payment.any((EnrollmentPaymentData data) {
      if (data.year == year) return true;
      return false;
    });
  }

  int get age => DateTimeHelpers.getAge(birthdate);

  Future<String> get addedByUserName async {
    String name = "Not added by a user";
    if (addedByUserId.isNotEmpty) {
      DocumentSnapshot snapshot =
          await UserFirestore.getUserInfo(addedByUserId);
      if (snapshot.exists) {
        UserInfoData userInfoData = UserInfoData.fromMap(snapshot.data);
        name = userInfoData.name;
      }
    }

    return name;
  }

  Future<EnrollmentExists> checkIfValuesExists() {
    return EnrollmentFirestore.checkIfExists(email, phone);
  }

  Future<void> save() {
    id = id ?? UuidHelpers.generateUuid();
    addedByUserId = Home.loggedInUser?.uid;
    creationDate = creationDate ?? Timestamp.now();
    payment = payment ?? [];
    comment = comment ?? "";
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

  static Future<List<EnrollmentUserData>> getAllAddedByUser() async {
    QuerySnapshot snapshot =
        await EnrollmentFirestore.getAllEnrollmentsAddedByUserId(
            Home.loggedInUser.uid);
    return snapshot.documents.map<EnrollmentUserData>((DocumentSnapshot doc) {
      return EnrollmentUserData.fromMap(doc.data);
    }).toList();
  }

  factory EnrollmentUserData.fromMap(Map<String, dynamic> item) {
    return EnrollmentUserData(
        id: item["id"] ?? "",
        addedByUserId: item["addedByUserId"],
        creationDate: item["creationDate"],
        name: item["name"] ?? "",
        street: item["street"] ?? "",
        postalCode: item["postalCode"] ?? 0,
        city: item["city"] ?? "",
        birthdate: (item["birthday"] as Timestamp).toDate(),
        email: item["email"] ?? "",
        phone: item["phone"] ?? 0,
        comment: item["comment"] ?? "",
        payment: item["payment"] == null
            ? []
            : (item["payment"] as List<dynamic>)
                .map<EnrollmentPaymentData>((dynamic value) {
                return EnrollmentPaymentData(
                    approvedUserId: value["approvedUserId"],
                    createdDate: value["createdDate"],
                    year: value["year"],
                    comment: value["comment"] ?? "");
              }).toList());
  }
}

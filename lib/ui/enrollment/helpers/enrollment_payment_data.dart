import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class EnrollmentPaymentData {
  Timestamp createdDate;
  String approvedUserId;
  final int year;
  String comment;
  EnrollmentPaymentData(
      {@required this.year,
      this.comment = "",
      this.createdDate,
      this.approvedUserId});

  Map<String, dynamic> toMap(String userId) {
    return {
      "createdDate": createdDate ?? Timestamp.now(),
      "approvedUserId": approvedUserId ?? userId,
      "year": year,
      "comment": comment
    };
  }

  factory EnrollmentPaymentData.formMap(Map<String, dynamic> item) {
    return EnrollmentPaymentData(
        createdDate: item["createdDate"],
        approvedUserId: item["approvedUserId"],
        year: item["year"],
        comment: item["comment"] ?? "");
  }
}

import 'package:meta/meta.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';

class EnrollmentPaymentData {
  dynamic createdDate;
  String approvedUserId;
  final int year;
  String comment;
  EnrollmentPaymentData(
      {@required this.year,
      this.comment = "",
      this.createdDate,
      this.approvedUserId});

  Map<String, dynamic> toMap() {
    return {
      "createdDate": createdDate ?? DateTime.now(),
      "approvedUserId": approvedUserId ?? Home.loggedInUser.uid,
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

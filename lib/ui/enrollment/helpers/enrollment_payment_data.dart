class EnrollmentPaymentData {
  DateTime date;
  String approvedUserId;
  EnrollmentPaymentData({this.approvedUserId = "", this.date});

  Map<String, dynamic> toMap() {
    return {
      "date": date ?? DateTime.now(),
      "approvedUserId": approvedUserId
    };
  }

  factory EnrollmentPaymentData.formMap(Map<String, dynamic> item) {
    return EnrollmentPaymentData(
      date: item["date"],
      approvedUserId: item["approvedUserId"]
    );
  }
}
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';

class EnrollmentUser {
  DateTime createdDate;
  String name;
  String street;
  int postalCode;
  DateTime birthdate;
  String email;
  int phone;
  List<int> paiedYears;

  EnrollmentUser({this.createdDate, this.name = "", this.street = "", this.postalCode = 0, this.birthdate, this.email = "", this.phone = 0, this.paiedYears});

  Map<String, dynamic> toMap() {
    return {
      "createdDate": createdDate == null ? DateTime.now() : createdDate,
      "name": name,
      "street": street,
      "postalCode": postalCode,
      "birthday": birthdate == null ? DateTime.now() : birthdate,
      "email": email,
      "phone": phone,
      "paiedYears": paiedYears == null ? [] : paiedYears
    };
  }

  int get age => DateTimeHelpers.getAge(birthdate);

  static EnrollmentUser fromMap(Map<String, dynamic> user) {
    return EnrollmentUser(
      createdDate: user["CreatedDate"] == null ? DateTime.now() : user["CreatedDate"],
      name: user["name"] == null ? "" : user["name"],
      street: user["street"] == null ? "" : user["street"],
      postalCode: user["postalCode"] == null ? 0 : user["postalCode"],
      birthdate: user["birthday"] == null ? DateTime.now() : user["birthday"],
      email: user["email"] == null ? "" : user["email"],
      phone: user["phone"] == null ? 0 : user["phone"],
      paiedYears: user["paiedYears"] == null ? [] : user["paiedYears"]
    );
  }
}
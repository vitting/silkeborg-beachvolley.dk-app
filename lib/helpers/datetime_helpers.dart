import 'package:date_format/date_format.dart';

Map<int, String> months = {
  1: "Januar",
  2: "Februar",
  3: "Marts",
  4: "April",
  5: "Maj",
  6: "Juni",
  7: "Juli",
  8: "August",
  9: "September",
  10: "Oktober",
  11: "November",
  12: "December"
};

class DateTimeHelpers {
  static int weekInYear(DateTime date) {
    return int.parse(formatDate(date, [W]));
  }

  static String ddmmyyyyHHnn(DateTime date) {
    return formatDate(date, [dd, "-", mm, "-", yyyy, "  ", HH, ":", nn]);
  }

  static String ddmmyyyy(DateTime date) {
    return formatDate(date, [dd, "-", mm, "-", yyyy]);
  }

  static String ddMMyyyy(DateTime date) {
    return formatDate(date, [dd, ". ", months[date.month], " ", yyyy]);
  }

  static String hhnn(DateTime date) {
    return formatDate(date, [HH, ":", nn]);
  }

  static bool dateCompare(DateTime date1, DateTime date2) {
    DateTime a = DateTime(date1.year, date1.month, date1.day);
    DateTime b = DateTime(date2.year, date2.month, date2.day);

    return a.compareTo(b) == 0 ? true : false;
  }

  static int getAge(DateTime birthdate) {
    if (birthdate == null) return 0;
    
    DateTime today = DateTime.now();
    int years = today.year - birthdate.year;
    int age;
    if (birthdate.month <= today.month) {
      if (today.day < birthdate.day) {
        age = years - 1;
      } else
        age = years;
    } else {
      age = years - 1;
    }

    return age;
  }

  static bool isVvalidDateFormat(String dateString) {
    RegExp reg = RegExp(r"^[0-3]\d-[0-1]\d-[1-2][09]\d\d$");
    return reg.hasMatch(dateString);
  }
}

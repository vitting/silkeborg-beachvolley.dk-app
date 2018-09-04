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

class DateTimeFormatters {
  static String ddmmyyyyHHnn(DateTime date) {
    return formatDate(date, [dd, "-", mm, "-", yyyy, "  " , HH, ":", nn]);
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


}
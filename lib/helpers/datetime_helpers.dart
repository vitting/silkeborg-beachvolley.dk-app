import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

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

Map<int, String> monthsShort = {
  1: "jan.",
  2: "feb.",
  3: "mar.",
  4: "apr.",
  5: "maj",
  6: "jun.",
  7: "jul.",
  8: "aug.",
  9: "sept.",
  10: "okt.",
  11: "nov.",
  12: "dec."
};

class DateTimeHelpers {
  static int weekInYear(DateTime date) {
    return int.parse(formatDate(date, [W]));
  }

  static String ddmmyyyyHHnn(DateTime date) {
    try {
      return formatDate(date, [dd, "-", mm, "-", yyyy, "  ", HH, ":", nn]);  
    } catch (e) {
      print("DateTimeHelpers.ddmmyyyyHHnn : $e");
      return "";
    }
    
  }

  static String ddmmyyyy(DateTime date) {
    return formatDate(date, [dd, "-", mm, "-", yyyy]);
  }

  static String ddMMyyyy(DateTime date) {
    return formatDate(date, [dd, ". ", monthsShort[date.month], " ", yyyy]);
  }

  static String ddMM(DateTime date) {
    return formatDate(date, [dd, ". ", monthsShort[date.month]]);
  }

  static String hhnn(dynamic date) {
    DateTime dateToFormat;
    if (date is TimeOfDay) {
      TimeOfDay tod = date;
      dateToFormat = DateTime(2000, 1, 1, tod.hour, tod.minute);
    } else {
      dateToFormat = date;
    }
    return formatDate(dateToFormat, [HH, ":", nn]);
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

import 'package:date_format/date_format.dart';

class DateTimeFormatters {
  static String formatDateDDMMYYYHHNN(DateTime date) {
    return formatDate(date, [dd, "-", mm, "-", yyyy, "  " , HH, ":", nn]);
  }
}
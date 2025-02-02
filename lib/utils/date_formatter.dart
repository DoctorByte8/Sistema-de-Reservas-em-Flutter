import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }
  static DateTime parseDate(String dateString) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.parse(dateString);
  }
  static int calculateDaysDifference(DateTime checkin, DateTime checkout) {
    return checkout.difference(checkin).inDays + 1;
  }
  static bool isValidDateRange(DateTime checkin, DateTime checkout) {
    return checkout.isAfter(checkin);
  }
}

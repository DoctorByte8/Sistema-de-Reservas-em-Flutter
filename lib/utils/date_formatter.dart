import 'package:intl/intl.dart';

class DateFormatter {
  // Formata uma data no formato "dd/MM/yyyy"
  static String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  // Converte uma string no formato "dd/MM/yyyy" para um objeto DateTime
  static DateTime parseDate(String dateString) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.parse(dateString);
  }

  // Calcula a diferença em dias entre duas datas
  static int calculateDaysDifference(DateTime checkin, DateTime checkout) {
    return checkout.difference(checkin).inDays + 1; // Inclui o dia do check-in
  }

  // Verifica se a data de check-out é posterior à data de check-in
  static bool isValidDateRange(DateTime checkin, DateTime checkout) {
    return checkout.isAfter(checkin);
  }
}

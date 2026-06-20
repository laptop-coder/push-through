import 'package:intl/intl.dart';

class FormatDatetime {
  static String formatDate(String datetimeStr) {
    return (DateFormat('dd.MM.yyyy', 'ru')).format(DateTime.parse(datetimeStr));
  }

  static String formatTime(String datetimeStr) {
    return (DateFormat('hh:mm', 'ru')).format(DateTime.parse(datetimeStr));
  }

  static String formatDateAndTime(String datetimeStr) {
    return (DateFormat(
      'dd.MM.yyyy hh:mm',
      'ru',
    )).format(DateTime.parse(datetimeStr));
  }
}

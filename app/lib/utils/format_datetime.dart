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

  static String formatDateRelativeToToday(DateTime datetime) {
    final dateToCompare = DateTime(datetime.year, datetime.month, datetime.day);

    final now = DateTime.now().toUtc();
    final today = DateTime(now.year, now.month, now.day);
    final diff = today.difference(dateToCompare).abs().inDays;

    switch (diff) {
      case 0:
        return 'сегодня';
      case 1:
        return 'вчера';
      case 2:
        return 'позавчера';
      case <= 7 + 6:
        return 'неделю назад';
      case <= 2 * 7 + 6:
        return 'две недели назад';
      case <= 3 * 7 + 6:
        return 'три недели назад';
      case <= 30 + 27:
        return 'месяц назад';
      case <= 2 * 30 + 27:
        return 'два месяца назад';
      case <= 3 * 30 + 27:
        return 'три месяца назад';
      case <= 4 * 30 + 27:
        return 'четыре месяца назад';
      case <= 5 * 30 + 27:
        return 'пять месяцев назад';
      case <= 11 * 30 + 27:
        return 'полгода назад';
      case <= 365 + 364:
        return 'год назад';
      case <= 2 * 365 + 364:
        return 'два года назад';
      case <= 3 * 365 + 364:
        return 'три года назад';
      case <= 4 * 365 + 364:
        return 'четыре года назад';
      case <= 5 * 365:
        return 'пять лет назад';
      default:
        return 'больше пяти лет назад';
    }
  }
}

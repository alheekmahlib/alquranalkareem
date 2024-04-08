import 'package:intl/intl.dart';

class DateFormatter {
  /// example 4:10 AM
  static String justTime(DateTime dateTime) {
    final hour = DateFormat('hh').format(dateTime);
    final minute = DateFormat('mm').format(dateTime);
    final period = DateFormat('a').format(dateTime);
    return '$hour.$minute $period';
  }

  /// example Apr 7, 2024
  static String justDate(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  /// example Apr 7, 2024, 8:00 PM
  static String dateAndTime(DateTime dateTime) {
    return DateFormat.yMMMd().add_jm().format(dateTime);
  }
}

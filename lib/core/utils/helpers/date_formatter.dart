import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../services/languages/localization_controller.dart';

class DateFormatter {
  static String _locale =
      Get.find<LocalizationController>().locale.languageCode;

  /// Formats the given [dateTime] to just time (hour and minute) in the user's time zone.
  /// Example: 4:10 AM (English), ٤:١٠ ص (Arabic)
  static Future<String> justTime(DateTime dateTime) async {
    final userDateTime = await _convertToUserTimeZone(dateTime);
    final hour = DateFormat('hh', _locale).format(userDateTime);
    final minute = DateFormat('mm', _locale).format(userDateTime);
    final period = DateFormat('a', _locale).format(userDateTime);
    return '$hour:$minute ${period}';
  }

  /// Formats the given [dateTime] to just date in the user's time zone.
  /// Example: Apr 7, 2024
  static Future<String> justDate(DateTime dateTime) async {
    final userDateTime = await _convertToUserTimeZone(dateTime);
    return DateFormat.yMMMd(_locale).format(userDateTime);
  }

  /// Formats the given [dateTime] to date and time in the user's time zone.
  /// Example: Apr 7, 2024, 8:00 PM
  static Future<String> dateAndTime(DateTime dateTime) async {
    final userDateTime = await _convertToUserTimeZone(dateTime);
    return DateFormat.yMMMd(_locale).add_jm().format(userDateTime);
  }

  /// Converts the given [dateTime] to the user's time zone.
  static Future<tz.TZDateTime> _convertToUserTimeZone(DateTime dateTime) async {
    final userTimeZone = await _getUserTimeZone();
    return tz.TZDateTime.from(dateTime, userTimeZone);
  }

  /// Get the user's time zone
  static Future<tz.Location> _getUserTimeZone() async {
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    return tz.getLocation(currentTimeZone);
  }

  static String formatPrayerTime(DateTime? time) {
    if (time == null) return "";
    // Customize the format as needed
    return DateFormat('h:mm a', _locale).format(time);
  }

  static String timeLeft(DateTime? time) {
    if (time == null) return "";
    // Customize the format as needed
    return DateFormat('hh:mm', _locale).format(time);
  }
}

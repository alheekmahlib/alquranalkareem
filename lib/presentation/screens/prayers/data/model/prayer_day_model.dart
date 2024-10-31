// TODO: Relocate this class to adhan feature folder
import 'package:hijri/hijri_calendar.dart';

class PrayerDay {
  final DateTime date;
  final DateTime fajr;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;
  final HijriCalendar hijriDate;

  PrayerDay({
    required this.date,
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.hijriDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'fajr': {'hour': fajr.hour, 'minute': fajr.minute},
      'dhuhr': {'hour': dhuhr.hour, 'minute': dhuhr.minute},
      'asr': {'hour': asr.hour, 'minute': asr.minute},
      'maghrib': {'hour': maghrib.hour, 'minute': maghrib.minute},
      'isha': {'hour': isha.hour, 'minute': isha.minute},
      'hijriDate': {
        'hYear': hijriDate.hYear,
        'hMonth': hijriDate.hMonth,
        'hDay': hijriDate.hDay
      },
    };
  }
}

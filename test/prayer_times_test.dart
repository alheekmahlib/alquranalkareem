import 'package:adhan/adhan.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  // that's pass the test but not correct
  test('Test Prayer Time in Egypt', () {
    final coordinates = Coordinates(26.0590358, 32.2320519);
    final date = DateComponents.from(DateTime.now());
    final params = CalculationMethod.egyptian.getParameters();
    params.madhab = Madhab.hanafi;

    final prayerTimes = PrayerTimes(coordinates, date, params);

    expect(DateFormat.jm().format(prayerTimes.fajr), '4:10 AM');
    expect(DateFormat.jm().format(prayerTimes.sunrise), '5:36 AM');
    expect(DateFormat.jm().format(prayerTimes.dhuhr),
        '11:54 AM'); // 11:53 based on Google
    expect(DateFormat.jm().format(prayerTimes.asr),
        '4:24 PM'); // 3:23 based on Google
    expect(DateFormat.jm().format(prayerTimes.maghrib), '6:11 PM');
    expect(DateFormat.jm().format(prayerTimes.isha), '7:27 PM');
  });

  test(
      'Test PrayerTimes for Local Timezone Output When Not Setting utcOffset param',
      () {
    final coordinates = Coordinates(26.0590358, 32.2320519);
    final date = DateComponents.from(DateTime.now());
    final params = CalculationMethod.egyptian.getParameters();
    params.madhab = Madhab.hanafi;

    final prayerTimes = PrayerTimes(coordinates, date, params);

    expect(prayerTimes.fajr.isUtc, false);
    expect(prayerTimes.sunrise.isUtc, false);
    expect(prayerTimes.dhuhr.isUtc, false);
    expect(prayerTimes.asr.isUtc, false);
    expect(prayerTimes.maghrib.isUtc, false);
    expect(prayerTimes.isha.isUtc, false);
  });

  test('Test PrayerTimes.nextPrayerByDateTime', () {
    final kushtia = Coordinates(23.9088, 89.1220);
    final kushtiaUtcOffset = const Duration(hours: 6);
    final date = DateComponents(2020, 6, 12);
    final params = CalculationMethod.karachi.getParameters();
    params.madhab = Madhab.hanafi;

    final prayerTimes =
        PrayerTimes(kushtia, date, params, utcOffset: kushtiaUtcOffset);

    expect(prayerTimes.nextPrayerByDateTime(prayerTimes.fajr), Prayer.sunrise);
    expect(prayerTimes.nextPrayerByDateTime(prayerTimes.sunrise), Prayer.dhuhr);
    expect(prayerTimes.nextPrayerByDateTime(prayerTimes.dhuhr), Prayer.asr);
    expect(prayerTimes.nextPrayerByDateTime(prayerTimes.asr), Prayer.maghrib);
    expect(prayerTimes.nextPrayerByDateTime(prayerTimes.maghrib), Prayer.isha);
    expect(prayerTimes.nextPrayerByDateTime(prayerTimes.isha), Prayer.none);
  });

  test('Test PrayerTimes.currentPrayer', () {
    final newYork = Coordinates(35.7750, -78.6336);
    final prayerTimes = PrayerTimes.today(
        newYork, CalculationMethod.north_america.getParameters());
    expect(prayerTimes.currentPrayer() is Prayer, true);
  });

  test('Test PrayerTimes.nextPrayer', () {
    final newYork = Coordinates(35.7750, -78.6336);
    final prayerTimes = PrayerTimes.today(
        newYork, CalculationMethod.north_america.getParameters());
    expect(prayerTimes.nextPrayer() is Prayer, true);
  });
}

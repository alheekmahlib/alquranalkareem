// ignore_for_file: avoid_print

import 'dart:developer' show log;
import 'dart:io' show Platform;

import 'package:background_fetch/background_fetch.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hijri_date/hijri_date.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../widgets/local_notification/controller/local_notifications_controller.dart';

const String _appGroupId = 'group.com.alheekmah.quran_widget';
const String _androidWidgetName = 'QuranWidget';

// [Android-only] This "Headless Task" is run when the Android app
// is terminated with `enableHeadless: true`
@pragma('vm:entry-point')
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  final taskId = task.taskId;
  if (task.timeout) {
    log("Headless task timed-out: $taskId", name: 'Background service');
    BackgroundFetch.finish(taskId);
    return;
  }
  log('Headless event received: $taskId', name: 'Background service');
  await _executeBackgroundTask(taskId);
  BackgroundFetch.finish(taskId);
}

class BGServices {
  Future<void> registerTask() async {
    await BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);

    // Configure and start BackgroundFetch
    await BackgroundFetch.configure(
          BackgroundFetchConfig(
            minimumFetchInterval: 20,
            stopOnTerminate: false,
            enableHeadless: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.ANY,
          ),
          _onFetch,
          _onTimeOut,
        )
        .then((int status) {
          log("configure success: $status", name: 'Background service');
        })
        .catchError((e) {
          log("configure ERROR: $e", name: 'Background service');
        });

    // Start BackgroundFetch
    await BackgroundFetch.start()
        .then((v) async {
          await _fetchDataAndScheduleNotifications();
          log('Background Service Started $v', name: 'Background service');
        })
        .catchError((e) {
          log('Error on Background Service $e', name: 'Background service');
        });

    // مهمة دورية كل 20 دقيقة (Android فقط — على iOS يكفي configure)
    if (Platform.isAndroid) {
      try {
        await BackgroundFetch.scheduleTask(
          TaskConfig(
            taskId: "com.transistorsoft.fetchNotifications",
            delay: 20 * 60 * 1000, // 20 minutes
            stopOnTerminate: false,
            enableHeadless: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            periodic: true,
            requiredNetworkType: NetworkType.ANY,
          ),
        );
      } catch (e) {
        log("Task Scheduling Error: $e", name: 'Background service');
      }
    }
  }
}

/// المنطق المشترك بين _onFetch و backgroundFetchHeadlessTask
Future<void> _executeBackgroundTask(String taskId) async {
  log("Executing task: $taskId", name: 'Background service');

  await GetStorage.init();
  final storage = GetStorage();

  // مهمة الإشعارات كل 20 دقيقة
  await _fetchDataAndScheduleNotifications();

  // التحقق من تغيّر التاريخ (يوم جديد بعد منتصف الليل)
  final today = DateTime.now().toIso8601String().substring(0, 10);
  final lastDate = storage.read('last_widget_date') as String?;

  if (lastDate == null || lastDate != today) {
    log(
      "New day detected ($lastDate -> $today), updating widget",
      name: 'Background service',
    );
    await _updateWidgetHijriDate(storage);
    storage.write('last_widget_date', today);
  }
}

Future<void> _onFetch(String taskId) async {
  log("Event received $taskId", name: 'Background service');
  await _executeBackgroundTask(taskId);
  BackgroundFetch.finish(taskId);
}

Future<void> _onTimeOut(String taskId) async {
  log("Task timeout: $taskId", name: 'Background service');
  BackgroundFetch.finish(taskId);
}

Future<void> _fetchDataAndScheduleNotifications() async {
  log('Fetching notifications...', name: 'Background service');
  await GetStorage.init();
  await LocalNotificationsController.instance.fetchNewNotifications();
  log('Notifications fetch complete', name: 'Background service');
}

// ─── تحديث بيانات التاريخ الهجري في الـ Widget ───

Future<void> _updateWidgetHijriDate(GetStorage storage) async {
  try {
    if (!Platform.isMacOS) {
      await HomeWidget.setAppGroupId(_appGroupId);
    }

    final adjustDays = storage.read('adjustHijriDays') ?? 0;
    final hijriNow = _getAdjustedHijriDate(adjustDays);

    final now = DateTime.now();
    final locale = (storage.read('lang') as String?) ?? 'ar';
    String gregorianDate;
    try {
      await initializeDateFormatting(locale);
      gregorianDate = '${now.day} ${DateFormat('MMM', locale).format(now)}';
    } catch (_) {
      gregorianDate = '${now.day}/${now.month}';
    }

    final hijriMonthNumber = hijriNow.hMonth.toString();
    final lengthOfMonth = hijriNow.getDaysInMonth(
      hijriNow.hYear,
      hijriNow.hMonth,
    );

    await Future.wait([
      HomeWidget.saveWidgetData<int>('hijri_day', hijriNow.hDay),
      HomeWidget.saveWidgetData<int>('hijri_month', hijriNow.hMonth),
      HomeWidget.saveWidgetData<int>('hijri_year', hijriNow.hYear),
      HomeWidget.saveWidgetData<String>('hijri_month_name', hijriMonthNumber),
      HomeWidget.saveWidgetData<String>('gregorian_date', gregorianDate),
      HomeWidget.saveWidgetData<int>('length_of_month', lengthOfMonth),
    ]);

    // تحديث الـ Widget على المنصة المناسبة
    if (Platform.isIOS) {
      await HomeWidget.updateWidget(iOSName: 'quran_widget');
    }
    if (Platform.isAndroid) {
      await HomeWidget.updateWidget(
        androidName: _androidWidgetName,
        qualifiedAndroidName:
            'com.alheekmah.alquranalkareem.alquranalkareem.$_androidWidgetName',
      );
    }

    log('Widget Hijri date updated successfully', name: 'Background service');
  } catch (e) {
    log('Error updating widget Hijri date: $e', name: 'Background service');
  }
}

HijriDate _getAdjustedHijriDate(int adjustDays) {
  final currentHijri = HijriDate.now();
  var adjustedDay = currentHijri.hDay + adjustDays;
  var adjustedMonth = currentHijri.hMonth;
  var adjustedYear = currentHijri.hYear;

  var daysInMonth = currentHijri.getDaysInMonth(adjustedYear, adjustedMonth);

  while (adjustedDay > daysInMonth) {
    adjustedDay -= daysInMonth;
    adjustedMonth++;
    if (adjustedMonth > 12) {
      adjustedMonth = 1;
      adjustedYear++;
    }
    daysInMonth = currentHijri.getDaysInMonth(adjustedYear, adjustedMonth);
  }

  while (adjustedDay < 1) {
    adjustedMonth--;
    if (adjustedMonth < 1) {
      adjustedMonth = 12;
      adjustedYear--;
    }
    daysInMonth = currentHijri.getDaysInMonth(adjustedYear, adjustedMonth);
    adjustedDay += daysInMonth;
  }

  return HijriDate.fromHijri(adjustedYear, adjustedMonth, adjustedDay);
}

// ignore_for_file: avoid_print

import 'dart:developer' show log;
import 'dart:io' show Platform;

import 'package:background_fetch/background_fetch.dart';
import 'package:get_storage/get_storage.dart';

import '../widgets/local_notification/controller/local_notifications_controller.dart';

// [Android-only] This "Headless Task" is run when the Android app is terminated with `enableHeadless: true`
// Be sure to annotate your callback function to avoid issues in release mode on Flutter >= 3.3.0
@pragma('vm:entry-point')
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    // This task has exceeded its allowed running-time.
    // You must stop what you're doing and immediately .finish(taskId)
    log("Headless task timed-out: $taskId", name: 'Background service');
    BackgroundFetch.finish(taskId);
    return;
  }
  log('Headless event received.', name: 'Background service');
  // Do your work here...
  await _fetchDataAndScheduleNotifications();
  BackgroundFetch.finish(taskId);
}

class BGServices {
  Future<void> registerTask() async {
    // Register the headless task for Android
    // if (Platform.isAndroid) {
    await BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
    // }

    // Configure and start BackgroundFetch
    await BackgroundFetch.configure(
      BackgroundFetchConfig(
        /// [once a day] in minutes 60*24 = 1440
        minimumFetchInterval: 20,
        stopOnTerminate: false,
        enableHeadless: true, // Enable headless task execution
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
        requiredNetworkType: NetworkType.ANY,
      ),
      _onFetch,
      _onTimeOut,
    ).then((int status) {
      log("configure success: $status", name: 'Background service');
    }).catchError((e) {
      log("configure ERROR: $e", name: 'Background service');
    });

    // Start BackgroundFetch
    await BackgroundFetch.start().then((v) async {
      await _fetchDataAndScheduleNotifications();
      log('Background Service Started $v', name: 'Background service');
    }).catchError((e) {
      log('Error Accourd on Background Service $e', name: 'Background service');
    });

    // مهمة كل 20 دقيقة
    try {
      await BackgroundFetch.scheduleTask(
        TaskConfig(
          taskId: "com.transistorsoft.fetchNotifications",
          delay: 20 * 60 * 1000, // 20 minutes
          stopOnTerminate: false,
          enableHeadless: true, // Enable headless task execution
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresStorageNotLow: false,
          requiresDeviceIdle: false,
          periodic: true,
          requiredNetworkType: NetworkType.ANY,
        ),
      );
    } catch (e) {
      if (Platform.isIOS) {
        log("iOS Task Scheduling Error: $e", name: 'Background service');
      } else {
        log("Task Scheduling Error: $e", name: 'Background service');
      }
    }

    // مهمة كل 24 ساعة
    // try {
    //   await BackgroundFetch.scheduleTask(
    //     TaskConfig(
    //       taskId: "com.transistorsoft.fetchEvery24Hours",
    //       delay: 24 * 60 * 60 * 1000, // 24 ساعة بالميلي ثانية
    //       stopOnTerminate: false,
    //       enableHeadless: true,
    //       requiresBatteryNotLow: false,
    //       requiresCharging: false,
    //       requiresStorageNotLow: false,
    //       requiresDeviceIdle: false,
    //       periodic: true,
    //       requiredNetworkType: NetworkType.ANY,
    //     ),
    //   );
    // } catch (e) {
    //   log("Error scheduling 24-hour task: $e", name: 'Background service');
    // }
  }
}

Future<void> _onFetch(String taskId) async {
  log("Event received $taskId", name: 'Background service');

  final now = DateTime.now();
  final storage = GetStorage();

  if (taskId == "com.transistorsoft.fetchNotifications") {
    // تنفيذ المهمة التي تعمل كل 20 دقيقة
    await _handle20MinuteTask();

    // التحقق مما إذا مرت 24 ساعة منذ آخر تشغيل
    final lastRun = storage.read('last_daily_task_run') as String?;
    final lastRunDate = lastRun != null ? DateTime.parse(lastRun) : null;

    if (lastRunDate == null || now.difference(lastRunDate).inHours >= 24) {
      // تنفيذ المهمة اليومية
      await _handleDailyTask();
      storage.write('last_daily_task_run', now.toIso8601String());
    }
  }

  // Signal completion of your task
  BackgroundFetch.finish(taskId);
}

Future<void> _handle20MinuteTask() async {
  log("Executing 20-minute task", name: 'Background service');
  await _fetchDataAndScheduleNotifications();
}

Future<void> _handleDailyTask() async {
  log("Executing daily task", name: 'Background service');
  await _fetchDataAndScheduleNotifications();
}

Future<void>? _onTimeOut(String taskId) async {
  // Task timeout handler
  log("Task timeout taskId: $taskId", name: 'Background service');
  BackgroundFetch.finish(taskId);
}

Future<void> _fetchDataAndScheduleNotifications() async {
  log('=' * 30, name: 'Background service');
  await GetStorage.init();
  await LocalNotificationsController.instance.fetchNewNotifications();
  log('after 20 seconds ${'+' * 20}', name: 'Background service');
}

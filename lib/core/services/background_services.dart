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
    log("[BackgroundFetch] Headless task timed-out: $taskId");
    BackgroundFetch.finish(taskId);
    return;
  }
  log('[BackgroundFetch] Headless event received.');
  // Do your work here...
  await _fetchDataAndScheduleNotifications();
  BackgroundFetch.finish(taskId);
}

class BGServices {
  Future<void> registerTask() async {
    // Register the headless task for Android
    if (Platform.isAndroid) {
      await BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
    }

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
      log("[BackgroundFetch] configure success: $status",
          name: 'BackgroundFetch');
    }).catchError((e) {
      log("[BackgroundFetch] configure ERROR: $e", name: 'Background service');
    });

    // Start BackgroundFetch
    await BackgroundFetch.start().then((v) async {
      await _fetchDataAndScheduleNotifications();
      log('Background Service Started $v', name: 'Background service');
    }).catchError((e) {
      log('Error Accourd on Background Service $e', name: 'Background service');
    });

    try {
      await BackgroundFetch.scheduleTask(
        TaskConfig(
          taskId: "com.transistorsoft.fetchNotifications",
          delay: 24 * 60 * 60 * 1000,
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
  }
}

Future<void> _onFetch(String taskId) async {
  // This is the fetch-event callback for both platforms
  log("Event received $taskId", name: 'Background service');

  // Perform your background task here...
  await _fetchDataAndScheduleNotifications();
  // Signal completion of your task
  BackgroundFetch.finish(taskId);
}

Future<void>? _onTimeOut(String taskId) async {
  // Task timeout handler
  log("Task timeout taskId: $taskId", name: 'Background service');
  BackgroundFetch.finish(taskId);
}

Future<void> _fetchDataAndScheduleNotifications() async {
  log('=' * 30, name: 'Background service');
  await GetStorage.init();
  LocalNotificationsController.instance.fetchAndScheduleNotifications();
  // NotifyHelper().scheduledNotification(
  //   DateTime.now().hashCode,
  //   'Background service',
  //   "Fetch Data And Schedule Notifications",
  // );
  log('after 20 seconds ${'+' * 20}', name: 'Background service');
  Future.delayed(const Duration(seconds: 20)).then(
      (_) => log('after 20 seconds ${'+' * 20}', name: 'Background service'));
}

import 'dart:developer' show log;

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart' show Color, Colors;

import 'notifications_manager.dart';

class NotifyHelper {
  Future<void> displayNotification(
      {required String title, required String body}) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: 10,
      groupKey: 'local_notifications_mg',
      channelKey: 'local_notifications_channel_mg',
      // actionType: ActionType.SilentBackgroundAction,
      actionType: ActionType.KeepOnTop,
      title: title,
      body: body,
      customSound: 'bell',
      autoDismissible: false,
    ));
    // scheduledNotification(DateTime.now().millisecond, title, body);
    scheduledNotification(DateTime.now().millisecond + 2, title, body,
        DateTime.now().add(const Duration(minutes: 2)));
  }

  Future<void> scheduledNotification(int reminderId, String title, String body,
      [DateTime? time, Map<String, String?>? payload]) async {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: reminderId,
        groupKey: 'local_notifications_mg',
        channelKey: 'local_notifications_channel_mg',
        actionType: ActionType.Default,
        title: title,
        body: body,
        payload: payload,
        customSound: 'bell',
        wakeUpScreen: true,
      ),
      schedule: null != time ? NotificationCalendar.fromDate(date: time) : null,
    );
  }

  Future<void> cancelNotification(int notificationId) {
    return AwesomeNotifications().cancelSchedule(notificationId);
  }

  void requestPermissions() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // Get.dialog(
        //     const Text('please allow us to send you helpfull notifications'));
        // This is just a basic example. For real apps, you must show some
        // friendly dialog box before call the request method.
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  static void initAwesomeNotifications() {
    AwesomeNotifications().initialize(
      'resource://drawable/ic_launcher',
      [
        NotificationChannel(
          channelGroupKey: 'local_notifications_channel_group_mg',
          channelKey: 'local_notifications_channel_mg',
          channelName: 'local Notifications',
          channelDescription: 'Notification channel for local',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
        )
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'local_notifications_channel_group_mg',
            channelGroupName: 'Channel Group for local Notifications')
      ],
      debug: false,
    );
  }

  void setNotificationsListeners() {
    // Only after at least the action method is set, the notification events are delivered
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotifyHelper.onActionReceivedMethod,
        onNotificationCreatedMethod: NotifyHelper.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotifyHelper.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotifyHelper.onDismissActionReceivedMethod);
  }

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    log('Notification Created: ${receivedNotification.title}',
        name: 'NotifyHelper');
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    log('notificationDisplayed 2: ${receivedNotification.body}',
        name: 'NotifyHelper');
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    log('Notification Dismessed: ${receivedAction.body}', name: 'NotifyHelper');
    // تحديث حالة التفاعل عندما يتم النقر على الإشعار
    NotificationManager()
        .updateNotificationState(true); // المستخدم تفاعل مع الإشعار
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    log('Received Action: ${receivedAction.body}', name: 'NotifyHelper');
    // تحديث حالة التفاعل عندما يتم تجاهل الإشعار
    NotificationManager()
        .updateNotificationState(false); // المستخدم تجاهل الإشعار
    // Navigate into pages, avoiding to open the notification details page over another details page already opened
    // GeneralController.instance.navigatorKey.currentState?.pushNamedAndRemoveUntil('/notification-page',
    //         (route) => (route.settings.name != '/notification-page') || route.isFirst,
    //     arguments: receivedAction);
  }
}

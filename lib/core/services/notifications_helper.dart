import 'dart:developer' show log;

import 'package:audio_service/audio_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart' show Color, Colors;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';

import '../../presentation/screens/prayers/prayers.dart';
import '../utils/constants/shared_preferences_constants.dart';

class NotifyHelper {
  static AudioPlayer audioPlayer = AudioPlayer()
    ..setAllowsExternalPlayback(false);
  Future<void> displayNotification(
      {required String title, required String body}) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: 10,
      groupKey: 'prayers_notifications_mg',
      channelKey: 'prayers_notifications_channel_mg',
      // actionType: ActionType.SilentBackgroundAction,
      actionType: ActionType.KeepOnTop,
      title: title,
      body: body,
      customSound: 'default',
      autoDismissible: false,
    ));
    // scheduledNotification(DateTime.now().millisecond, title, body);
    scheduledNotification(DateTime.now().millisecond + 2, title, body,
        time: DateTime.now().add(const Duration(minutes: 2)));
  }

  Future<void> scheduledNotification(int reminderId, String title, String body,
      {DateTime? time, Map<String, String?>? payload}) async {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: reminderId,
        groupKey: 'prayers_notifications_mg',
        channelKey: 'prayers_notifications_channel_mg',
        actionType: ActionType.Default,
        title: title,
        body: body,
        payload: payload,
        // customSound: 'nothing' == payload?['sound_type'] ? null : 'default',
        wakeUpScreen: true,
      ),
      schedule: null != time
          ? NotificationCalendar.fromDate(date: time)
          : NotificationCalendar.fromDate(
              date: DateTime.now().add(const Duration(minutes: 1))),
    );
    log('scheduled time: ${NotificationCalendar.fromDate(date: time ?? DateTime.now().add(const Duration(minutes: 1)))}');
  }

  Future<void> cancelNotification(int notificationId) {
    return AwesomeNotifications().cancelSchedule(notificationId);
  }

  void requistPermissions() {
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
      'resource://drawable/ic_notification',
      [
        NotificationChannel(
          channelGroupKey: 'prayers_notifications_channel_group_mg',
          channelKey: 'prayers_notifications_channel_mg',
          channelName: 'Prayer Times Notifications',
          channelDescription: 'Notification channel for Prayer Times',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
        )
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'prayers_notifications_channel_group_mg',
            channelGroupName: 'Channel Group for Prayer Times Notifications')
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
    // log('audioPlayer.allowsExternalPlayback : ${audioPlayer.allowsExternalPlayback}',
    //     name: 'NotifyHelper');

    if (receivedNotification.payload?['sound_type'] == 'sound') {
      Get.to(() => OccasionsWidget(), transition: Transition.downToUp);
      Future.delayed(const Duration(seconds: 1)).then((_) => Get.bottomSheet(
          PrayerDetails(
            index: receivedNotification.id!,
            prayerName: receivedNotification.body!,
          ),
          isScrollControlled: true));
      playAudio(receivedNotification.title);
    }
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    log('Notification Dismessed: ${receivedAction.body}', name: 'NotifyHelper');
    audioPlayer.stop();
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    log('Received Action: ${receivedAction.body}', name: 'NotifyHelper');
    audioPlayer.stop();
    // Navigate into pages, avoiding to open the notification details page over another details page already opened
    // GeneralController.instance.navigatorKey.currentState?.pushNamedAndRemoveUntil('/notification-page',
    //         (route) => (route.settings.name != '/notification-page') || route.isFirst,
    //     arguments: receivedAction);
  }

  static Future<void> playAudio(String? title) async {
    final String? audioPath =
        GetStorage('AdhanSounds').read<String?>(ADHAN_PATH);
    if (null != audioPath) {
      log('Audio path is not null: $audioPath', name: 'NotifyHelper');
      try {
        // Set the audio source
        await audioPlayer.setAudioSource(
          AudioSource.file(
            audioPath,
            tag: MediaItem(id: audioPath, title: title ?? 'Adhan Sound'),
          ),
        );
        await audioPlayer.play();
        log('Audio playback started', name: 'NotifyHelper');

        // Listen for completion
        audioPlayer.playerStateStream.listen((state) {
          if (state.processingState == ProcessingState.completed) {
            log('Audio playback completed', name: 'NotifyHelper');
          }
        });
      } catch (e) {
        log('Error during audio playback: $e', name: 'NotifyHelper');
      }
    } else {
      log('Audio path is null', name: 'NotifyHelper');
    }
  }
}

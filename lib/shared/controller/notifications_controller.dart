import 'dart:async' show Timer;
import 'dart:convert' show jsonDecode;
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../database/notificationDatabase.dart';
import '../../screens/postPage.dart';
import '../services/controllers_put.dart';
import '../services/local_notifications.dart';
import '../widgets/widgets.dart';

class NotificationsController extends GetxController {
  late NotifyHelper notifyHelper;
  DateTime now = DateTime.now();

  RxList<Map<String, dynamic>> sentNotifications = <Map<String, dynamic>>[].obs;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Timer? _timer;

  Future<void> initializeLocalNotifications() async {
    print('Initializing local notifications...');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/icon');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse? response) async {
        if (response != null && response.payload != null) {
          debugPrint('notification payload: ' + response.payload!);
        }
        // selectNotificationSubject.add(payload!);
      },
    );
  }

  void selectNotification(String payload) async {
    print('Notification tapped, payload: $payload');
    Navigator.of(generalController.navigatorNotificationKey.currentContext!)
        .push(
      animatNameRoute(
        pushName: '/post',
        myWidget: PostPage(int.parse(payload)),
      ),
    );
  }

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    Get.dialog(Text(body!));
  }

  tz.TZDateTime _nextInstanceOfTenAM(int hour, int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, now.hour, now.minute + 1);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> scheduledNotification(
      int reminderId, int hour, int minutes, String reminderName) async {
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        reminderId,
        'القرآن الكريم - مكتبة الحكمة',
        reminderName,
        _nextInstanceOfTenAM(hour, minutes),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'notificationIdChannel', 'notificationChannel',
              icon: '@drawable/ic_launcher'),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: reminderId.toString(),
      );
    } catch (e) {
      print('Error scheduling notification: $e');
    }

    // Add the notification to the sentNotifications list

    sentNotifications.add({
      'id': reminderId,
      'title': reminderName,
      'hour': hour,
      'minutes': minutes,
      'opened': false, // Add this line
      'timestamp': now, // Add this line
    });
  }

  void updateNotificationStatus() {
    for (var notification in sentNotifications) {
      notification['opened'] = true;
    }
  }

  Future<BlogPost> fetchPostById(int postId) async {
    final response = await http.get(Uri.parse(
        'https://github.com/alheekmahlib/thegarlanded/blob/master/noti.json?raw=true'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);

      // Find the post with the matching postId
      final postJson = jsonResponse.firstWhere((post) => post['id'] == postId,
          orElse: () => null);

      if (postJson != null) {
        return BlogPost.fromJson(postJson);
      } else {
        throw Exception('Failed to find post with id $postId');
      }
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<void> startPeriodicTask() async {
    print('Task triggered on app start');
    final latestPosts = await fetchLatestPosts();
    print('Latest posts: ${latestPosts.toString()}');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.clear();
    int lastSeenPostId = prefs.getInt('lastSeenPostId') ?? 0;

    int newLastSeenPostId = lastSeenPostId;

    for (var post in latestPosts) {
      print('Checking post with id: ${post['id']} and title: ${post['title']}');
      print('Post ID: ${post['id']}, lastSeenPostId: $lastSeenPostId');
      if (post['id'] > lastSeenPostId) {
        int reminderId = post['id'];
        int hour = 10;
        int minutes = 0;
        String reminderName = post['title'];

        print(
            'Scheduling notification for post id: $reminderId, title: $reminderName');
        await scheduledNotification(
            reminderId, hour, minutes, reminderName); // pass context here
        print(
            'Notification scheduled for post id: $reminderId, title: $reminderName');

        // Save the notification data to the SQLite database
        await NotificationDatabaseHelper.instance.insertNotification({
          'id': reminderId,
          'title': reminderName,
          // Add other relevant columns if needed
        });

        if (post['id'] > newLastSeenPostId) {
          newLastSeenPostId = post['id'];
        }
      }
    }

    await prefs.setInt('lastSeenPostId', newLastSeenPostId);
  }

  Future<void> displayNotification({
    required String title,
    required String body,
    required int postId,
  }) async {
    print('doing test');
    sentNotifications.add({'title': title, 'body': body, 'postId': postId});
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'notificationIdChannel',
      'notificationChannel',
      importance: Importance.max,
      icon: '@drawable/ic_launcher',
    );
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: postId.toString(),
    );

    // Add sent notification to the sentNotifications list
    sentNotifications.add({
      'title': title,
      'body': body,
      'postId': postId,
    });
  }

  Future<List<Map<String, dynamic>>> fetchLatestPosts() async {
    final response = await http.get(Uri.parse(
        'https://github.com/alheekmahlib/thegarlanded/blob/master/noti.json?raw=true'));

    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        // Return an empty list if the response body is empty
        return [];
      }

      List<dynamic> jsonResponse = jsonDecode(response.body);
      List<Map<String, dynamic>> posts = jsonResponse
          .map((post) => {
                'id': post['id'],
                'title': post['title'],
                'body': post['body'],
                'isLottie': post['isLottie'],
                'lottie': post['lottie'],
                'isImage': post['isImage'],
                'image': post['image'],
              })
          .toList();

      return posts;
    } else {
      print('Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
      throw Exception('Failed to load posts');
    }
  }

  @override
  void onInit() {
    if (Platform.isIOS || Platform.isAndroid) {
      startPeriodicTask();
    }

    notifyHelper = NotifyHelper();
    notifyHelper.requestIOSPermissions();
    notifyHelper.requestMACPermissions();
    super.onInit();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void initialization() async {
    print('ready in 3...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 2...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 1...');
    await Future.delayed(const Duration(seconds: 1));
    print('go!');
    FlutterNativeSplash.remove();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:theme_provider/theme_provider.dart';

import '../database/notificationDatabase.dart';
import '../services_locator.dart';
import '../shared/controller/general_controller.dart';
import '../shared/utils/constants/lottie.dart';
import '../shared/widgets/widgets.dart';
import 'postPage.dart';

class NotificationScreen extends StatelessWidget {
  final List<Map<String, dynamic>> notifications;
  final Function updateStatus;
  NotificationScreen(
      {super.key, required this.notifications, required this.updateStatus});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateStatus();
    });
    Future<List<Map<String, dynamic>>> loadNotifications() async {
      final dbHelper = NotificationDatabaseHelper.instance;
      final notifications = await dbHelper.queryAllRows();

      return notifications.map((notification) {
        return {
          'id': notification['id'],
          'title': notification['title'],
          'timestamp': notification['timestamp'] != null
              ? DateTime.parse(notification['timestamp'])
              : DateTime.now(), // Set to the current time if null
        };
      }).toList();
    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: Padding(
        padding: const EdgeInsets.only(
            top: 70.0, bottom: 16.0, right: 16.0, left: 16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      border: Border.all(
                          width: 2, color: Theme.of(context).dividerColor)),
                  child: Icon(
                    Icons.close_outlined,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
            ),
            Text(
              'الإشعارات',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'kufi',
                color: Theme.of(context).canvasColor,
              ),
            ),
            SvgPicture.asset(
              'assets/svg/space_line.svg',
              height: 30,
            ),
            const SizedBox(
              height: 16.0,
            ),
            Expanded(
              child: Container(
                height: MediaQuery.sizeOf(context).height,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: loadNotifications(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return notificationLottie(400.0, 400.0);
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (notifications.isEmpty) {
                      return notificationLottie(800.0, 800.0);
                    } else {
                      List<Map<String, dynamic>> notifications = snapshot.data!;
                      return ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final notification = notifications[index];
                          return Container(
                            height: 70,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            child: ListTile(
                              title: Text(
                                notification['title'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'kufi',
                                  color: ThemeProvider.themeOf(context).id ==
                                          'dark'
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                DateFormat('HH:mm')
                                    .format(notification['timestamp']),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'kufi',
                                  color: ThemeProvider.themeOf(context).id ==
                                          'dark'
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              trailing: Icon(
                                Icons.notifications_active,
                                size: 28,
                                color: Theme.of(context).dividerColor,
                              ),
                              onTap: () {
                                Navigator.of(sl<GeneralController>()
                                        .navigatorNotificationKey
                                        .currentContext!)
                                    .push(
                                  animatNameRoute(
                                    pushName: '/post',
                                    myWidget: PostPage(notification['id']),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

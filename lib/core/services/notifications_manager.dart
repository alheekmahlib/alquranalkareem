import 'dart:developer';

import 'package:get/get.dart';

import 'notifications_helper.dart';

class NotificationManager {
  Map<String, int> booksReadingProgress = {};
  Map<String, int> scheduledNotifications = {};
  int ignoredNotifications = 0;
  int interactedNotifications = 0;

  Future<void> updateBookProgress(
      String bookName, String body, int lastPage) async {
    booksReadingProgress[bookName] = lastPage;

    if (scheduledNotifications.containsKey(bookName)) {
      await NotifyHelper()
          .cancelNotification(scheduledNotifications[bookName]!);
    }

    scheduleReadingReminder(bookName, body);
  }

  void scheduleReadingReminder(String bookName, String body) {
    int notificationId = bookName.hashCode;
    log('notificationId: $notificationId', name: 'NotificationManager');
    NotifyHelper()
        .scheduledNotification(
          reminderId: notificationId,
          title: 'reminders'.tr,
          summary: bookName,
          body: body,
          isRepeats: false,
          time: DateTime.now().add(const Duration(days: 1)),
        )
        .then((_) => log('$notificationId\n${'reminders'.tr}\n$body',
            name: 'NotificationManager'));

    // حفظ معرف الإشعار لإلغائه لاحقًا إذا لزم الأمر
    scheduledNotifications[bookName] = notificationId;

    log('Schedule Reading Reminder for $notificationId',
        name: 'NotificationManager');
  }

  void displayReadingProgress() {
    booksReadingProgress.forEach((bookName, lastPage) {
      print('الكتاب: $bookName، آخر صفحة: $lastPage');
    });
  }

  void updateNotificationState(bool interacted) {
    if (interacted) {
      interactedNotifications++;
      ignoredNotifications = 0;
    } else {
      ignoredNotifications++;
    }

    adjustNotifications();
  }

  void adjustNotifications() {
    if (ignoredNotifications >= 3) {
      reduceNotifications();
    } else if (interactedNotifications >= 3) {
      increaseNotifications();
    }
  }

  void reduceNotifications() {
    scheduleLessFrequentNotifications();
  }

  void increaseNotifications() {
    scheduleMoreFrequentNotifications();
  }

  void sendDailyHadith(String hadith) {
    NotifyHelper().scheduledNotification(
      reminderId: DateTime.now().millisecond + 1,
      title: 'reminders'.tr,
      summary: 'حديث اليوم',
      body: hadith,
      isRepeats: false,
      time: DateTime.now().add(const Duration(hours: 8)),
    );
  }

  void scheduleLessFrequentNotifications() {
    NotifyHelper().scheduledNotification(
      reminderId: DateTime.now().millisecond + 1,
      title: 'reminders'.tr,
      summary: 'أكمل القراءة!',
      body: 'لا تنسَ مواصلة قراءة الكتاب الذي توقفت عنده.',
      isRepeats: false,
      time: DateTime.now().add(const Duration(days: 2)),
    );
  }

  void scheduleMoreFrequentNotifications() {
    NotifyHelper().scheduledNotification(
      reminderId: DateTime.now().millisecond + 1,
      title: 'reminders'.tr,
      summary: 'أكمل القراءة!',
      body: 'تذكيرك اليومي بمتابعة قراءة الكتاب.',
      isRepeats: false,
      time: DateTime.now().add(const Duration(days: 1)),
    );

    NotifyHelper().scheduledNotification(
      reminderId: DateTime.now().millisecond + 2,
      title: 'reminders'.tr,
      summary: 'حديث اليوم',
      body: 'لا تفوت حديث اليوم! تابع القراءة.',
      isRepeats: false,
      time: DateTime.now().add(const Duration(days: 1)),
    );
  }

  void sendInactiveUserReminder() {
    NotifyHelper().scheduledNotification(
      reminderId: DateTime.now().millisecond + 2,
      title: 'reminders'.tr,
      summary: 'مرحبًا، لقد مرت فترة منذ آخر دخولك!',
      body: 'لا تنسَ مواصلة التعلم والقراءة.',
      isRepeats: false,
      time: DateTime.now().add(const Duration(days: 7)),
    );
  }
}

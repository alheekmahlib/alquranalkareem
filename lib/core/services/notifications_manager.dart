import 'dart:developer';

import 'package:get/get.dart';

import 'notifications_helper.dart';

class NotificationManager {
  Map<String, int> booksReadingProgress =
      {}; // تخزين حالة تقدم القراءة لكل كتاب
  Map<String, int> scheduledNotifications = {}; // تخزين معرف الإشعار لكل كتاب
  int ignoredNotifications = 0;
  int interactedNotifications = 0;

  // تحديث تقدم القراءة لكل كتاب وجدولة الإشعار
  Future<void> updateBookProgress(
      String bookName, String body, int lastPage) async {
    booksReadingProgress[bookName] = lastPage;

    // إلغاء الإشعار المجدول سابقًا لهذا الكتاب إذا كان موجودًا
    if (scheduledNotifications.containsKey(bookName)) {
      await NotifyHelper()
          .cancelNotification(scheduledNotifications[bookName]!);
    }

    // جدولة إشعار جديد وتحديث معرف الإشعار
    scheduleReadingReminder(bookName, body);
  }

  // جدولة تذكير خاص لكل كتاب
  void scheduleReadingReminder(String bookName, String body) {
    int notificationId = DateTime.now().millisecond + bookName.hashCode;

    // جدولة الإشعار وتخزين معرفه
    NotifyHelper()
        .scheduledNotification(
          notificationId,
          'reminders'.tr,
          body, // 'لقد توقفت عند $type $lastPage في الكتاب $bookName، هل ترغب في المتابعة؟',
          DateTime.now()
              .add(const Duration(days: 1)), // جدولة الإشعار بعد يوم واحد
        )
        .then((_) => log('$notificationId\n${'reminders'.tr}\n$body',
            name: 'NotificationManager'));

    // حفظ معرف الإشعار لإلغائه لاحقًا إذا لزم الأمر
    scheduledNotifications[bookName] = notificationId;

    log('Schedule Reading Reminder for $notificationId',
        name: 'NotificationManager');
  }

  // عرض كل الكتب التي يقرأها المستخدم وتقدمها
  void displayReadingProgress() {
    booksReadingProgress.forEach((bookName, lastPage) {
      print('الكتاب: $bookName، آخر صفحة: $lastPage');
    });
  }

  // تحديث حالة الإشعار بناءً على تفاعل المستخدم
  void updateNotificationState(bool interacted) {
    if (interacted) {
      interactedNotifications++;
      ignoredNotifications = 0; // إعادة تعيين التجاهل
    } else {
      ignoredNotifications++;
    }

    // تحديث سلوك الإشعارات
    adjustNotifications();
  }

  // ضبط الإشعارات حسب تفاعل المستخدم
  void adjustNotifications() {
    if (ignoredNotifications >= 3) {
      // تقليل الإشعارات في حال تم تجاهلها لثلاث مرات متتالية
      reduceNotifications();
    } else if (interactedNotifications >= 3) {
      // زيادة الإشعارات في حال تفاعل المستخدم ثلاث مرات متتالية
      increaseNotifications();
    }
  }

  // تقليل عدد الإشعارات
  void reduceNotifications() {
    // يمكنك تقليل إرسال إشعارات متابعة القراءة أو إرسال إشعارات في أوقات أبعد
    scheduleLessFrequentNotifications();
  }

  // زيادة عدد الإشعارات
  void increaseNotifications() {
    // يمكنك زيادة إرسال إشعارات عن اقتراحات كتب جديدة أو زيادة تذكيرات القراءة
    scheduleMoreFrequentNotifications();
  }

  // إرسال إشعار حديث معين بناءً على يوم محدد
  void sendDailyHadith(String hadith) {
    NotifyHelper().scheduledNotification(
      DateTime.now().millisecond + 1,
      'حديث اليوم',
      hadith,
      DateTime.now().add(const Duration(hours: 8)), // جدولة الإشعار بعد 8 ساعات
    );
  }

  // تقليل وتيرة الإشعارات
  void scheduleLessFrequentNotifications() {
    // إرسال إشعار كل يومين لتذكير المستخدم بالقراءة
    NotifyHelper().scheduledNotification(
      DateTime.now().millisecond + 1,
      'أكمل القراءة!',
      'لا تنسَ مواصلة قراءة الكتاب الذي توقفت عنده.',
      DateTime.now().add(const Duration(days: 2)), // إشعار بعد يومين
    );
  }

  // زيادة وتيرة الإشعارات
  void scheduleMoreFrequentNotifications() {
    // إرسال إشعار كل يوم لتذكير المستخدم بالقراءة أو إرسال حديث يومي
    NotifyHelper().scheduledNotification(
      DateTime.now().millisecond + 1,
      'أكمل القراءة!',
      'تذكيرك اليومي بمتابعة قراءة الكتاب.',
      DateTime.now().add(const Duration(days: 1)), // إشعار بعد يوم
    );

    // يمكن إضافة إشعارات إضافية مثل اقتراح كتاب جديد أو إرسال حديث مختار
    NotifyHelper().scheduledNotification(
      DateTime.now().millisecond + 2,
      'حديث اليوم',
      'لا تفوت حديث اليوم! تابع القراءة.',
      DateTime.now().add(const Duration(days: 1)), // إشعار بعد يوم
    );
  }

  // تذكير المستخدم بالدخول للتطبيق إذا لم يفتح لمدة أسبوع
  void sendInactiveUserReminder() {
    NotifyHelper().scheduledNotification(
      DateTime.now().millisecond + 2,
      'مرحبًا، لقد مرت فترة منذ آخر دخولك!',
      'لا تنسَ مواصلة التعلم والقراءة.',
      DateTime.now()
          .add(const Duration(days: 7)), // إشعار بعد 7 أيام من عدم النشاط
    );
  }
}

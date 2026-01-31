import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:home_widget/home_widget.dart';

import '/core/utils/constants/extensions/convert_number_extension.dart';
import '../../../presentation/screens/calendar/events.dart';

/// كنترولر إدارة home widget للتقويم الهجري
/// Controller for managing Hijri calendar home widget
class HijriHomeWidgetController extends GetxController {
  // إنشاء instance مع GetX pattern
  // Create instance with GetX pattern
  static HijriHomeWidgetController get instance =>
      Get.isRegistered<HijriHomeWidgetController>()
      ? Get.find<HijriHomeWidgetController>()
      : Get.put(HijriHomeWidgetController());

  final eventCtrl = EventController.instance;

  // Widget IDs for Android
  static const String androidWidgetName = 'HijriCalendarWidget';
  static const String groupId = 'group.com.alquranalkareem.widget';

  @override
  void onInit() {
    super.onInit();
    initializeHomeWidget();
  }

  /// تهيئة home widget
  /// Initialize home widget
  Future<void> initializeHomeWidget() async {
    try {
      // تعيين group ID للمشاركة بين التطبيق والـ widget
      // Set group ID for sharing between app and widget
      await HomeWidget.setAppGroupId(groupId);

      // الاستماع لأحداث النقر على الـ widget
      // Listen to widget click events
      HomeWidget.widgetClicked.listen(onWidgetClicked);

      // تحديث بيانات الـ widget فور التهيئة
      // Update widget data on initialization
      await updateHijriWidgetData();

      log(
        'تم تهيئة Home Widget بنجاح - Home Widget initialized successfully',
        name: 'HijriHomeWidgetController',
      );
    } catch (e) {
      log(
        'خطأ في تهيئة Home Widget - Error initializing Home Widget: $e',
        name: 'HijriHomeWidgetController',
      );
    }
  }

  /// تحديث بيانات التقويم الهجري في الـ widget
  /// Update Hijri calendar data in widget
  Future<void> updateHijriWidgetData() async {
    try {
      if (Platform.isAndroid) {
        // الحصول على التاريخ الهجري الحالي
        // Get current Hijri date
        final hijriDate = eventCtrl.hijriNow;

        // أسماء الأيام بالعربية
        // Arabic day names
        final List<String> dayNames = [
          'الأحد',
          'الاثنين',
          'الثلاثاء',
          'الأربعاء',
          'الخميس',
          'الجمعة',
          'السبت',
        ];

        // أسماء الشهور الهجرية
        // Hijri month names
        final List<String> monthNames = [
          'محرم',
          'صفر',
          'ربيع الأول',
          'ربيع الثاني',
          'جمادى الأولى',
          'جمادى الثانية',
          'رجب',
          'شعبان',
          'رمضان',
          'شوال',
          'ذو القعدة',
          'ذو الحجة',
        ];

        // حساب الأيام المتبقية في الشهر بدلاً من اليوم الحالي
        // Calculate remaining days in month instead of current day
        final currentDay = hijriDate.hDay;
        final monthLength = eventCtrl.getLengthOfMonth;
        final remainingDays = monthLength - currentDay;

        // حفظ البيانات في الـ widget
        // Save data to widget
        await HomeWidget.saveWidgetData<String>(
          'hijri_day',
          '${hijriDate.hDay}'.convertNumbersToCurrentLang(),
        );

        await HomeWidget.saveWidgetData<String>(
          'hijri_day_name',
          dayNames[hijriDate.weekDay() - 1],
        );

        await HomeWidget.saveWidgetData<String>(
          'hijri_month',
          monthNames[hijriDate.hMonth - 1],
        );

        await HomeWidget.saveWidgetData<String>(
          'hijri_year',
          '${hijriDate.hYear}'.convertNumbersToCurrentLang(),
        );

        await HomeWidget.saveWidgetData<String>(
          'hijri_month_number',
          '${hijriDate.hMonth}',
        );

        await HomeWidget.saveWidgetData<String>(
          'length_of_month',
          '$monthLength',
        );

        // حفظ الأيام المتبقية للعرض في الويدجت
        // Save remaining days for widget display
        await HomeWidget.saveWidgetData<String>(
          'remaining_days',
          '$remainingDays'.convertNumbersToCurrentLang(),
        );

        // حساب نسبة تقدم الشهر
        // Calculate month progress percentage
        final progress = (currentDay / monthLength * 100).round();
        await HomeWidget.saveWidgetData<String>('month_progress', '$progress');

        // تحديث الـ widget
        // Update widget
        await HomeWidget.updateWidget(androidName: androidWidgetName);

        log(
          'تم تحديث بيانات التقويم الهجري بنجاح - Hijri calendar data updated successfully',
          name: 'HijriHomeWidgetController',
        );
      }
    } catch (e) {
      log(
        'خطأ في تحديث بيانات التقويم الهجري - Error updating Hijri calendar data: $e',
        name: 'HijriHomeWidgetController',
      );
    }
  }

  /// معالجة أحداث النقر على الـ widget
  /// Handle widget click events
  void onWidgetClicked(Uri? uri) {
    if (uri != null) {
      log(
        'تم النقر على Widget: $uri - Widget clicked: $uri',
        name: 'HijriHomeWidgetController',
      );

      // الانتقال إلى شاشة التقويم عند النقر
      // Navigate to calendar screen on click
      if (uri.toString().contains('hijri_calendar')) {
        // يمكن إضافة navigation logic هنا
        // Can add navigation logic here
        // Get.toNamed('/calendar');
      }
    }
  }

  /// تحديث يومي للبيانات
  /// Daily data update
  Future<void> scheduleDailyUpdate() async {
    // يمكن استخدام هذه الدالة مع background task للتحديث اليومي
    // Can use this function with background task for daily updates
    await updateHijriWidgetData();
  }
}

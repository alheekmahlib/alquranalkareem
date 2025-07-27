import 'dart:developer';

import '/core/widgets/home_widget/hijri_home_widget_controller.dart';

/// خدمة إدارة home widgets
/// Home widgets management service
class HomeWidgetService {
  static HomeWidgetService? _instance;
  static HomeWidgetService get instance => _instance ??= HomeWidgetService._();

  HomeWidgetService._();

  final _hijriWidgetCtrl = HijriHomeWidgetController.instance;

  /// تهيئة جميع الـ home widgets
  /// Initialize all home widgets
  Future<void> initializeHomeWidgets() async {
    try {
      log('بدء تهيئة Home Widgets - Starting Home Widgets initialization',
          name: 'HomeWidgetService');

      // تهيئة home widget للتقويم الهجري
      // Initialize Hijri calendar home widget
      await _hijriWidgetCtrl.initializeHomeWidget();

      // تحديث البيانات الأولي
      // Initial data update
      await updateAllWidgets();

      log('تم تهيئة جميع Home Widgets بنجاح - All Home Widgets initialized successfully',
          name: 'HomeWidgetService');
    } catch (e) {
      log('خطأ في تهيئة Home Widgets - Error initializing Home Widgets: $e',
          name: 'HomeWidgetService');
    }
  }

  /// تحديث جميع الـ widgets
  /// Update all widgets
  Future<void> updateAllWidgets() async {
    try {
      log('تحديث جميع Widgets - Updating all widgets',
          name: 'HomeWidgetService');

      // تحديث widget التقويم الهجري
      // Update Hijri calendar widget
      await _hijriWidgetCtrl.updateHijriWidgetData();

      log('تم تحديث جميع Widgets بنجاح - All widgets updated successfully',
          name: 'HomeWidgetService');
    } catch (e) {
      log('خطأ في تحديث Widgets - Error updating widgets: $e',
          name: 'HomeWidgetService');
    }
  }

  /// جدولة التحديث اليومي
  /// Schedule daily update
  Future<void> scheduleDailyUpdate() async {
    try {
      // يمكن استخدام هذه الدالة مع background tasks
      // Can use this function with background tasks
      await _hijriWidgetCtrl.scheduleDailyUpdate();

      log('تم جدولة التحديث اليومي - Daily update scheduled',
          name: 'HomeWidgetService');
    } catch (e) {
      log('خطأ في جدولة التحديث اليومي - Error scheduling daily update: $e',
          name: 'HomeWidgetService');
    }
  }
}

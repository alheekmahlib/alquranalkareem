import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpansionTileManager {
  final Map<String, ExpansibleController> _controllers = {};
  final Map<String, RxBool> _expandedStates = {};

  /// جلب أو إنشاء Controller بالاسم
  ExpansibleController getController(String name) {
    return _controllers.putIfAbsent(name, () => ExpansibleController());
  }

  /// جلب أو إنشاء حالة التوسيع بالاسم
  RxBool getExpandedState(String name) {
    return _expandedStates.putIfAbsent(name, () => false.obs);
  }

  /// هل العنصر موسّع؟
  bool isExpanded(String name) {
    return getExpandedState(name).value;
  }

  /// تبديل حالة التوسيع
  void toggle(String name) {
    final state = getExpandedState(name);
    state.value = !state.value;
    if (state.value) {
      getController(name).expand();
    } else {
      getController(name).collapse();
    }
  }

  /// إغلاق الكل ما عدا واحد (اختياري)
  void collapseAllExcept(String name) {
    for (final entry in _expandedStates.entries) {
      if (entry.key != name && entry.value.value) {
        entry.value.value = false;
        _controllers[entry.key]?.collapse();
      }
    }
  }

  /// تنظيف الموارد
  void dispose() {
    _controllers.clear();
    _expandedStates.clear();
  }
}

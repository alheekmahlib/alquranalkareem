import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

class GlobalKeyManager {
  static final GlobalKeyManager _instance = GlobalKeyManager._internal();
  GlobalKey<SliderDrawerState>? _drawerKey;

  factory GlobalKeyManager() {
    return _instance;
  }

  GlobalKeyManager._internal();

  GlobalKey<SliderDrawerState> get drawerKey {
    _drawerKey ??= GlobalKey<SliderDrawerState>();
    return _drawerKey!;
  }

  void resetDrawerKey() {
    // SchedulerBinding.instance.scheduleTask(() {
    _drawerKey = GlobalKey<SliderDrawerState>();
    // }, Priority.idle);
  }
}

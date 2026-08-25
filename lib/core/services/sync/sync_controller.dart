import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../presentation/screens/books/books.dart';
import '../../../presentation/screens/quran_page/quran.dart';
import '../../utils/constants/sync_constants.dart';
import '../../../presentation/screens/adhkar/controller/adhkar_controller.dart';
import 'sync_service.dart';

/// متحكم مزامنة الأجهزة — حالة قابلة للرصد + تريغرات المزامنة:
/// إطلاق/عودة للتطبيق، debounce بعد الكتابات المحلية، مؤقت خفيف كل 10 دقائق،
/// وزر تحديث يدوي.
class SyncController extends GetxController with WidgetsBindingObserver {
  /// نمط الوصول الموحد في التطبيق — نسخة دائمة تُنشأ عند أول استخدام.
  /// (تسجيل GetIt الـ lazy وحده لا يُنشئ النسخة قبل أول sl<>‎ وهذا لا يحدث).
  static SyncController get instance => Get.isRegistered<SyncController>()
      ? Get.find<SyncController>()
      : Get.put(SyncController(), permanent: true);

  final SyncService syncService = SyncService();

  final roomId = Rxn<String>();
  final deviceCount = 0.obs;
  final isSyncing = false.obs;
  final lastSyncAt = Rxn<int>();
  final lastError = Rxn<String>();

  Timer? _debounceTimer;
  Timer? _pullTimer;
  Timer? _dirtyCheckTimer;
  bool _disposed = false;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    roomId.value = syncService.roomId;
    lastSyncAt.value = syncService.lastSyncAt;
    syncService.onRemoteChangesApplied = _refreshControllers;
    if (syncService.isPaired) {
      _startPullTimer();
      _scheduleInitialSync();
      refreshRoomInfo();
    }
  }

  void _scheduleInitialSync() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!_disposed) _runSync();
    });
  }

  void _startPullTimer() {
    _pullTimer?.cancel();
    _pullTimer = Timer.periodic(const Duration(minutes: 10), (_) => _runSync());
    // فحص محلي خفيف كل 30 ثانية: يدفع كتابات KV (مثل موضع القراءة) التي
    // لا تملك خطاف كتابة فوريًا — بلا شبكة إلا عند وجود تغيير فعلي.
    _dirtyCheckTimer?.cancel();
    _dirtyCheckTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      if (_disposed || isSyncing.value) return;
      if (await syncService.hasLocalChanges()) _runSync();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _runSync();
      refreshRoomInfo();
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused) {
      // لحظة مغادرة التطبيق هي لحظة تبديل الجهاز — ادفع المحلي فورًا.
      _pushIfDirty();
    }
  }

  Future<void> _pushIfDirty() async {
    if (_disposed || isSyncing.value) return;
    if (await syncService.hasLocalChanges()) _runSync();
  }

  Future<void> _runSync() async {
    if (!syncService.isPaired || isSyncing.value) return;
    isSyncing.value = true;
    try {
      await syncService.syncNow();
      lastError.value = null;
    } catch (e) {
      // لا تبتلع الأخطاء بصمت — ظهورها في الكونسول أساسي للتشخيص.
      print('SyncController: sync failed: $e');
      lastError.value = '$e';
    } finally {
      isSyncing.value = false;
      lastSyncAt.value = syncService.lastSyncAt;
    }
  }

  /// تستدعى بعد أي كتابة محلية على بيانات قابلة للمزامنة (علامات/خطط...).
  void onLocalChange() {
    if (!syncService.isPaired) return;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(SyncConstants.pushDebounce, () => _runSync());
  }

  /// مزامنة يدوية من شاشة الإعدادات.
  Future<void> syncNow() => _runSync();

  Future<bool> createGroup() async {
    final result = await syncService.createGroup();
    if (result.ok) {
      roomId.value = result.value;
      lastError.value = null;
      _startPullTimer();
      refreshRoomInfo();
    } else {
      lastError.value = result.value;
    }
    return result.ok;
  }

  Future<bool> joinGroup(String code) async {
    final result = await syncService.joinGroup(code);
    if (result.ok) {
      roomId.value = result.value;
      lastError.value = null;
      _startPullTimer();
      refreshRoomInfo();
      _refreshControllers();
    } else {
      lastError.value = result.value;
    }
    return result.ok;
  }

  Future<void> resetSync() async {
    _debounceTimer?.cancel();
    _pullTimer?.cancel();
    await syncService.resetSync();
    roomId.value = null;
    deviceCount.value = 0;
    lastSyncAt.value = null;
    lastError.value = null;
  }

  Future<void> refreshRoomInfo() async {
    if (!syncService.isPaired) return;
    final info = await syncService.roomInfo();
    if (info != null) deviceCount.value = info.deviceCount;
  }

  void _refreshControllers() {
    if (Get.isRegistered<BookmarksController>()) {
      Get.find<BookmarksController>().getBookmarks();
      Get.find<BookmarksController>().getBookmarksText();
    }
    if (Get.isRegistered<AzkarController>()) {
      Get.find<AzkarController>().getAdhkar();
    }
    if (Get.isRegistered<KhatmahController>()) {
      Get.find<KhatmahController>().loadKhatmas();
    }
    if (Get.isRegistered<BooksBookmarksController>()) {
      Get.find<BooksBookmarksController>().fetchBookmarks();
    }
  }

  @override
  void onClose() {
    _disposed = true;
    _debounceTimer?.cancel();
    _pullTimer?.cancel();
    _dirtyCheckTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }
}

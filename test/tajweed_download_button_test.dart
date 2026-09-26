import 'dart:io';

import 'package:alquranalkareem/core/widgets/tajweed_download_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:quran_library/quran_library.dart';

/// زر تحميل أحكام التجويد: مستودع وهمي يثبّت الحالتين — الخمول والتحميل
/// مع التقدم — دون أي شبكة أو تخزين حقيقي.
class _FakePathProvider extends PathProviderPlatform {
  _FakePathProvider(this.path);

  final String path;

  @override
  Future<String?> getApplicationDocumentsPath() async => path;
}

class _FakeTajweedRepository implements TajweedAyaRepository {
  bool downloaded = false;
  int downloadCalls = 0;

  @override
  bool isDownloaded() => downloaded;

  @override
  Future<void> download({
    required void Function(double progress) onProgress,
  }) async {
    downloadCalls++;
    onProgress(50);
    onProgress(100);
    downloaded = true;
  }

  @override
  Future<TajweedAyahInfo?> getAyahInfo({
    required int surahNumber,
    required int ayahNumber,
  }) async => null;

  @override
  Future<void> prewarmSurah(int surahNumber) async {}
}

void main() {
  final repo = _FakeTajweedRepository();

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final dir = await Directory.systemTemp.createTemp('tajweed_btn_test');
    PathProviderPlatform.instance = _FakePathProvider(dir.path);
    await GetStorage.init();
  });

  setUp(() {
    repo.downloaded = false;
    repo.downloadCalls = 0;
    Get.put(TajweedAyaCtrl(repository: repo));
  });

  tearDown(() {
    Get.delete<TajweedAyaCtrl>();
  });

  // خط الاختبار الافتراضي عريض جدًا؛ نوسّع الزر في حالة التحميل
  // (نص + نسبة مئوية + مؤشر دوران) حتى لا يفيض على العرض الثابت.
  Widget app({double width = 250}) => GetMaterialApp(
    home: Scaffold(
      body: Center(child: TajweedDownloadButton(width: width)),
    ),
  );

  testWidgets('في الخمول: يعرض عنوان التحميل والضغط ينزّل البيانات', (
    tester,
  ) async {
    await tester.pumpWidget(app());
    await tester.pump();

    expect(find.byType(TajweedDownloadButton), findsOneWidget);
    expect(find.text('download'), findsOneWidget);

    await tester.tap(find.byType(TajweedDownloadButton));
    await tester.pumpAndSettle();

    expect(repo.downloadCalls, 1);
    expect(repo.downloaded, isTrue);
    // بعد اكتمال التنزيل يعود العنوان إلى حالته الخاملة
    expect(find.text('download'), findsOneWidget);
  });

  testWidgets('أثناء التحميل: عنوان جارِ التحميل وشريط التقدم', (tester) async {
    final ctrl = TajweedAyaCtrl.instance;
    ctrl.isDownloading.value = true;
    ctrl.downloadProgress.value = 45;

    await tester.pumpWidget(app(width: 600));
    await tester.pump();

    expect(find.text('downloading'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);

    // إنهاء حالة التحميل وتمرير الوقت لتفريغ مؤقتات الحركة/الحفظ.
    // ملاحظة: تصيير نص النسبة ينشئ GeneralController لأول مرة، وonInit
    // فيه Future.delayed ثانية واحدة (Wakelock) يجب أن يُفرَّغ داخل الاختبار.
    ctrl.isDownloading.value = false;
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    await tester.pump(const Duration(seconds: 2));
  });
}

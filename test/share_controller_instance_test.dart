import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import 'package:alquranalkareem/presentation/screens/quran_page/quran.dart';

void main() {
  setUp(() {
    // إسكات استثناء GetStorage/getApplicationDocumentsDirectory في بيئة الاختبار
    TestWidgetsFlutterBinding.ensureInitialized();
    TestWidgetsFlutterBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (call) async => Directory.systemTemp.path,
    );
    Get.reset();
    GetIt.I.reset();
  });

  test(
      'ShareController.instance يظل نفس الكائن بعد إغلاق صفحة المشاركة (محاكاة المشاركة الثانية)',
      () {
    // نفس أسلوب التسجيل في services_locator
    GetIt.I.registerLazySingleton<ShareController>(
      () => Get.put<ShareController>(ShareController(), permanent: true),
    );

    // المشاركة الأولى: الويدجت يمسك instance، وonTap يمسك sl — يجب أن يتطابقا
    final first = ShareController.instance;
    final viaSl = GetIt.I<ShareController>();
    expect(identical(first, viaSl), isTrue,
        reason: 'get_it يجب أن يُرجع نفس نسخة GetX');

    // إغلاق صفحة المشاركة: RouterReportManager يستدعي delete غير الإجباري
    // للنسخ المرتبطة بالمسار — التسجيل يجب أن يكون permanent لينجو
    Get.delete<ShareController>();

    expect(Get.isRegistered<ShareController>(), isTrue,
        reason: 'تسجيل putOrFind الحالي non-permanent فيحذفه GetX عند إغلاق '
            'المسار، بينما get_it يُبقي النسخة القديمة يتيمة فيتفاوت الكائنان');

    // المشاركة الثانية: يجب أن نحصل على نفس الكائن (وإلا كان ayahToImageBytes
    // null على النسخة الجديدة => Null check operator في shareVerse)
    final second = ShareController.instance;
    expect(identical(first, second), isTrue);
  });
}

import 'package:alquranalkareem/core/utils/constants/extensions/bottom_sheet_extension.dart';
import 'package:alquranalkareem/presentation/screens/quran_page/data/helper/ayah_menu_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

/// family_bottom_sheet تركّب صفحة الورقة مرتين (نسخة Offstage لقياس الارتفاع
/// ونسخة ظاهرة)، فيرتبط أي ScrollController مُمرَّر للصفحة بأكثر من موضع.
/// هذه الاختبارات تثبت ذلك وتضمن أن التحريك التلقائي لكلمات الآية آمن مع
/// تعدد المواضع بدل قراءة .position التي تفترض موضعًا واحدًا.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> openSheetWithWordsRow(
    WidgetTester tester,
    ScrollController controller,
  ) {
    Get.testMode = true;
    return tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                key: const Key('open-sheet'),
                onPressed: () => BottomSheetExtension(null).customBottomSheet(
                  SizedBox(
                    height: 50,
                    child: SingleChildScrollView(
                      controller: controller,
                      scrollDirection: Axis.horizontal,
                      child: const SizedBox(width: 1000, height: 50),
                    ),
                  ),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('صفحة الورقة تُركَّب مرتين فيرتبط الـ controller بموضعين', (
    tester,
  ) async {
    final controller = ScrollController();
    await openSheetWithWordsRow(tester, controller);

    await tester.tap(find.byKey(const Key('open-sheet')));
    await tester.pumpAndSettle();

    // جذر الخلل: نسخة Offstage للقياس + نسخة ظاهرة = موضعان على controller واحد.
    expect(controller.positions.length, 2);
    expect(controller.hasClients, isTrue);

    Get.back<void>();
    await tester.pumpAndSettle();
    controller.dispose();
  });

  testWidgets('scrollToWord يحرّك كل المواضع دون AssertionError', (
    tester,
  ) async {
    final controller = ScrollController();
    await openSheetWithWordsRow(tester, controller);

    await tester.tap(find.byKey(const Key('open-sheet')));
    await tester.pumpAndSettle();

    final maxScroll = controller.positions.first.maxScrollExtent;
    expect(maxScroll, greaterThan(0));

    // قبل الإصلاح: قراءة .position هنا كانت ترمي
    // AssertionError (_positions.length == 1).
    AyahMenuHelper.scrollToWord(controller, wordNumber: 3, totalWords: 5);
    await tester.pumpAndSettle();

    final expected = maxScroll * 2 / 4;
    for (final position in controller.positions) {
      expect(position.pixels, closeTo(expected, 0.5));
    }

    // حارسا الحافة: لا مواضع (ورقة مغلقة) أو كلمة واحدة — بلا استثناءات.
    AyahMenuHelper.scrollToWord(controller, wordNumber: 0, totalWords: 0);
    AyahMenuHelper.scrollToWord(controller, wordNumber: 1, totalWords: 1);

    Get.back<void>();
    await tester.pumpAndSettle();
    controller.dispose();
  });
}

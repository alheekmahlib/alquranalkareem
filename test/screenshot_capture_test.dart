import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';

/// مشاركة صورة الذكر تعتمد الآن captureFromWidget (التقاط من ويدجت غير
/// مركّب في الشجرة) بدل Screenshot داخل الورقة، لأن family_bottom_sheet
/// يركّب محتوى الورقة مرتين فلا يصح GlobalKey داخها.
void main() {
  testWidgets('captureFromWidget يلتقط بايتات صورة صالحة', (tester) async {
    late BuildContext sheetContext;
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              sheetContext = context;
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );

    final bytes = await ScreenshotController().captureFromWidget(
      const Directionality(
        textDirection: TextDirection.rtl,
        child: ColoredBox(color: Colors.red, child: Text('zekr-share-image')),
      ),
      context: sheetContext,
      delay: Duration.zero,
    );

    expect(bytes, isNotEmpty);
    // توقيع PNG
    expect(bytes.sublist(0, 4), [137, 80, 78, 71]);
  });
}

import 'package:alquranalkareem/core/utils/constants/extensions/bottom_sheet_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

/// family_bottom_sheet ينفّذ الـ builder أثناء initState، فأي قراءة
/// MediaQuery/Theme مباشرة داخل الـ builder ترمي استثناء dependOnInheritedWidget.
/// هذه الاختبارات تضمن أن customBottomSheet تؤجّل هذه القراءات (عبر Builder).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('customBottomSheet تفتح بدون استثناء inherited widgets',
      (tester) async {
    Get.testMode = true;
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return Center(
                child: ElevatedButton(
                  key: const Key('open-sheet'),
                  onPressed: () =>
                      BottomSheetExtension(null).customBottomSheet(
                    const Text('sheet-content'),
                  ),
                  child: const Text('open'),
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('open-sheet')));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('sheet-content'), findsOneWidget);

    Get.back<void>();
    await tester.pumpAndSettle();
    expect(find.text('sheet-content'), findsNothing);
  });

  testWidgets('محتوى بـ Expanded وListView داخل ارتفاع محدد يُعرض بلا استثناء',
      (tester) async {
    // يحاكي بنية mutashabihat_browse_sheet: غلاف customBottomSheet يلتف
    // حول المحتوى، فلا بد من SizedBox بارتفاع محدد وإلا انهار Expanded.
    Get.testMode = true;
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                key: const Key('open-sheet-list'),
                onPressed: () => BottomSheetExtension(null).customBottomSheet(
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .75,
                    child: Column(
                      children: [
                        const Text('browse-title'),
                        Expanded(
                          child: ListView(
                            children: const [Text('item-1'), Text('item-2')],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                child: const Text('open2'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('open-sheet-list')));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('browse-title'), findsOneWidget);
    expect(find.text('item-1'), findsOneWidget);
  });
}

import 'package:alquranalkareem/core/utils/constants/extensions/bottom_sheet_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

/// family_bottom_sheet ينفّذ الـ builder أثناء initState، فأي قراءة
/// MediaQuery/Theme مباشرة داخل الـ builder ترمي استثناء dependOnInheritedWidget.
/// هذه الاختبارات تضمن أن customBottomSheet تؤجّل هذه القراءات (عبر Builder).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('customBottomSheet تفتح بدون استثناء inherited widgets', (
    tester,
  ) async {
    Get.testMode = true;
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return Center(
                child: ElevatedButton(
                  key: const Key('open-sheet'),
                  onPressed: () => BottomSheetExtension(
                    null,
                  ).customBottomSheet(const Text('sheet-content')),
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

  testWidgets(
    'محتوى بـ Expanded وListView داخل ارتفاع محدد يُعرض بلا استثناء',
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
    },
  );

  testWidgets(
    'محتوى KhatmasScreen (SizedBox بوعي الكيبورد) لا يفيض ويصل لكل العناصر',
    (tester) async {
      // يعيد إنتاج سيناريو iPhone 16/18 Pro: 402×874 منطقيًا (dpr 3) وكيبورد
      // يقصّ ~226 بكسل. الارتفاع الثابت القديم (Get.height * 0.6) كان يبقى
      // 524px مع الكيبورد فيفيض؛ الجديد يطرح viewInsets قبل النسبة.
      // الترتيب كالتطبيق الحقيقي: الشيت يُفتح والكيبورد مغلق (وإلا التُقط
      // safeAreaMinimum بقيمة الكيبورد وطُرح مرتين)، ثم يُفتح الكيبورد.
      tester.view.physicalSize = const Size(1206.0, 2622.0);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.reset);

      Get.testMode = true;
      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: Center(
              child: ElevatedButton(
                key: const Key('open-khatmah'),
                onPressed: () => BottomSheetExtension(
                  null,
                ).customBottomSheet(khatmahLikeBody()),
                child: const Text('open3'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('open-khatmah')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // قبل الكيبورد: نفس ارتفاع 0.6 القديم (524.4).
      expect(
        tester.renderObject<RenderBox>(find.byType(ListView).first).size.height,
        closeTo(524.4, 1.0),
      );

      // افتح الكيبورد (كما لو ضغط المستخدم حقل إضافة ختمة).
      tester.view.viewInsets = const FakeViewPadding(bottom: 678.0);
      await tester.pumpAndSettle();

      // لا overflow: الارتفاع تقلص مع الكيبورد (388.8 بدل 524.4 الثابت).
      expect(tester.takeException(), isNull);
      expect(find.text('khatmah-title'), findsOneWidget);
      expect(find.text('item-0'), findsOneWidget);
      expect(find.text('item-29'), findsNothing); // خارج الشاشة قبل التمرير

      final viewport = tester.renderObject<RenderBox>(
        find.byType(ListView).first,
      );
      expect(viewport.size.height, closeTo(388.8, 1.0));

      // التمرير داخل القائمة يصل لآخر عنصر.
      await tester.drag(find.byType(ListView), const Offset(0, -1500));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('item-29'), findsOneWidget);
    },
  );

  testWidgets('محتوى قصير بدون كيبورد يظل منكمشًا على حجمه', (tester) async {
    Get.testMode = true;
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: Center(
            child: ElevatedButton(
              key: const Key('open-short'),
              onPressed: () => BottomSheetExtension(null).customBottomSheet(
                const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [Text('short-content'), Gap(8)],
                ),
              ),
              child: const Text('open4'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('open-short')));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('short-content'), findsOneWidget);
    // الجسم لا يتمدد لكامل الشاشة بل ينكمش على المحتوى.
    final body = tester.renderObject<RenderBox>(
      find.text('short-content').first,
    );
    expect(body.size.height, lessThan(100));
  });
}

/// بنية مطابقة لـ KhatmasScreen: SingleChildScrollView + SizedBox بارتفاع
/// (Get.height - viewInsets) * 0.6 حول ListView — محتوى 30 عنصرًا (1200 بكسل).
Widget khatmahLikeBody() {
  return Builder(
    builder: (context) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('khatmah-title'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height:
                    (Get.height - MediaQuery.of(context).viewInsets.bottom) *
                    0.6,
                child: ListView(
                  shrinkWrap: true,
                  children: List.generate(
                    30,
                    (i) => SizedBox(height: 40, child: Text('item-$i')),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

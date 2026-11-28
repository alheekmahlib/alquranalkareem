import 'package:alquranalkareem/presentation/controllers/general/app_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  group('AppSection', () {
    test(
      'start-screen indexes map to their sections, and 2 (alwaqf) to home',
      () {
        expect(AppSection.forStartIndex(0), AppSection.home);
        expect(AppSection.forStartIndex(1), AppSection.mushaf);
        expect(AppSection.forStartIndex(2), AppSection.home);
        expect(AppSection.forStartIndex(3), AppSection.azkar);
        expect(AppSection.forStartIndex(4), AppSection.audio);
        expect(AppSection.forStartIndex(5), AppSection.books);
        expect(AppSection.forStartIndex(6), AppSection.midad);
        expect(AppSection.forStartIndex(7), AppSection.tasmee);
        expect(AppSection.forStartIndex(99), AppSection.home);
      },
    );

    test(
      'every section has a fixed route; mushaf and tasmee share QuranHome',
      () {
        expect(AppSection.values.map((section) => section.route).toSet(), {
          '/HomeScreen',
          '/QuranHome',
          '/AdhkarView',
          '/AudioScreen',
          '/BooksScreen',
          '/AiSearchResults',
        });
        expect(AppSection.mushaf.route, AppSection.tasmee.route);
      },
    );

    testWidgets('isShowing follows the current route name', (tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(home: Scaffold(body: SizedBox())),
      );
      expect(AppSection.books.isShowing, isFalse);

      Get.to(
        () => const Scaffold(body: SizedBox()),
        routeName: AppSection.books.route,
        transition: Transition.noTransition,
      );
      await tester.pumpAndSettle();
      expect(Get.currentRoute, AppSection.books.route);
      expect(AppSection.books.isShowing, isTrue);
      expect(AppSection.azkar.isShowing, isFalse);

      Get.back();
      await tester.pumpAndSettle();
      expect(AppSection.books.isShowing, isFalse);

      Get.reset();
    });

    testWidgets(
      'popToHomeIfStacked pops to a stacked Home and keeps its state',
      (tester) async {
        var homeBuilds = 0;
        await tester.pumpWidget(const GetMaterialApp(home: Scaffold()));
        Get.offAll(
          () => _HomeProbe(onInit: () => homeBuilds++),
          routeName: AppSection.home.route,
          transition: Transition.noTransition,
        );
        Get.to(
          () => const Scaffold(),
          routeName: AppSection.books.route,
          transition: Transition.noTransition,
        );
        Get.to(
          () => const Scaffold(),
          routeName: '/ReadViewScreen',
          transition: Transition.noTransition,
        );
        await tester.pumpAndSettle();
        expect(Get.currentRoute, '/ReadViewScreen');
        expect(homeBuilds, 1);

        // يُعرف اسم المسار فورًا، لا بعد انتهاء حركة الرجوع.
        final leaving = popToHomeIfStacked();
        expect(Get.currentRoute, AppSection.home.route);
        // خروج الشاشات المُطردة من الشجرة يتم بانتهاء حركة خروجها، كما في
        // التطبيق.
        await tester.pumpAndSettle();
        expect(await leaving, isTrue);
        await tester.pumpAndSettle();
        // الرئيسية نفسها لا جديد: حالتها (موضع التمرير مثلاً) باقية.
        expect(homeBuilds, 1);
        expect(AppSection.home.isShowing, isTrue);

        // وهي الشاشة الجارية: لا شيء يُطرد.
        expect(await popToHomeIfStacked(), isTrue);
        expect(Get.currentRoute, AppSection.home.route);

        Get.reset();
      },
    );

    testWidgets('popToHomeIfStacked reports a root that is not Home', (
      tester,
    ) async {
      await tester.pumpWidget(const GetMaterialApp(home: Scaffold()));
      Get.offAll(
        () => const Scaffold(),
        routeName: AppSection.books.route,
        transition: Transition.noTransition,
      );
      await tester.pumpAndSettle();

      expect(await popToHomeIfStacked(), isFalse);
      expect(Get.currentRoute, AppSection.books.route);

      Get.reset();
    });

    testWidgets('routeChanges bumps on every navigation event', (tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const Scaffold(),
          routingCallback: (_) => routeChanges.value++,
        ),
      );
      final before = routeChanges.value;

      Get.to(
        () => const Scaffold(),
        routeName: AppSection.books.route,
        transition: Transition.noTransition,
      );
      await tester.pumpAndSettle();
      expect(routeChanges.value, before + 1);

      Get.back();
      await tester.pumpAndSettle();
      expect(routeChanges.value, before + 2);

      Get.reset();
    });

    testWidgets(
      'waits for a slowly leaving screen to leave the tree before resolving',
      (tester) async {
        const outgoing = Key('outgoing');
        await tester.pumpWidget(const GetMaterialApp(home: Scaffold()));
        Get.offAll(
          () => const Scaffold(),
          routeName: AppSection.home.route,
          transition: Transition.noTransition,
        );
        await tester.pumpAndSettle();
        Get.to(
          () => const Scaffold(key: outgoing),
          routeName: '/SlowScreen',
          transition: Transition.downToUp,
          duration: const Duration(seconds: 1),
        );
        await tester.pumpAndSettle();
        expect(Get.currentRoute, '/SlowScreen');

        bool? completed;
        final leaving = popToHomeIfStacked().then((_) => completed = true);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        // حركة الخروج (ثانية) ما زالت جارية والشاشة القديمة في الشجرة، فلا
        // يُحلّ الوعد: نسخة جديدة من الشاشة فوقها كانت ستكرر مفاتيحها العامة.
        expect(completed, isNull);
        expect(find.byKey(outgoing), findsOneWidget);

        await tester.pump(const Duration(milliseconds: 700));
        await tester.pumpAndSettle();
        await leaving;
        // اكتمل بوعود الخروج نفسه لا بالمهلة الاحتياطية (الثانيتين).
        expect(completed, isTrue);
        expect(find.byKey(outgoing), findsNothing);
        expect(AppSection.home.isShowing, isTrue);

        Get.reset();
      },
    );
  });
}

/// شاشة تحصي مرات إنشائها حتى يُعرف هل أُعيد بناء الرئيسية أم لا.
class _HomeProbe extends StatefulWidget {
  const _HomeProbe({required this.onInit});

  final VoidCallback onInit;

  @override
  State<_HomeProbe> createState() => _HomeProbeState();
}

class _HomeProbeState extends State<_HomeProbe> {
  @override
  void initState() {
    widget.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => const Scaffold();
}

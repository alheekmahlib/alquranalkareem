import 'dart:convert';
import 'dart:io';

import 'package:alquranalkareem/core/tour/app_tour.dart';
import 'package:alquranalkareem/core/tour/tour_launcher.dart';
import 'package:alquranalkareem/presentation/controllers/general/app_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:spotlight_tour/spotlight_tour.dart';

/// مستندات وهمية لتهيئة GetStorage دون لمس قرص المستخدم.
class _FakePathProvider extends PathProviderPlatform {
  _FakePathProvider(this.path);

  final String path;

  @override
  Future<String?> getApplicationDocumentsPath() async => path;
}

void main() {
  const locales = [
    'ar',
    'bn',
    'en',
    'es',
    'id',
    'ku',
    'ph',
    'ru',
    'so',
    'tr',
    'ur',
  ];

  group('AppTourPick', () {
    test('lists one tour per section reachable from Home, in app order', () {
      expect(AppTourPick.values, [
        AppTourPick.home,
        AppTourPick.mushaf,
        AppTourPick.tasmee,
        AppTourPick.audio,
        AppTourPick.midad,
        AppTourPick.books,
        AppTourPick.azkar,
      ]);
      expect(
        AppTourPick.values.map((tour) => tour.section).toSet(),
        AppSection.values.toSet(),
      );
    });

    test('each tour id is the completion-store id of its script', () {
      expect(AppTourPick.home.id, AppTour.homeTourId);
      expect(AppTourPick.mushaf.id, AppTour.mushafTourId);
      expect(AppTourPick.tasmee.id, AppTour.tasmeeTourId);
      expect(AppTourPick.audio.id, AppTour.audioTourId);
      expect(AppTourPick.midad.id, AppTour.midadTourId);
      expect(AppTourPick.books.id, AppTour.booksTourId);
      expect(AppTourPick.azkar.id, AppTour.azkarTourId);
    });

    test('every tour title and the settings title exist in all 11 locales', () {
      for (final locale in locales) {
        final strings =
            jsonDecode(File('assets/locales/$locale.json').readAsStringSync())
                as Map<String, dynamic>;
        expect(strings['replayTours'], isA<String>(), reason: locale);
        for (final tour in AppTourPick.values) {
          expect(
            strings[tour.titleKey],
            isA<String>(),
            reason: '$locale ${tour.titleKey}',
          );
        }
      }
    });

    test(
      'showsOn: mushaf and tasmee share a screen and differ by its mode',
      () {
        expect(
          AppTourPick.mushaf.showsOn('/QuranHome', isTasmeeMode: false),
          isTrue,
        );
        expect(
          AppTourPick.mushaf.showsOn('/QuranHome', isTasmeeMode: true),
          isFalse,
        );
        expect(
          AppTourPick.tasmee.showsOn('/QuranHome', isTasmeeMode: true),
          isTrue,
        );
        expect(
          AppTourPick.tasmee.showsOn('/QuranHome', isTasmeeMode: false),
          isFalse,
        );
      },
    );

    test('showsOn: a section is on screen only at its own route', () {
      expect(
        AppTourPick.books.showsOn('/BooksScreen', isTasmeeMode: false),
        isTrue,
      );
      // القارئ شاشة متداخلة في المكتبة، ليس قائمتها.
      expect(
        AppTourPick.books.showsOn('/ReadViewScreen', isTasmeeMode: false),
        isFalse,
      );
      expect(
        AppTourPick.home.showsOn('/HomeScreen', isTasmeeMode: false),
        isTrue,
      );
      expect(
        AppTourPick.azkar.showsOn('/AdhkarItem', isTasmeeMode: false),
        isFalse,
      );
    });
  });

  group('TourLauncher', () {
    late AppTour appTour;
    late List<String> calls;

    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final dir = await Directory.systemTemp.createTemp('tour_launcher_test');
      PathProviderPlatform.instance = _FakePathProvider(dir.path);
      await GetStorage.init();
    });

    tearDown(() {
      appTour.tour.dispose();
      Get.reset();
    });

    /// يسجّل الخدمة ببديلين للتنقل: العودة للرئيسية تُسجَّل فقط، وفتح القسم
    /// يفتح شاشة فارغة باسم مساره (بلا شاشات التطبيق وكنترولراتها).
    void registerLauncher({
      required bool Function() isTasmeeMode,
      required bool Function(AppTourPick tour) isSectionReady,
    }) {
      Get.put(
        TourLauncher(
          returnToHome: () async => calls.add('home'),
          openSection: (section) async {
            calls.add('open ${section.name}');
            Get.to(
              () => const Scaffold(),
              routeName: section.route,
              transition: Transition.noTransition,
            );
          },
          isTasmeeMode: isTasmeeMode,
          isSectionReady: isSectionReady,
        ),
        permanent: true,
      );
    }

    /// يفتح شاشة فارغة باسم مسار، فيصبح ذلك القسم هو الشاشة الجارية.
    Future<void> showScreen(WidgetTester tester, String route) async {
      Get.to(
        () => const Scaffold(),
        routeName: route,
        transition: Transition.noTransition,
      );
      await tester.pumpAndSettle();
    }

    testWidgets('replays in place when the tour screen is the current one', (
      tester,
    ) async {
      await tester.pumpWidget(const GetMaterialApp(home: Scaffold()));
      await showScreen(tester, AppSection.home.route);
      appTour = Get.put(AppTour(), permanent: true);
      calls = [];
      Get.put(
        TourLauncher(
          returnToHome: () async => fail('must not leave the screen'),
          openSection: (section) async => fail('must not open $section'),
          isTasmeeMode: () => false,
          isSectionReady: (_) => true,
        ),
        permanent: true,
      );

      final started = TourLauncher.instance.start(AppTourPick.home);
      await tester.pump(TourLauncher.sheetSettle);
      await tester.pump();
      await started;

      expect(Get.currentRoute, AppSection.home.route);
      expect(appTour.tour.status, TourStatus.running);
      expect(appTour.tour.steps.first.title, 'homeTourIntroTitle');
    });

    testWidgets(
      'navigates to the tour section, suppresses its auto-start, then replays',
      (tester) async {
        await tester.pumpWidget(const GetMaterialApp(home: Scaffold()));
        appTour = Get.put(AppTour(), permanent: true);
        calls = [];
        registerLauncher(
          isTasmeeMode: () => false,
          isSectionReady: (_) => true,
        );

        final started = TourLauncher.instance.start(AppTourPick.azkar);
        await tester.pump(TourLauncher.sheetSettle);
        await tester.pump();
        expect(calls, ['home', 'open azkar']);
        expect(Get.currentRoute, AppSection.azkar.route);

        // الشاشة لا تشغّل جولتها التلقائية: الجولة المطلوبة هي التي تبدأ.
        appTour.startAzkarTourOnce();
        expect(appTour.tour.status, TourStatus.idle);
        expect(appTour.tour.steps, isEmpty);

        await tester.pump(TourLauncher.screenSettle);
        await tester.pump();
        await started;
        expect(appTour.tour.status, TourStatus.running);
        expect(appTour.tour.steps.first.title, 'azkarTourIntroTitle');
      },
    );

    testWidgets('waits for the section data before replaying', (tester) async {
      await tester.pumpWidget(const GetMaterialApp(home: Scaffold()));
      appTour = Get.put(AppTour(), permanent: true);
      calls = [];
      var polls = 0;
      registerLauncher(
        isTasmeeMode: () => false,
        isSectionReady: (_) => ++polls > 3,
      );

      final started = TourLauncher.instance.start(AppTourPick.azkar);
      await tester.pump(TourLauncher.sheetSettle);
      await tester.pump();
      await tester.pump(TourLauncher.screenSettle);
      await tester.pump();
      expect(Get.currentRoute, AppSection.azkar.route);
      expect(appTour.tour.status, TourStatus.idle);

      await tester.pump(TourLauncher.readinessStep * 3);
      await tester.pump();
      await started;
      expect(appTour.tour.status, TourStatus.running);
    });

    testWidgets(
      'does not start the tour if the user leaves the section first',
      (tester) async {
        await tester.pumpWidget(const GetMaterialApp(home: Scaffold()));
        appTour = Get.put(AppTour(), permanent: true);
        calls = [];
        // البيانات لا تجهز أبداً في هذا السيناريو.
        registerLauncher(
          isTasmeeMode: () => false,
          isSectionReady: (_) => false,
        );

        final started = TourLauncher.instance.start(AppTourPick.azkar);
        await tester.pump(TourLauncher.sheetSettle);
        await tester.pump();
        await tester.pump(TourLauncher.screenSettle);
        await tester.pump();

        Get.back();
        await tester.pumpAndSettle();
        await tester.pump(TourLauncher.readinessLimit);
        await tester.pump();
        await started;

        expect(appTour.tour.status, TourStatus.idle);
        expect(appTour.tour.steps, isEmpty);
      },
    );
  });
}

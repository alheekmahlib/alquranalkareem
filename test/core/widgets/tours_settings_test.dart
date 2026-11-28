import 'dart:io';

import 'package:alquranalkareem/core/tour/app_tour.dart';
import 'package:alquranalkareem/core/tour/tour_launcher.dart';
import 'package:alquranalkareem/core/widgets/container_button.dart';
import 'package:alquranalkareem/core/widgets/tours_settings.dart';
import 'package:flexible_sheet/flexible_sheet.dart';
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
  group('ToursSettings', () {
    late AppTour appTour;

    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final dir = await Directory.systemTemp.createTemp('tours_settings_test');
      PathProviderPlatform.instance = _FakePathProvider(dir.path);
      await GetStorage.init();
    });

    tearDown(() {
      if (Get.isRegistered<AppTour>()) appTour.tour.dispose();
      Get.reset();
    });

    testWidgets('shows a chip per tour, titled with the tour name', (
      tester,
    ) async {
      await tester.pumpWidget(
        const GetMaterialApp(home: Scaffold(body: ToursSettings())),
      );

      expect(find.text('replayTours'), findsOneWidget);
      expect(
        find.byType(ContainerButton),
        findsNWidgets(AppTourPick.values.length),
      );
      for (final tour in AppTourPick.values) {
        expect(find.text(tour.titleKey), findsOneWidget);
      }
    });

    testWidgets('a chip closes the settings sheet then starts that tour', (
      tester,
    ) async {
      final sheet = FlexibleSheetController(initialIsOpen: true);
      appTour = Get.put(AppTour(), permanent: true);
      final calls = <String>[];
      Get.put(
        TourLauncher(
          returnToHome: () async => calls.add('home'),
          openSection: (section) async => calls.add('open ${section.name}'),
          isTasmeeMode: () => false,
          isSectionReady: (_) => true,
        ),
        permanent: true,
      );
      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(body: ToursSettings(sheetController: sheet)),
        ),
      );

      await tester.tap(find.text(AppTourPick.books.titleKey));
      await tester.pump();
      expect(sheet.isOpen, isFalse);

      await tester.pump(TourLauncher.sheetSettle);
      await tester.pump();
      expect(calls, ['home', 'open books']);

      // لا شاشة للمكتبة هنا فيلغي المشغّل الجولة بعد استقرار الشاشة.
      await tester.pump(TourLauncher.screenSettle);
      await tester.pump();
      expect(appTour.tour.status, TourStatus.idle);
    });
  });
}

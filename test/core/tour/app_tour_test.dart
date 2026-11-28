import 'dart:io';

import 'package:alquranalkareem/core/tour/app_tour.dart';
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
  group('AppTour.suppressAutoStart', () {
    late AppTour appTour;

    /// كل دالة «مرة واحدة» تستدعيها شاشة قسم عند فتحه، بمعرّف جولتها.
    /// شاشة مداد تشغّل جولتين فلديها سطران.
    final onceStarts = <String, void Function(AppTour)>{
      AppTour.homeTourId: (tour) => tour.startHomeTourOnce(),
      AppTour.mushafTourId: (tour) => tour.repairThenStartMushafTourOnce(),
      AppTour.tasmeeTourId: (tour) => tour.startTasmeeTourOnce(),
      AppTour.audioTourId: (tour) => tour.startAudioTourOnce(),
      AppTour.midadTourId: (tour) {
        tour.startMidadTourOnce();
        tour.startMidadAssistantTourOnce();
      },
      AppTour.booksTourId: (tour) => tour.startBooksTourOnce(),
      AppTour.azkarTourId: (tour) => tour.startAzkarTourOnce(),
    };

    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final dir = await Directory.systemTemp.createTemp('app_tour_test');
      PathProviderPlatform.instance = _FakePathProvider(dir.path);
      await GetStorage.init();
    });

    tearDown(() {
      appTour.tour.dispose();
      Get.reset();
    });

    test('a suppressed tour is not auto-started by its screen', () {
      for (final entry in onceStarts.entries) {
        appTour = AppTour();
        appTour.suppressAutoStart(entry.key);
        entry.value(appTour);
        expect(appTour.tour.status, TourStatus.idle, reason: entry.key);
        expect(appTour.tour.steps, isEmpty, reason: entry.key);
      }
    });

    testWidgets('without suppression the once-start really runs (control)', (
      tester,
    ) async {
      await tester.pumpWidget(const GetMaterialApp(home: Scaffold()));
      appTour = AppTour();

      appTour.startMidadAssistantTourOnce();
      await tester.pump();

      expect(appTour.tour.status, TourStatus.running);
    });
  });
}

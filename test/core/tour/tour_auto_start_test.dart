import 'package:alquranalkareem/core/tour/tour_auto_start.dart';
import 'package:alquranalkareem/presentation/controllers/general/app_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  group('startTourWhenSectionShows', () {
    /// يفتح شاشة فارغة باسم مسار قسم، فيصبح هو الشاشة الجارية.
    Future<void> showScreen(WidgetTester tester, String route) async {
      Get.to(
        () => const Scaffold(),
        routeName: route,
        transition: Transition.noTransition,
      );
      await tester.pumpAndSettle();
    }

    testWidgets('starts after the frame when the section screen is current', (
      tester,
    ) async {
      await tester.pumpWidget(const GetMaterialApp(home: Scaffold()));
      await showScreen(tester, AppSection.books.route);
      var starts = 0;

      startTourWhenSectionShows(AppSection.books, () => starts++);
      // ليس داخل الإطار الجاري بل بعده.
      expect(starts, 0);
      await tester.pump();
      expect(starts, 1);

      Get.reset();
    });

    testWidgets('does not start while another screen is current', (
      tester,
    ) async {
      await tester.pumpWidget(const GetMaterialApp(home: Scaffold()));
      await showScreen(tester, AppSection.azkar.route);
      var bookStarts = 0;
      var azkarStarts = 0;

      startTourWhenSectionShows(AppSection.books, () => bookStarts++);
      // شاهد يثبت أن الإطار حدث ونُفِّذت روده، فعدم بدء المكتبة حقيقي.
      startTourWhenSectionShows(AppSection.azkar, () => azkarStarts++);
      await tester.pump();
      expect(azkarStarts, 1);
      expect(bookStarts, 0);

      Get.reset();
    });
  });
}

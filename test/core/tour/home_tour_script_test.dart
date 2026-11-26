import 'dart:convert';
import 'dart:io';

import 'package:alquranalkareem/core/tour/books_tour_script.dart';
import 'package:alquranalkareem/core/tour/home_tour_script.dart';
import 'package:alquranalkareem/core/tour/mushaf_tour_script.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotlight_tour/spotlight_tour.dart';

/// يسجّل ما طلبته الجولة من التطبيق بدل كنترولرات الشاشة الحقيقية: حضور
/// المحتوى اليومي، وتمرير قائمة الصفحة الرئيسية.
class _FakeHooks implements HomeTourHooks {
  @override
  bool hasHomeDailyAyah = true;

  @override
  bool hasHomeDailyZeker = true;

  /// موضع تمرير القائمة الحالي، وكل ما طلبت الجولة تمريرها إليه.
  @override
  double homeScrollOffset = 0.0;

  /// أقصى موضع تتيحه القائمة.
  @override
  double homeScrollMax = 600.0;

  final scrolledTo = <double>[];

  @override
  void scrollHomeTo(double value) {
    scrolledTo.add(value);
    homeScrollOffset = value;
  }
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

  late _FakeHooks hooks;
  late SpotlightTourController tour;

  setUp(() {
    hooks = _FakeHooks();
    tour = SpotlightTourController(
      completionStore: InMemoryTourCompletionStore(),
    );
  });

  /// سيناريو الجولة مربوطاً على الكنترولر.
  HomeTourScript scriptFor() {
    final script = HomeTourScript(
      tour: tour,
      hooks: hooks,
      style: const TourStepStyle(),
      hasDailyAyah: hooks.hasHomeDailyAyah,
      hasDailyZeker: hooks.hasHomeDailyZeker,
    );
    tour.onStepChanged = script.onStepChanged;
    return script;
  }

  /// يبدأ الجولة على محطة معيّنة.
  void startAt(HomeTourScript script, HomeTourStop stop) =>
      tour.start(steps: script.steps, initialIndex: script.stops.indexOf(stop));

  test('home tour texts are read under keys derived from the stop name', () {
    expect(homeTourTitleKey(HomeTourStop.intro), 'homeTourIntroTitle');
    expect(
      homeTourDescKey(HomeTourStop.notifications),
      'homeTourNotificationsDesc',
    );
    // A title that is only the feature's own name reuses the app's key
    // for it instead of duplicating the same word under a tour key.
    expect(homeTourTitleKey(HomeTourStop.midad), 'midad');
    expect(homeTourTitleKey(HomeTourStop.tasmeeMode), 'tasmeeModeTeacher');
    expect(homeTourTitleKey(HomeTourStop.lastRead), 'continueReading');
    expect(homeTourTitleKey(HomeTourStop.quran), 'quran');
    expect(homeTourTitleKey(HomeTourStop.quranAudio), 'quranAudio');
    expect(homeTourTitleKey(HomeTourStop.dailyZeker), 'dailyZeker');
    expect(homeTourTitleKey(HomeTourStop.azkar), 'azkar');
    expect(homeTourTitleKey(HomeTourStop.islamicLibrary), 'islamicLibrary');
    // The closing card's title is the same for every tour.
    expect(homeTourTitleKey(HomeTourStop.closing), 'mushafTourClosingTitle');
  });

  test('each tour has one step per stop, intro first and closing last', () {
    final script = scriptFor();
    expect(script.steps.length, HomeTourStop.values.length);
    expect(script.steps.first.title, 'homeTourIntroTitle');
    expect(script.steps.first.targetKey, isNull);
    expect(script.steps.last.title, 'mushafTourClosingTitle');
    expect(script.steps.last.targetKey, isNull);
  });

  test('the tour follows the visual order of the home page', () {
    final script = scriptFor();
    expect(script.stops, <HomeTourStop>[
      HomeTourStop.intro,
      HomeTourStop.notifications,
      HomeTourStop.settings,
      HomeTourStop.hijri,
      HomeTourStop.midad,
      HomeTourStop.tasmeeMode,
      HomeTourStop.lastRead,
      HomeTourStop.quran,
      HomeTourStop.quranAudio,
      HomeTourStop.dailyAyah,
      HomeTourStop.dailyZeker,
      HomeTourStop.azkar,
      HomeTourStop.islamicLibrary,
      HomeTourStop.booksLastRead,
      HomeTourStop.closing,
    ]);
  });

  test('each stop points at the widget tagged for it', () {
    // The step is looked up in the stops list of the very tour, not by the
    // enum index, in case a state drops a stop before it.
    Key? targetOf(HomeTourStop stop) {
      final script = scriptFor();
      return script.steps[script.stops.indexOf(stop)].targetKey;
    }

    expect(
      targetOf(HomeTourStop.notifications),
      same(HomeTourKeys.notifications),
    );
    // The settings button carries the mushaf tour's key already: one widget,
    // one key.
    expect(targetOf(HomeTourStop.settings), same(MushafTourKeys.settings));
    expect(targetOf(HomeTourStop.hijri), same(HomeTourKeys.hijri));
    expect(targetOf(HomeTourStop.midad), same(HomeTourKeys.midad));
    expect(targetOf(HomeTourStop.tasmeeMode), same(HomeTourKeys.tasmeeMode));
    expect(targetOf(HomeTourStop.lastRead), same(HomeTourKeys.lastRead));
    expect(targetOf(HomeTourStop.quran), same(HomeTourKeys.quran));
    expect(targetOf(HomeTourStop.quranAudio), same(HomeTourKeys.quranAudio));
    expect(targetOf(HomeTourStop.dailyAyah), same(HomeTourKeys.dailyAyah));
    expect(targetOf(HomeTourStop.dailyZeker), same(HomeTourKeys.dailyZeker));
    expect(targetOf(HomeTourStop.azkar), same(HomeTourKeys.azkar));
    expect(
      targetOf(HomeTourStop.islamicLibrary),
      same(HomeTourKeys.islamicLibrary),
    );
    // The books last-read strip carries the books tour's key already.
    expect(targetOf(HomeTourStop.booksLastRead), same(BooksTourKeys.lastRead));
  });

  test('the daily-content stops drop until their data arrives', () {
    // The daily ayah and the daily zekr load from the databases after the
    // screen opens; their stops (and the azkar button inside the zekr card)
    // drop from a tour started before that.
    hooks.hasHomeDailyAyah = false;
    hooks.hasHomeDailyZeker = false;
    final early = scriptFor();
    expect(early.stops, isNot(contains(HomeTourStop.dailyAyah)));
    expect(early.stops, isNot(contains(HomeTourStop.dailyZeker)));
    expect(early.stops, isNot(contains(HomeTourStop.azkar)));
    expect(early.stops.length, HomeTourStop.values.length - 3);

    hooks.hasHomeDailyZeker = true;
    final zekrOnly = scriptFor();
    expect(zekrOnly.stops, isNot(contains(HomeTourStop.dailyAyah)));
    expect(
      zekrOnly.stops,
      containsAll(<HomeTourStop>[HomeTourStop.dailyZeker, HomeTourStop.azkar]),
    );

    hooks.hasHomeDailyAyah = true;
    final full = scriptFor();
    expect(full.stops.length, HomeTourStop.values.length);
  });

  test('the tour scrolls each stop into its zone, then restores', () {
    hooks.homeScrollOffset = 40;
    final script = scriptFor();

    // The top-bar and first cards pin the list to its top.
    startAt(script, HomeTourStop.hijri);
    expect(hooks.scrolledTo, [0]);
    expect(hooks.homeScrollOffset, 0);

    // The quran section's stops bring it into view below the top bar.
    script.onStepChanged(script.stops.indexOf(HomeTourStop.lastRead));
    expect(hooks.scrolledTo, [0, homeTourMidZoneOffset]);
    script.onStepChanged(script.stops.indexOf(HomeTourStop.quranAudio));
    expect(hooks.scrolledTo, [0, homeTourMidZoneOffset]);

    // The stops below the fold scroll to the bottom of the list.
    script.onStepChanged(script.stops.indexOf(HomeTourStop.islamicLibrary));
    expect(hooks.scrolledTo, [0, homeTourMidZoneOffset, 600]);
    expect(hooks.homeScrollOffset, 600);

    // The mid offset clamps to the list's own maximum.
    hooks.homeScrollMax = 100;
    script.onStepChanged(script.stops.indexOf(HomeTourStop.quran));
    expect(hooks.scrolledTo.last, 100);

    // The closing card returns the user's place at once.
    script.onStepChanged(script.stops.indexOf(HomeTourStop.closing));
    expect(hooks.scrolledTo.last, 40);
    expect(hooks.homeScrollOffset, 40);

    script.onTourEnd();
    expect(hooks.scrolledTo.last, 40);
  });

  test('a step report from another tour moves nothing', () {
    final script = scriptFor();
    tour.start(
      steps: const [TourStep(title: 'other', description: '')],
    );
    script.onStepChanged(0);
    expect(hooks.scrolledTo, isEmpty);

    // Nor an index this tour does not have.
    startAt(script, HomeTourStop.intro);
    script.onStepChanged(script.stops.length);
    expect(hooks.scrolledTo, isEmpty);
  });

  test('every tour text exists in all 11 locale files', () {
    for (final locale in locales) {
      final strings =
          jsonDecode(File('assets/locales/$locale.json').readAsStringSync())
              as Map<String, dynamic>;
      for (final stop in HomeTourStop.values) {
        for (final key in [homeTourTitleKey(stop), homeTourDescKey(stop)]) {
          expect(
            strings[key],
            isA<String>().having((s) => s.trim(), 'not blank', isNotEmpty),
            reason: '$locale.json is missing "$key"',
          );
        }
      }
    }
  });
}

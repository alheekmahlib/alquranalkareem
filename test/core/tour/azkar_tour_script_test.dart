import 'dart:convert';
import 'dart:io';

import 'package:alquranalkareem/core/tour/azkar_tour_script.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotlight_tour/spotlight_tour.dart';

/// يسجّل ما طلب السيناريو من التطبيق بدل كنترولر الأذكار الحقيقي: ظهور
/// قائمة الأقسام، وموضعَي تمرير القائمة وشاشة القسم.
class _FakeHooks implements AzkarTourHooks {
  @override
  bool hasAzkarCategoriesVisible = true;

  /// موضع تمرير قائمة الأقسام الحالي، وكل ما طلبت الجولة تمريرها إليه.
  double listOffset = 0.0;
  final listScrolledTo = <double>[];

  /// موضع تمرير شاشة القسم الحالي، وكل ما طلبت الجولة تمريرها إليه.
  double itemOffset = 0.0;
  final itemScrolledTo = <double>[];

  @override
  double get azkarListScrollOffset => listOffset;

  @override
  void scrollAzkarListTo(double value) {
    listScrolledTo.add(value);
    listOffset = value;
  }

  @override
  double get azkarItemScrollOffset => itemOffset;

  @override
  void scrollAzkarItemTo(double value) {
    itemScrolledTo.add(value);
    itemOffset = value;
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

  /// سيناريو جولة الشاشة الرئيسية مربوطاً على الكنترولر.
  AzkarTourScript scriptFor() {
    final script = AzkarTourScript(
      tour: tour,
      hooks: hooks,
      style: const TourStepStyle(),
      hasCategoriesVisible: hooks.hasAzkarCategoriesVisible,
    );
    tour.onStepChanged = script.onStepChanged;
    return script;
  }

  /// سيناريو جولة شاشة القسم مربوطاً على الكنترولر.
  AzkarItemTourScript itemScriptFor() {
    final script = AzkarItemTourScript(
      tour: tour,
      hooks: hooks,
      style: const TourStepStyle(),
    );
    tour.onStepChanged = script.onStepChanged;
    return script;
  }

  /// يبدأ جولة الشاشة الرئيسية على محطة معيّنة.
  void startAt(AzkarTourScript script, AzkarTourStop stop) =>
      tour.start(steps: script.steps, initialIndex: script.stops.indexOf(stop));

  /// يبدأ جولة شاشة القسم على محطة معيّنة.
  void startItemAt(AzkarItemTourScript script, AzkarItemTourStop stop) =>
      tour.start(steps: script.steps, initialIndex: script.stops.indexOf(stop));

  test('azkar tour texts are read under keys derived from the stop name', () {
    expect(azkarTourTitleKey(AzkarTourStop.intro), 'azkarTourIntroTitle');
    expect(azkarTourDescKey(AzkarTourStop.tabs), 'azkarTourTabsDesc');
    // A title that is only the feature's own name reuses the app's key
    // for it instead of duplicating the same word under a tour key.
    expect(azkarTourTitleKey(AzkarTourStop.alarm), 'reminders');
    expect(azkarTourTitleKey(AzkarTourStop.search), 'searchAzkar');
    // The closing card's title is the same for every tour.
    expect(azkarTourTitleKey(AzkarTourStop.closing), 'mushafTourClosingTitle');
  });

  test('item tour texts are read under keys derived from the stop name', () {
    expect(
      azkarItemTourTitleKey(AzkarItemTourStop.intro),
      'azkarItemTourIntroTitle',
    );
    expect(
      azkarItemTourDescKey(AzkarItemTourStop.optionsRow),
      'azkarItemTourOptionsRowDesc',
    );
    // Feature-name titles reuse the app's keys for them.
    expect(azkarItemTourTitleKey(AzkarItemTourStop.fontSize), 'fontSize');
    expect(
      azkarItemTourTitleKey(AzkarItemTourStop.closing),
      'mushafTourClosingTitle',
    );
  });

  test('each tour has one step per stop, intro first and closing last', () {
    hooks.hasAzkarCategoriesVisible = true;
    final script = scriptFor();
    expect(script.steps.length, AzkarTourStop.values.length);
    expect(script.steps.first.title, 'azkarTourIntroTitle');
    expect(script.steps.first.targetKey, isNull);
    expect(script.steps.last.title, 'mushafTourClosingTitle');
    expect(script.steps.last.targetKey, isNull);

    final item = itemScriptFor();
    expect(item.steps.length, AzkarItemTourStop.values.length);
    expect(item.steps.first.targetKey, isNull);
    expect(item.steps.last.targetKey, isNull);
  });

  test('each azkar stop points at the widget tagged for it', () {
    hooks.hasAzkarCategoriesVisible = true;
    // The step is looked up in the stops list of the very tour, not by the
    // enum index, in case a state drops a stop before it.
    Key? targetOf(AzkarTourStop stop) {
      final script = scriptFor();
      return script.steps[script.stops.indexOf(stop)].targetKey;
    }

    expect(targetOf(AzkarTourStop.tabs), same(AzkarTourKeys.tabs));
    expect(targetOf(AzkarTourStop.alarm), same(AzkarTourKeys.alarm));
    expect(targetOf(AzkarTourStop.search), same(AzkarTourKeys.search));
    expect(targetOf(AzkarTourStop.categories), same(AzkarTourKeys.categories));
  });

  test('each item stop points at the widget tagged for it', () {
    Key? targetOf(AzkarItemTourStop stop) {
      final script = itemScriptFor();
      return script.steps[script.stops.indexOf(stop)].targetKey;
    }

    expect(targetOf(AzkarItemTourStop.fontSize), same(AzkarTourKeys.fontSize));
    expect(
      targetOf(AzkarItemTourStop.optionsRow),
      same(AzkarTourKeys.optionsRow),
    );
    expect(targetOf(AzkarItemTourStop.zekrText), same(AzkarTourKeys.zekrText));
  });

  test('the categories stop drops while a search replaces the list', () {
    // A live search swaps the categories list for its results, so the stop
    // has no target on the screen and drops from the tour.
    hooks.hasAzkarCategoriesVisible = false;
    final searching = scriptFor();
    expect(searching.stops, isNot(contains(AzkarTourStop.categories)));

    hooks.hasAzkarCategoriesVisible = true;
    final full = scriptFor();
    expect(full.stops, contains(AzkarTourStop.categories));
    // The tour order is preserved either way.
    expect(full.stops.length, AzkarTourStop.values.length);
  });

  test('the item tour order: font size, options row, then the zekr text', () {
    final script = itemScriptFor();
    expect(script.stops.first, AzkarItemTourStop.intro);
    expect(script.stops[1], AzkarItemTourStop.fontSize);
    expect(script.stops.last, AzkarItemTourStop.closing);
    expect(script.stops, <AzkarItemTourStop>[
      AzkarItemTourStop.intro,
      AzkarItemTourStop.fontSize,
      AzkarItemTourStop.optionsRow,
      AzkarItemTourStop.zekrText,
      AzkarItemTourStop.closing,
    ]);
  });

  test('the azkar tour pins the list to its top for the categories, then '
      'restores', () {
    hooks.listOffset = 120;
    hooks.hasAzkarCategoriesVisible = true;
    final script = scriptFor();

    startAt(script, AzkarTourStop.categories);
    expect(hooks.listScrolledTo, [0]);
    expect(hooks.listOffset, 0);

    // The closing card leaves the list where the tour needs nothing of it.
    script.onStepChanged(script.stops.indexOf(AzkarTourStop.closing));
    expect(hooks.listScrolledTo, [0, 120]);

    script.onTourEnd();
    expect(hooks.listScrolledTo, [0, 120]);
  });

  test('the item tour pins the screen to its top for the first zekr, then '
      'restores', () {
    // Arriving from a search result scrolls the screen deep down to a far
    // zekr; the first zekr's stops pin it back to the top and the user's
    // place returns at the end.
    hooks.itemOffset = 300;
    final script = itemScriptFor();

    startItemAt(script, AzkarItemTourStop.intro);
    expect(hooks.itemScrolledTo, isEmpty);

    script.onStepChanged(script.stops.indexOf(AzkarItemTourStop.fontSize));
    expect(hooks.itemScrolledTo, isEmpty);

    script.onStepChanged(script.stops.indexOf(AzkarItemTourStop.optionsRow));
    expect(hooks.itemScrolledTo, [0]);
    expect(hooks.itemOffset, 0);

    // Still pinned on the zekr text, with no further scrolls.
    script.onStepChanged(script.stops.indexOf(AzkarItemTourStop.zekrText));
    expect(hooks.itemScrolledTo, [0]);

    // The closing card returns the user's place at once.
    script.onStepChanged(script.stops.indexOf(AzkarItemTourStop.closing));
    expect(hooks.itemScrolledTo, [0, 300]);

    script.onTourEnd();
    expect(hooks.itemScrolledTo, [0, 300]);
  });

  test('a step report from another tour moves nothing', () {
    final script = scriptFor();
    tour.start(
      steps: const [TourStep(title: 'other', description: '')],
    );
    script.onStepChanged(0);
    expect(hooks.listScrolledTo, isEmpty);

    // Nor an index this tour does not have.
    startAt(script, AzkarTourStop.intro);
    script.onStepChanged(script.stops.length);
    expect(hooks.listScrolledTo, isEmpty);

    // The same guard holds for the item script.
    final item = itemScriptFor();
    tour.start(
      steps: const [TourStep(title: 'other', description: '')],
    );
    item.onStepChanged(0);
    expect(hooks.itemScrolledTo, isEmpty);
  });

  test('every tour text exists in all 11 locale files', () {
    for (final locale in locales) {
      final strings =
          jsonDecode(File('assets/locales/$locale.json').readAsStringSync())
              as Map<String, dynamic>;
      for (final stop in AzkarTourStop.values) {
        for (final key in [azkarTourTitleKey(stop), azkarTourDescKey(stop)]) {
          expect(
            strings[key],
            isA<String>().having((s) => s.trim(), 'not blank', isNotEmpty),
            reason: '$locale.json is missing "$key"',
          );
        }
      }
      for (final stop in AzkarItemTourStop.values) {
        for (final key in [
          azkarItemTourTitleKey(stop),
          azkarItemTourDescKey(stop),
        ]) {
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

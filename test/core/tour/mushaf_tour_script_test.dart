import 'dart:convert';
import 'dart:io';

import 'package:alquranalkareem/core/tour/mushaf_tour_script.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotlight_tour/spotlight_tour.dart';

/// يسجّل ما طلب السيناريو من التطبيق بدل وحدات التحكم الحقيقية.
class _FakeHooks implements MushafTourHooks {
  @override
  bool isControlsVisible = false;

  @override
  bool isAyahMenuOpen = false;

  int toggles = 0;
  int collapses = 0;
  int opens = 0;
  int closes = 0;
  final log = <String>[];

  @override
  Future<void> captureReadingPage() async => log.add('capture');

  @override
  Future<void> restoreReadingPage() async => log.add('restore');

  @override
  void toggleControls() {
    toggles++;
    isControlsVisible = !isControlsVisible;
  }

  @override
  void collapsePanels() => collapses++;

  @override
  void openAyahMenu() {
    opens++;
    isAyahMenuOpen = true;
  }

  @override
  void closeAyahMenu() {
    closes++;
    isAyahMenuOpen = false;
  }
}

void main() {
  final pageKey = GlobalKey();
  final controlsBarKey = GlobalKey();
  final chromeStops = MushafTourStop.values
      .where(
        (stop) => mushafTourControlsFor(stop) == MushafTourControls.visible,
      )
      .toList();
  final menuStops = MushafTourStop.values
      .where((stop) => mushafTourIsInAyahMenu(stop))
      .toList();
  final longPress = MushafTourStop.ayahLongPress.index;

  late _FakeHooks hooks;
  late SpotlightTourController tour;
  late MushafTourScript script;
  late PageSwipeDemo demo;

  setUp(() {
    hooks = _FakeHooks();
    tour = SpotlightTourController(
      completionStore: InMemoryTourCompletionStore(),
    );
    demo = PageSwipeDemo(
      pageController: PageController(),
      vsync: const TestVSync(),
    );
    script = MushafTourScript(
      tour: tour,
      hooks: hooks,
      style: const TourStepStyle(),
      swipeDemo: demo,
      pageKey: pageKey,
      controlsBarKey: controlsBarKey,
    );
    tour.onStepChanged = script.onStepChanged;
  });

  tearDown(() => demo.dispose());

  /// يبدأ الجولة على محطة معيّنة بنفس خطوات السيناريو.
  void startAt(MushafTourStop stop) =>
      tour.start(steps: script.steps, initialIndex: stop.index);

  test('step texts are read under keys derived from the stop name', () {
    expect(
      mushafTourTitleKey(MushafTourStop.ayahLongPress),
      'mushafTourAyahLongPressTitle',
    );
    expect(
      mushafTourDescKey(MushafTourStop.playAyahWords),
      'mushafTourPlayAyahWordsDesc',
    );
    // A title that is only the feature's own name reuses the app's key
    // for it instead of duplicating the same word under a tour key.
    expect(mushafTourTitleKey(MushafTourStop.settings), 'setting');
    expect(mushafTourTitleKey(MushafTourStop.copy), 'copy');
    expect(mushafTourTitleKey(MushafTourStop.mutashabihat), 'mutashabihat');
    expect(mushafTourTitleKey(MushafTourStop.alwaqf), 'stopSigns');
    expect(
      mushafTourDescKey(MushafTourStop.settings),
      'mushafTourSettingsDesc',
    );
  });

  test('the tour has one step per stop, intro first and closing last', () {
    expect(script.steps.first.title, 'mushafTourIntroTitle');
    expect(script.steps.first.targetKey, isNull);
    expect(script.steps.last.title, 'mushafTourClosingTitle');
    expect(script.steps.last.targetKey, isNull);
    expect(
      script.steps[MushafTourStop.intro.index + 1].title,
      'mushafTourPageFlipTitle',
    );
  });

  test('each stop points at the widget tagged for it', () {
    // Globals owned by the tour service: the whole page and the top bar.
    expect(
      script.steps[MushafTourStop.pageFlip.index].targetKey,
      same(pageKey),
    );
    expect(
      script.steps[MushafTourStop.ayahLongPress.index].targetKey,
      same(pageKey),
    );
    expect(
      script.steps[MushafTourStop.controlsBar.index].targetKey,
      same(controlsBarKey),
    );
    // Plain keys: these widgets are mounted more than once at a time.
    expect(
      script.steps[MushafTourStop.settings.index].targetKey,
      same(MushafTourKeys.settings),
    );
    expect(
      script.steps[MushafTourStop.tafsir.index].targetKey,
      same(MushafTourKeys.tafsir),
    );
    expect(
      script.steps[MushafTourStop.pageBookmark.index].targetKey,
      same(MushafTourKeys.pageBookmark),
    );
  });

  test('the ayah-menu stops form one unbroken run after the long press', () {
    expect(menuStops.length, 12);
    expect(menuStops.first.index, longPress + 1);
    for (var i = 1; i < menuStops.length; i++) {
      expect(menuStops[i].index, menuStops[i - 1].index + 1);
    }
    // Leaving the run in either direction must step out of the sheet.
    expect(mushafTourIsInAyahMenu(MushafTourStop.values[longPress]), isFalse);
    expect(
      mushafTourIsInAyahMenu(MushafTourStop.values[menuStops.last.index + 1]),
      isFalse,
    );
  });

  test('only the long-press stop waits for a real long press', () {
    final step = script.steps[longPress];
    expect(step.requireInteraction, isTrue);
    expect(step.interaction, TourTargetInteraction.longPress);
    expect(step.interactionHint, 'mushafTourAyahLongPressHint');

    for (final other in MushafTourStop.values.where(
      (stop) => stop != MushafTourStop.ayahLongPress,
    )) {
      expect(
        script.steps[other.index].requireInteraction,
        isFalse,
        reason: other.name,
      );
    }
  });

  test('the page-flip step saves and restores the reading page', () async {
    final step = script.steps[MushafTourStop.pageFlip.index];
    await step.onEnter?.call();
    await step.onExit?.call();
    expect(hooks.log, ['capture', 'restore']);
  });

  test('entering an ayah-menu stop opens the sheet only when it is closed', () {
    startAt(MushafTourStop.ayahText);
    expect(hooks.opens, 1);
    expect(hooks.isAyahMenuOpen, isTrue);

    // Back from the closing card into the sheet: reopened with the same ayah.
    hooks.isAyahMenuOpen = false;
    startAt(MushafTourStop.mutashabihat);
    expect(hooks.opens, 2);

    // Already open (the user just long-pressed): never opened twice.
    startAt(MushafTourStop.playWord);
    expect(hooks.opens, 2);
  });

  test('leaving the ayah-menu stops closes the sheet once', () {
    startAt(MushafTourStop.wordInfo);
    expect(hooks.closes, 0);

    // Walking on inside the sheet keeps it open, up to its last stop.
    while (tour.index != menuStops.last.index) {
      tour.next();
    }
    expect(tour.index, MushafTourStop.mutashabihat.index);
    expect(hooks.closes, 0);

    // Out of the sheet, forward to the closing card.
    tour.next();
    expect(tour.index, MushafTourStop.closing.index);
    expect(hooks.isAyahMenuOpen, isFalse);
    expect(hooks.closes, 1);

    // Out of the sheet, backward to the long-press stop.
    hooks.isAyahMenuOpen = true;
    tour.start(
      steps: script.steps,
      initialIndex: MushafTourStop.ayahText.index,
    );
    expect(hooks.closes, 1);
    tour.previous();
    expect(tour.index, longPress);
    expect(hooks.closes, 2);

    // Closing what is already closed does nothing.
    startAt(MushafTourStop.intro);
    expect(hooks.closes, 2);
  });

  test('a long press advances the tour only on the long-press stop', () {
    // Somewhere else on the page a long press is the app's own business.
    startAt(MushafTourStop.pageBookmark);
    tour.currentStep!.onEnter?.call();
    script.onAyahMenuOpened();
    expect(tour.index, MushafTourStop.pageBookmark.index);

    // The step is on screen (the tour ran its onEnter) and waits.
    startAt(MushafTourStop.ayahLongPress);
    tour.currentStep!.onEnter!.call();
    script.onAyahMenuOpened();
    expect(tour.index, longPress + 1);
    expect(hooks.isAyahMenuOpen, isTrue);

    // Inside the sheet another open request must not skip a step.
    script.onAyahMenuOpened();
    expect(tour.index, longPress + 1);
  });

  test(
    'the sheet closed by the user mid-menu returns to the long press',
    () async {
      startAt(MushafTourStop.tafsir);
      script.onAyahMenuClosed();

      expect(tour.status, TourStatus.running);
      expect(tour.index, longPress);
      expect(identical(tour.steps, script.steps), isTrue);

      // The step is live again: a new long press re-enters the sheet.
      await tour.currentStep?.onEnter?.call();
      script.onAyahMenuOpened();
      expect(tour.index, longPress + 1);
    },
  );

  test('the sheet closed outside the ayah-menu stops moves nothing', () {
    startAt(MushafTourStop.controlsBar);
    script.onAyahMenuClosed();
    expect(tour.index, MushafTourStop.controlsBar.index);

    // Nor once the tour is over.
    tour.skip();
    script.onAyahMenuClosed();
    expect(tour.status, TourStatus.closing);
    expect(tour.index, MushafTourStop.controlsBar.index);
  });

  test('chrome stops fold the open panels; other stops do not touch them', () {
    startAt(MushafTourStop.intro);
    expect(hooks.collapses, 0);

    tour.next();
    tour.next();
    expect(hooks.collapses, 1);

    // The next chrome stop folds them again: one may have been reopened.
    tour.next();
    expect(hooks.collapses, 2);

    tour.start(
      steps: script.steps,
      initialIndex: MushafTourStop.pageBookmark.index,
    );
    expect(hooks.collapses, 2);
  });

  test('the page bookmark stop hides the controls the mark sits under', () {
    // The user has the bars shown: the top bar covers the page's mark.
    hooks.isControlsVisible = true;
    startAt(MushafTourStop.pageBookmark);
    expect(hooks.isControlsVisible, isFalse);

    // The long-press stop needs nothing from the controls: shown again.
    tour.next();
    expect(tour.index, longPress);
    expect(hooks.isControlsVisible, isTrue);
    expect(hooks.toggles, 2);
  });

  test(
    'bars the user already hid stay hidden through the page bookmark stop',
    () {
      startAt(MushafTourStop.pageBookmark);
      tour.next();
      expect(hooks.toggles, 0);
      expect(hooks.isControlsVisible, isFalse);
    },
  );

  test("after chrome stops the bars return to the user's hidden ones", () {
    // Hidden by the user, revealed for the chrome stops.
    startAt(MushafTourStop.bookmarks);
    expect(hooks.isControlsVisible, isTrue);

    // The page bookmark stop hides them again, which happens to be the
    // user's own state: there is nothing further to restore after it.
    tour.next();
    expect(tour.index, MushafTourStop.pageBookmark.index);
    expect(hooks.isControlsVisible, isFalse);
    tour.next();
    expect(hooks.toggles, 2);
    expect(hooks.isControlsVisible, isFalse);
  });

  test('ending the tour on the page bookmark stop gives the controls back', () {
    hooks.isControlsVisible = true;
    startAt(MushafTourStop.pageBookmark);
    script.onTourEnd();
    expect(hooks.isControlsVisible, isTrue);
  });

  test('controls the tour revealed stay until it leaves the chrome stops', () {
    // The user had hidden the bars.
    startAt(MushafTourStop.controlsBar);
    expect(hooks.toggles, 1);
    expect(hooks.isControlsVisible, isTrue);

    // All the way through the last chrome stop: no flicker between steps.
    for (var i = 1; i < chromeStops.length; i++) {
      tour.next();
    }
    expect(tour.index, chromeStops.last.index);
    expect(hooks.toggles, 1);

    // The next stop is the in-page bookmark: the bars go back to hidden.
    tour.next();
    expect(tour.index, MushafTourStop.pageBookmark.index);
    expect(hooks.toggles, 2);
    expect(hooks.isControlsVisible, isFalse);
  });

  test('controls the user already shows are left alone', () {
    hooks.isControlsVisible = true;
    startAt(MushafTourStop.intro);
    tour.next();
    tour.next();
    tour.next();
    tour.next();
    expect(hooks.toggles, 0);
    expect(hooks.isControlsVisible, isTrue);
  });

  test(
    'ending the tour restores controls it revealed and closes the sheet',
    () {
      startAt(MushafTourStop.search);
      hooks.isAyahMenuOpen = true;
      expect(hooks.toggles, 1);

      script.onTourEnd();
      expect(hooks.isControlsVisible, isFalse);
      expect(hooks.isAyahMenuOpen, isFalse);
    },
  );

  test('every tour text exists in all 11 locale files', () {
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
    const labelKeys = [
      // Tour buttons and counter.
      'mushafTourPrevious',
      'mushafTourDone',
      'mushafTourInteractionHint',
      'mushafTourCounter',
      'next',
      'start',
      'skip',
      // The long-press step's hint.
      'mushafTourAyahLongPressHint',
    ];
    for (final locale in locales) {
      final strings =
          jsonDecode(File('assets/locales/$locale.json').readAsStringSync())
              as Map<String, dynamic>;
      for (final stop in MushafTourStop.values) {
        for (final key in [mushafTourTitleKey(stop), mushafTourDescKey(stop)]) {
          expect(
            strings[key],
            isA<String>().having((s) => s.trim(), 'not blank', isNotEmpty),
            reason: '$locale.json is missing "$key"',
          );
        }
      }
      for (final key in labelKeys) {
        expect(
          strings[key],
          isA<String>().having((s) => s.trim(), 'not blank', isNotEmpty),
          reason: '$locale.json is missing "$key"',
        );
      }
    }
  });
}

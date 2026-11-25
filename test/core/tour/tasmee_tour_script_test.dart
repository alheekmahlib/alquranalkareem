import 'dart:convert';
import 'dart:io';

import 'package:alquranalkareem/core/tour/mushaf_tour_script.dart';
import 'package:alquranalkareem/core/tour/tasmee_tour_script.dart';
import 'package:alquranalkareem/core/tour/tour_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_library/quran_library.dart';
import 'package:spotlight_tour/spotlight_tour.dart';

/// يسجّل ما طلب السيناريو من التطبيق بدل وحدات التحكم الحقيقية.
class _FakeHooks implements TourControlsHooks {
  @override
  bool isControlsVisible = false;

  int toggles = 0;
  int collapses = 0;

  @override
  void toggleControls() {
    toggles++;
    isControlsVisible = !isControlsVisible;
  }

  @override
  void collapsePanels() => collapses++;
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
  const modes = TasmeeMode.values;

  late _FakeHooks hooks;
  late SpotlightTourController tour;

  setUp(() {
    hooks = _FakeHooks();
    tour = SpotlightTourController(
      completionStore: InMemoryTourCompletionStore(),
    );
  });

  /// سيناريو في نمط تسميع معيّن، مربوطاً على الكنترولر.
  TasmeeTourScript scriptFor(TasmeeMode mode) {
    final script = TasmeeTourScript(
      tour: tour,
      hooks: hooks,
      style: const TourStepStyle(),
      mode: mode,
    );
    tour.onStepChanged = script.onStepChanged;
    return script;
  }

  /// يبدأ الجولة على محطة معيّنة من محطات السيناريو.
  void startAt(TasmeeTourScript script, TasmeeTourStop stop) =>
      tour.start(steps: script.steps, initialIndex: script.stops.indexOf(stop));

  test('step texts are read under keys derived from the stop name', () {
    expect(tasmeeTourTitleKey(TasmeeTourStop.intro), 'tasmeeTourIntroTitle');
    expect(
      tasmeeTourDescKey(TasmeeTourStop.startRecording),
      'tasmeeTourStartRecordingDesc',
    );
    // A title that is only the feature's own name reuses the app's key
    // for it instead of duplicating the same word under a tour key.
    expect(tasmeeTourTitleKey(TasmeeTourStop.modeButton), 'tasmeeModeTitle');
    expect(
      tasmeeTourTitleKey(TasmeeTourStop.startRecording),
      'tasmeeStartRecording',
    );
    expect(tasmeeTourTitleKey(TasmeeTourStop.retry), 'tasmeeRetry');
    expect(tasmeeTourTitleKey(TasmeeTourStop.pagesList), 'tasmeeResultsPages');
    expect(tasmeeTourTitleKey(TasmeeTourStop.settings), 'setting');
    // The closing card's title is the same for every tour.
    expect(
      tasmeeTourTitleKey(TasmeeTourStop.closing),
      'mushafTourClosingTitle',
    );
  });

  test('the tour has one step per stop, intro first and closing last', () {
    for (final mode in modes) {
      final script = scriptFor(mode);
      expect(script.steps.length, script.stops.length, reason: mode.name);
      expect(script.steps.first.title, 'tasmeeTourIntroTitle');
      expect(script.steps.first.targetKey, isNull);
      expect(script.steps.last.title, 'mushafTourClosingTitle');
      expect(script.steps.last.targetKey, isNull);
    }
  });

  test('stops are chosen by the Tasmee mode and keep the tour order', () {
    // The eye button belongs to the Recite mode alone: the words are
    // visible by design in the other two.
    expect(scriptFor(TasmeeMode.tasmee).stops, [
      TasmeeTourStop.intro,
      TasmeeTourStop.modeButton,
      TasmeeTourStop.startRecording,
      TasmeeTourStop.status,
      TasmeeTourStop.showWords,
      TasmeeTourStop.retry,
      TasmeeTourStop.pagesList,
      TasmeeTourStop.settings,
      TasmeeTourStop.closing,
    ]);
    expect(scriptFor(TasmeeMode.corrector).stops, [
      TasmeeTourStop.intro,
      TasmeeTourStop.modeButton,
      TasmeeTourStop.startRecording,
      TasmeeTourStop.status,
      TasmeeTourStop.retry,
      TasmeeTourStop.pagesList,
      TasmeeTourStop.settings,
      TasmeeTourStop.closing,
    ]);
    // The reciter picker is laid out only in the teacher mode.
    expect(scriptFor(TasmeeMode.teacher).stops, [
      TasmeeTourStop.intro,
      TasmeeTourStop.modeButton,
      TasmeeTourStop.teacherReader,
      TasmeeTourStop.startRecording,
      TasmeeTourStop.status,
      TasmeeTourStop.retry,
      TasmeeTourStop.pagesList,
      TasmeeTourStop.settings,
      TasmeeTourStop.closing,
    ]);

    // Never reordered: a stop always follows the stops before it in the
    // enum, whichever of them the mode leaves out.
    for (final mode in modes) {
      final stops = scriptFor(mode).stops;
      for (var i = 1; i < stops.length; i++) {
        expect(
          stops[i].index,
          greaterThan(stops[i - 1].index),
          reason: mode.name,
        );
      }
    }
  });

  test('each stop points at the widget tagged for it', () {
    TasmeeTourScript inModeOf(TasmeeTourStop stop) => scriptFor(switch (stop) {
      TasmeeTourStop.showWords => TasmeeMode.tasmee,
      TasmeeTourStop.teacherReader => TasmeeMode.teacher,
      _ => TasmeeMode.corrector,
    });

    Key? targetOf(TasmeeTourStop stop) =>
        inModeOf(stop).steps[inModeOf(stop).stops.indexOf(stop)].targetKey;

    // The settings button is the screen's own: the Mushaf tour targets
    // the very same widget.
    expect(targetOf(TasmeeTourStop.settings), same(MushafTourKeys.settings));

    // Plain keys: the bar sits in a sheet handle, never a GlobalKey.
    expect(
      targetOf(TasmeeTourStop.modeButton),
      same(TasmeeTourKeys.modeButton),
    );
    expect(
      targetOf(TasmeeTourStop.teacherReader),
      same(TasmeeTourKeys.teacherReader),
    );
    expect(
      targetOf(TasmeeTourStop.startRecording),
      same(TasmeeTourKeys.startRecording),
    );
    expect(targetOf(TasmeeTourStop.status), same(TasmeeTourKeys.status));
    expect(targetOf(TasmeeTourStop.showWords), same(TasmeeTourKeys.showWords));
    expect(targetOf(TasmeeTourStop.retry), same(TasmeeTourKeys.retry));
    expect(targetOf(TasmeeTourStop.pagesList), same(TasmeeTourKeys.pagesList));
  });

  test('no step waits for the user', () {
    for (final mode in modes) {
      for (final step in scriptFor(mode).steps) {
        expect(
          step.requireInteraction,
          isFalse,
          reason:
              '${mode.name}: '
              '${step.title}',
        );
        expect(step.interaction, TourTargetInteraction.none);
        expect(step.interactionHint, isNull);
      }
    }
  });

  test('every stop but the two cards needs the controls shown', () {
    expect(tasmeeTourNeedsControls(TasmeeTourStop.intro), isFalse);
    expect(tasmeeTourNeedsControls(TasmeeTourStop.closing), isFalse);
    for (final stop in TasmeeTourStop.values.where(
      (stop) => stop != TasmeeTourStop.intro && stop != TasmeeTourStop.closing,
    )) {
      expect(tasmeeTourNeedsControls(stop), isTrue, reason: stop.name);
    }
  });

  test('the intro card does not touch the controls', () {
    final script = scriptFor(TasmeeMode.tasmee);
    startAt(script, TasmeeTourStop.intro);
    expect(hooks.toggles, 0);
    expect(hooks.collapses, 0);
    expect(hooks.isControlsVisible, isFalse);
  });

  test('chrome stops reveal the hidden controls once and keep them', () {
    final script = scriptFor(TasmeeMode.tasmee);
    startAt(script, TasmeeTourStop.modeButton);
    expect(hooks.isControlsVisible, isTrue);
    expect(hooks.toggles, 1);

    // All the way to the settings button: no flicker between steps, and
    // the panels are folded again on each of them.
    while (tour.index < script.stops.indexOf(TasmeeTourStop.settings)) {
      tour.next();
    }
    expect(tour.index, script.stops.indexOf(TasmeeTourStop.settings));
    expect(hooks.toggles, 1);
    expect(hooks.collapses, script.stops.indexOf(TasmeeTourStop.settings));
  });

  test('the closing card returns the controls to the user', () {
    final script = scriptFor(TasmeeMode.tasmee);
    startAt(script, TasmeeTourStop.settings);
    tour.next();
    expect(tour.index, script.stops.indexOf(TasmeeTourStop.closing));
    expect(hooks.isControlsVisible, isFalse);
    expect(hooks.toggles, 2);
  });

  test('walking back from a chrome stop returns the controls too', () {
    final script = scriptFor(TasmeeMode.tasmee);
    startAt(script, TasmeeTourStop.modeButton);
    tour.previous();
    expect(tour.index, script.stops.indexOf(TasmeeTourStop.intro));
    expect(hooks.isControlsVisible, isFalse);
    expect(hooks.toggles, 2);

    // Forward again: taken from the user's hidden state once more.
    tour.next();
    expect(hooks.toggles, 3);
    expect(hooks.isControlsVisible, isTrue);
  });

  test('ending the tour restores the controls it revealed', () {
    final script = scriptFor(TasmeeMode.teacher);
    startAt(script, TasmeeTourStop.retry);
    expect(hooks.toggles, 1);
    script.onTourEnd();
    expect(hooks.isControlsVisible, isFalse);
    expect(hooks.toggles, 2);
  });

  test('controls the user already shows are left alone', () {
    hooks.isControlsVisible = true;
    final script = scriptFor(TasmeeMode.corrector);
    startAt(script, TasmeeTourStop.status);
    tour.next();
    script.onTourEnd();
    expect(hooks.toggles, 0);
    expect(hooks.isControlsVisible, isTrue);
  });

  test('a step report from another tour moves nothing', () {
    final script = scriptFor(TasmeeMode.tasmee);
    tour.start(
      steps: const [TourStep(title: 'other', description: '')],
    );
    script.onStepChanged(0);
    expect(hooks.toggles, 0);

    // Nor an index this tour does not have.
    startAt(script, TasmeeTourStop.intro);
    script.onStepChanged(script.stops.length);
    expect(hooks.toggles, 0);
  });

  test('every tour text exists in all 11 locale files', () {
    for (final locale in locales) {
      final strings =
          jsonDecode(File('assets/locales/$locale.json').readAsStringSync())
              as Map<String, dynamic>;
      for (final mode in modes) {
        for (final stop in scriptFor(mode).stops) {
          for (final key in [
            tasmeeTourTitleKey(stop),
            tasmeeTourDescKey(stop),
          ]) {
            expect(
              strings[key],
              isA<String>().having((s) => s.trim(), 'not blank', isNotEmpty),
              reason: '$locale.json is missing "$key"',
            );
          }
        }
      }
    }
  });
}

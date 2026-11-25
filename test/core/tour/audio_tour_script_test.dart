import 'dart:convert';
import 'dart:io';

import 'package:alquranalkareem/core/tour/audio_tour_script.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotlight_tour/spotlight_tour.dart';

/// يسجّل ما طلب السيناريو من التطبيق بدل لوحة التشغيل والراوتر الحقيقيين.
class _FakeHooks implements AudioTourHooks {
  @override
  bool isPlayerExpanded = false;

  /// كم مرة بدّلت الجولة اللوحة (expand/collapse معاً).
  int sets = 0;

  /// الشاشة الكاملة مفتوحة (محاكاة موضع الراوتر).
  bool onFullScreen = false;
  int opens = 0;
  int closes = 0;

  /// موضع تمرير قائمة السور (محاكاة ScrollController).
  @override
  double surahListOffset = 0;
  int jumps = 0;

  @override
  void scrollSurahListTo(double offset) {
    jumps++;
    surahListOffset = offset;
  }

  @override
  void setPlayerExpanded(bool expanded) {
    sets++;
    isPlayerExpanded = expanded;
  }

  @override
  Future<void> openFullScreen() async {
    if (onFullScreen) return;
    onFullScreen = true;
    opens++;
  }

  @override
  void closeFullScreen() {
    if (!onFullScreen) return;
    onFullScreen = false;
    closes++;
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

  /// سيناريو مربوطاً على الكنترولر.
  AudioTourScript scriptFor() {
    final script = AudioTourScript(
      tour: tour,
      hooks: hooks,
      style: const TourStepStyle(),
    );
    tour.onStepChanged = script.onStepChanged;
    return script;
  }

  /// يبدأ الجولة على محطة معيّنة من محطات السيناريو.
  void startAt(AudioTourScript script, AudioTourStop stop) => tour.start(
    steps: script.steps,
    initialIndex: AudioTourStop.values.indexOf(stop),
  );

  test('step texts are read under keys derived from the stop name', () {
    expect(audioTourTitleKey(AudioTourStop.intro), 'audioTourIntroTitle');
    expect(audioTourDescKey(AudioTourStop.seekBar), 'audioTourSeekBarDesc');
    // A title that is only the feature's own name reuses the app's key
    // for it instead of duplicating the same word under a tour key.
    expect(audioTourTitleKey(AudioTourStop.search), 'searchToSurah');
    expect(audioTourTitleKey(AudioTourStop.lastListen), 'lastListen');
    expect(audioTourTitleKey(AudioTourStop.surahList), 'surahsList');
    expect(audioTourTitleKey(AudioTourStop.download), 'download');
    expect(audioTourTitleKey(AudioTourStop.previousSurah), 'skipToPrevious');
    // The closing card's title is the same for every tour.
    expect(audioTourTitleKey(AudioTourStop.closing), 'mushafTourClosingTitle');
  });

  test('the tour has one step per stop, intro first and closing last', () {
    final script = scriptFor();
    expect(script.steps.length, AudioTourStop.values.length);
    expect(script.steps.first.title, 'audioTourIntroTitle');
    expect(script.steps.first.targetKey, isNull);
    expect(script.steps.last.title, 'mushafTourClosingTitle');
    expect(script.steps.last.targetKey, isNull);
  });

  test('each stop points at the widget tagged for it', () {
    Key? targetOf(AudioTourStop stop) =>
        scriptFor().steps[AudioTourStop.values.indexOf(stop)].targetKey;

    expect(targetOf(AudioTourStop.search), same(AudioTourKeys.search));
    expect(targetOf(AudioTourStop.lastListen), same(AudioTourKeys.lastListen));
    expect(
      targetOf(AudioTourStop.fullScreenButton),
      same(AudioTourKeys.fullScreenButton),
    );
    expect(targetOf(AudioTourStop.surahList), same(AudioTourKeys.surahList));
    expect(targetOf(AudioTourStop.download), same(AudioTourKeys.download));
    expect(
      targetOf(AudioTourStop.collapsedPlayer),
      same(AudioTourKeys.collapsedPlayer),
    );
    expect(
      targetOf(AudioTourStop.reciterPicker),
      same(AudioTourKeys.reciterPicker),
    );
    expect(targetOf(AudioTourStop.seekBar), same(AudioTourKeys.seekBar));
    expect(targetOf(AudioTourStop.backward), same(AudioTourKeys.backward));
    expect(
      targetOf(AudioTourStop.previousSurah),
      same(AudioTourKeys.previousSurah),
    );
    expect(targetOf(AudioTourStop.playPause), same(AudioTourKeys.playPause));
    expect(targetOf(AudioTourStop.nextSurah), same(AudioTourKeys.nextSurah));
    expect(targetOf(AudioTourStop.forward), same(AudioTourKeys.forward));
    expect(targetOf(AudioTourStop.repeat), same(AudioTourKeys.repeat));
    expect(
      targetOf(AudioTourStop.ayahTracker),
      same(AudioTourKeys.ayahTracker),
    );
    expect(targetOf(AudioTourStop.readerRow), same(AudioTourKeys.readerRow));
    expect(
      targetOf(AudioTourStop.closeButton),
      same(AudioTourKeys.closeButton),
    );
  });

  test('no step waits for the user', () {
    for (final step in scriptFor().steps) {
      expect(step.requireInteraction, isFalse, reason: step.title);
      expect(step.interaction, TourTargetInteraction.none);
      expect(step.interactionHint, isNull);
    }
  });

  test('exactly the expanded panel and full screen stops are classified', () {
    const panelStops = {
      AudioTourStop.reciterPicker,
      AudioTourStop.seekBar,
      AudioTourStop.backward,
      AudioTourStop.previousSurah,
      AudioTourStop.playPause,
      AudioTourStop.nextSurah,
      AudioTourStop.forward,
      AudioTourStop.repeat,
    };
    const fullScreenStops = {
      AudioTourStop.ayahTracker,
      AudioTourStop.readerRow,
      AudioTourStop.closeButton,
      AudioTourStop.closing,
    };
    for (final stop in AudioTourStop.values) {
      expect(
        audioTourNeedsExpandedPlayer(stop),
        panelStops.contains(stop),
        reason: stop.name,
      );
      expect(
        audioTourIsOnFullScreen(stop),
        fullScreenStops.contains(stop),
        reason: stop.name,
      );
    }
  });

  test('the intro card does not touch the panel', () {
    final script = scriptFor();
    startAt(script, AudioTourStop.intro);
    expect(hooks.sets, 0);
    expect(hooks.isPlayerExpanded, isFalse);
  });

  test('panel stops expand the player once and keep it expanded', () {
    final script = scriptFor();
    startAt(script, AudioTourStop.reciterPicker);
    expect(hooks.isPlayerExpanded, isTrue);
    expect(hooks.sets, 1);

    // All the way to the repeat button: no flicker between steps.
    while (tour.index < AudioTourStop.values.indexOf(AudioTourStop.repeat)) {
      tour.next();
    }
    expect(hooks.sets, 1);
    expect(hooks.isPlayerExpanded, isTrue);
  });

  test('the collapsed bar stop folds an expanded panel', () {
    hooks.isPlayerExpanded = true;
    final script = scriptFor();
    startAt(script, AudioTourStop.collapsedPlayer);
    expect(hooks.isPlayerExpanded, isFalse);
    expect(hooks.sets, 1);
  });

  test('leaving the panel range returns the panel to the user', () {
    final script = scriptFor();
    startAt(script, AudioTourStop.repeat);
    expect(hooks.isPlayerExpanded, isTrue);
    // أول محطة بعد اللوحة على الشاشة الكاملة: اللوحة تحتها تعود للمستخدم.
    tour.next();
    expect(tour.index, AudioTourStop.values.indexOf(AudioTourStop.ayahTracker));
    expect(hooks.isPlayerExpanded, isFalse);
  });

  test('ending the tour restores the panel it expanded', () {
    final script = scriptFor();
    startAt(script, AudioTourStop.playPause);
    expect(hooks.sets, 1);
    script.onTourEnd();
    expect(hooks.isPlayerExpanded, isFalse);
    expect(hooks.sets, 2);
  });

  test('a panel the user already expanded is left alone', () {
    hooks.isPlayerExpanded = true;
    final script = scriptFor();
    startAt(script, AudioTourStop.repeat);
    tour.next();
    script.onTourEnd();
    expect(hooks.sets, 0);
    expect(hooks.isPlayerExpanded, isTrue);
  });

  test('the list stops pin the surah list to its top once', () {
    hooks.surahListOffset = 320;
    final script = scriptFor();
    startAt(script, AudioTourStop.surahList);
    expect(hooks.surahListOffset, 0);
    expect(hooks.jumps, 1);

    // هدف التنزيل زر الصف الأول: تبقى القائمة مثبتة دون تمرير جديد.
    tour.next();
    expect(tour.index, AudioTourStop.values.indexOf(AudioTourStop.download));
    expect(hooks.jumps, 1);
    expect(hooks.surahListOffset, 0);
  });

  test('leaving the list stops returns the user his scroll position', () {
    hooks.surahListOffset = 320;
    final script = scriptFor();
    startAt(script, AudioTourStop.download);
    expect(hooks.surahListOffset, 0);
    tour.next();
    expect(
      tour.index,
      AudioTourStop.values.indexOf(AudioTourStop.collapsedPlayer),
    );
    expect(hooks.surahListOffset, 320);
    expect(hooks.jumps, 2);
  });

  test('a list already at its top is not scrolled', () {
    final script = scriptFor();
    startAt(script, AudioTourStop.download);
    expect(hooks.jumps, 0);
    expect(hooks.surahListOffset, 0);
  });

  test('full screen stops open the screen once and stay on it', () {
    final script = scriptFor();
    startAt(script, AudioTourStop.ayahTracker);
    expect(hooks.onFullScreen, isTrue);
    expect(hooks.opens, 1);

    // Through the closing card: no flicker of closing in between.
    while (tour.index < AudioTourStop.values.indexOf(AudioTourStop.closing)) {
      tour.next();
    }
    expect(hooks.opens, 1);
    expect(hooks.onFullScreen, isTrue);
    expect(hooks.closes, 0);
  });

  test('walking back from the full screen closes it and reopens the panel', () {
    final script = scriptFor();
    startAt(script, AudioTourStop.readerRow);
    // خطوتان للوراء: من صف القارئ إلى المتتبِّع ثم إلى زر التكرار في اللوحة.
    tour.previous();
    expect(tour.index, AudioTourStop.values.indexOf(AudioTourStop.ayahTracker));
    expect(hooks.onFullScreen, isTrue);
    tour.previous();
    expect(tour.index, AudioTourStop.values.indexOf(AudioTourStop.repeat));
    expect(hooks.onFullScreen, isFalse);
    expect(hooks.closes, 1);
    expect(hooks.isPlayerExpanded, isTrue);
  });

  test('ending the tour on the full screen closes it', () {
    final script = scriptFor();
    startAt(script, AudioTourStop.closeButton);
    script.onTourEnd();
    expect(hooks.onFullScreen, isFalse);
    expect(hooks.closes, 1);
  });

  test('a step report from another tour moves nothing', () {
    final script = scriptFor();
    tour.start(
      steps: const [TourStep(title: 'other', description: '')],
    );
    script.onStepChanged(0);
    expect(hooks.sets, 0);
    expect(hooks.opens, 0);

    // Nor an index this tour does not have.
    startAt(script, AudioTourStop.intro);
    script.onStepChanged(AudioTourStop.values.length);
    expect(hooks.sets, 0);
  });

  test('every tour text exists in all 11 locale files', () {
    for (final locale in locales) {
      final strings =
          jsonDecode(File('assets/locales/$locale.json').readAsStringSync())
              as Map<String, dynamic>;
      for (final stop in AudioTourStop.values) {
        for (final key in [audioTourTitleKey(stop), audioTourDescKey(stop)]) {
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

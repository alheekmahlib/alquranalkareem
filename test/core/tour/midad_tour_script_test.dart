import 'dart:convert';
import 'dart:io';

import 'package:alquranalkareem/core/tour/midad_tour_script.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotlight_tour/spotlight_tour.dart';

/// يسجّل ما طلب السيناريو من التطبيق بدل كنترولر مداد والاتصال الحقيقيين.
class _FakeHooks implements MidadTourHooks {
  @override
  bool isMidasAssistantMode = false;

  /// كم مرة بدّلت الجولة الوضع.
  int sets = 0;

  @override
  bool isMidadOnline = true;

  @override
  bool hasMidadSectionLoaded = true;

  @override
  bool isMidadSharedLoaded = false;

  @override
  bool isMidadSemanticEmpty = true;

  @override
  bool isMidadAssistantFresh = true;

  @override
  bool hasMidadProviders = true;

  @override
  Future<void> awaitMidadReady() async {}

  @override
  void setMidasAssistantMode(bool assistant) {
    sets++;
    isMidasAssistantMode = assistant;
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

  /// سيناريو الجولة الكاملة مربوطاً على الكنترولر.
  MidadTourScript scriptFor() {
    final script = MidadTourScript(
      tour: tour,
      hooks: hooks,
      style: const TourStepStyle(),
      online: hooks.isMidadOnline,
      hasProviders: hooks.hasMidadProviders,
      semanticEmpty: hooks.isMidadSemanticEmpty,
      assistantFresh: hooks.isMidadAssistantFresh,
    );
    tour.onStepChanged = script.onStepChanged;
    return script;
  }

  /// سيناريو جولة التحميل مربوطاً على الكنترولر.
  MidadDownloadTourScript downloadScriptFor() {
    final script = MidadDownloadTourScript(
      tour: tour,
      hooks: hooks,
      style: const TourStepStyle(),
      sharedLoaded: hooks.isMidadSharedLoaded,
    );
    tour.onStepChanged = script.onStepChanged;
    return script;
  }

  /// سيناريو جولة المساعد مربوطاً على الكنترولر.
  MidadAssistantTourScript assistantScriptFor() {
    final script = MidadAssistantTourScript(
      tour: tour,
      hooks: hooks,
      style: const TourStepStyle(),
      online: hooks.isMidadOnline,
      assistantFresh: hooks.isMidadAssistantFresh,
      hasProviders: hooks.hasMidadProviders,
    );
    tour.onStepChanged = script.onStepChanged;
    return script;
  }

  /// يبدأ الجولة الكاملة على محطة معيّنة من محطات هذا السيناريو.
  void startAt(MidadTourScript script, MidadTourStop stop) =>
      tour.start(steps: script.steps, initialIndex: script.stops.indexOf(stop));

  /// يبدأ جولة التحميل على محطة معيّنة من محطات هذا السيناريو.
  void startDownloadAt(
    MidadDownloadTourScript script,
    MidadDownloadTourStop stop,
  ) =>
      tour.start(steps: script.steps, initialIndex: script.stops.indexOf(stop));

  test('full tour texts are read under keys derived from the stop name', () {
    expect(midadTourTitleKey(MidadTourStop.intro), 'midadTourIntroTitle');
    expect(
      midadTourDescKey(MidadTourStop.sendButton),
      'midadTourSendButtonDesc',
    );
    // A title that is only the feature's own name reuses the app's key
    // for it instead of duplicating the same word under a tour key.
    expect(midadTourTitleKey(MidadTourStop.newChat), 'newChat');
    expect(midadTourTitleKey(MidadTourStop.history), 'chatHistory');
    expect(midadTourTitleKey(MidadTourStop.inputField), 'askMidad');
    expect(midadTourTitleKey(MidadTourStop.sectionFilter), 'sections');
    expect(midadTourTitleKey(MidadTourStop.assistantChips), 'assistantMode');
    expect(midadTourTitleKey(MidadTourStop.modelSelector), 'selectModel');
    // The closing card's title is the same for every tour.
    expect(midadTourTitleKey(MidadTourStop.closing), 'mushafTourClosingTitle');
  });

  test(
    'download tour texts are read under keys derived from the stop name',
    () {
      expect(
        midadDownloadTourTitleKey(MidadDownloadTourStop.intro),
        'midadDownloadTourIntroTitle',
      );
      expect(
        midadDownloadTourDescKey(MidadDownloadTourStop.sectionCard),
        'midadDownloadTourSectionCardDesc',
      );
      // زر التبديل عنوانُه عنوان محطته في الجولة الكاملة، والختام مشترك.
      expect(
        midadDownloadTourTitleKey(MidadDownloadTourStop.modeToggle),
        'midadTourModeToggleTitle',
      );
      expect(
        midadDownloadTourTitleKey(MidadDownloadTourStop.closing),
        'mushafTourClosingTitle',
      );
    },
  );

  test('each tour has one step per stop, intro first and closing last', () {
    final script = scriptFor();
    expect(script.steps.length, MidadTourStop.values.length);
    expect(script.steps.first.title, 'midadTourIntroTitle');
    expect(script.steps.first.targetKey, isNull);
    expect(script.steps.last.title, 'mushafTourClosingTitle');
    expect(script.steps.last.targetKey, isNull);

    final download = downloadScriptFor();
    expect(download.steps.length, MidadDownloadTourStop.values.length);
    expect(download.steps.first.targetKey, isNull);
    expect(download.steps.last.targetKey, isNull);
  });

  test('each stop points at the widget tagged for it', () {
    Key? targetOf(MidadTourStop stop) =>
        scriptFor().steps[MidadTourStop.values.indexOf(stop)].targetKey;

    expect(targetOf(MidadTourStop.modeToggle), same(MidadTourKeys.modeToggle));
    expect(targetOf(MidadTourStop.newChat), same(MidadTourKeys.newChat));
    expect(targetOf(MidadTourStop.history), same(MidadTourKeys.history));
    expect(
      targetOf(MidadTourStop.floatingMenu),
      same(MidadTourKeys.floatingMenu),
    );
    expect(
      targetOf(MidadTourStop.suggestionChips),
      same(MidadTourKeys.suggestionChips),
    );
    expect(targetOf(MidadTourStop.inputField), same(MidadTourKeys.inputField));
    expect(targetOf(MidadTourStop.sendButton), same(MidadTourKeys.sendButton));
    expect(
      targetOf(MidadTourStop.sectionFilter),
      same(MidadTourKeys.sectionFilter),
    );
    expect(
      targetOf(MidadTourStop.assistantChips),
      same(MidadTourKeys.assistantChips),
    );
    expect(
      targetOf(MidadTourStop.modelSelector),
      same(MidadTourKeys.modelSelector),
    );

    Key? downloadTargetOf(MidadDownloadTourStop stop) => downloadScriptFor()
        .steps[MidadDownloadTourStop.values.indexOf(stop)]
        .targetKey;
    expect(
      downloadTargetOf(MidadDownloadTourStop.modeToggle),
      same(MidadTourKeys.modeToggle),
    );
    expect(
      downloadTargetOf(MidadDownloadTourStop.sharedCard),
      same(MidadTourKeys.sharedCard),
    );
    expect(
      downloadTargetOf(MidadDownloadTourStop.sectionCard),
      same(MidadTourKeys.sectionCard),
    );
    // البطاقة الختامية وتلميح «لاحقاً» غير مستهدفتين: تلميح التأجيل أسفل
    // التمرير خارج الشاشة.
    expect(downloadTargetOf(MidadDownloadTourStop.laterHint), isNull);
  });

  test('no step waits for the user', () {
    for (final step in scriptFor().steps) {
      expect(step.requireInteraction, isFalse, reason: step.title);
      expect(step.interaction, TourTargetInteraction.none);
      expect(step.interactionHint, isNull);
    }
    for (final step in downloadScriptFor().steps) {
      expect(step.requireInteraction, isFalse, reason: step.title);
    }
  });

  test('exactly the assistant stops are classified', () {
    const assistantStops = {
      MidadTourStop.assistantChips,
      MidadTourStop.modelSelector,
    };
    for (final stop in MidadTourStop.values) {
      expect(
        midadTourIsOnAssistant(stop),
        assistantStops.contains(stop),
        reason: stop.name,
      );
    }
  });

  test('conditional stops follow the screen state at start', () {
    // بلا اتصال: تسقط محطتا المساعد وتبقى البطاقة الختامية.
    hooks.isMidadOnline = false;
    expect(
      scriptFor().stops,
      MidadTourStop.values
          .where(
            (s) =>
                s != MidadTourStop.assistantChips &&
                s != MidadTourStop.modelSelector,
          )
          .toList(),
    );

    // اتصال بلا مزودين: تسقط محطة منتقي النموذج وحدها.
    hooks = _FakeHooks()..hasMidadProviders = false;
    expect(
      scriptFor().stops,
      MidadTourStop.values
          .where((s) => s != MidadTourStop.modelSelector)
          .toList(),
    );

    // نتائج معروضة: تسقط محطة اقتراحات البداية الدلالية.
    hooks = _FakeHooks()..isMidadSemanticEmpty = false;
    expect(
      scriptFor().stops,
      MidadTourStop.values
          .where((s) => s != MidadTourStop.suggestionChips)
          .toList(),
    );

    // محادثة قائمة: تسقط محطة اقتراحات الترحيب.
    hooks = _FakeHooks()..isMidadAssistantFresh = false;
    expect(
      scriptFor().stops,
      MidadTourStop.values
          .where((s) => s != MidadTourStop.assistantChips)
          .toList(),
    );

    // ملفات مشتركة محمّلة: تسقط بطاقتها من جولة التحميل.
    hooks = _FakeHooks()..isMidadSharedLoaded = true;
    expect(
      downloadScriptFor().stops,
      MidadDownloadTourStop.values
          .where((s) => s != MidadDownloadTourStop.sharedCard)
          .toList(),
    );
  });

  test('a semantic-default user is never switched away', () {
    final script = scriptFor();
    startAt(script, MidadTourStop.intro);
    expect(hooks.sets, 0);
    expect(hooks.isMidasAssistantMode, isFalse);

    while (tour.index < script.stops.indexOf(MidadTourStop.sectionFilter)) {
      tour.next();
    }
    expect(hooks.sets, 0);
  });

  test(
    'an assistant-default user is walked semantic then assistant then back',
    () {
      hooks.isMidasAssistantMode = true;
      final script = scriptFor();

      // البطاقة الافتتاحية تعيد الشاشة إلى الدلالي مرة واحدة.
      startAt(script, MidadTourStop.intro);
      expect(hooks.isMidasAssistantMode, isFalse);
      expect(hooks.sets, 1);

      // حتى آخر محطة دلالية: لا وميض.
      while (tour.index < script.stops.indexOf(MidadTourStop.sectionFilter)) {
        tour.next();
      }
      expect(hooks.sets, 1);

      // أول محطة مساعد تنقل إليه مرة واحدة.
      tour.next();
      expect(hooks.isMidasAssistantMode, isTrue);
      expect(hooks.sets, 2);

      // البطاقة الختامية تبقى في وضع المساعد.
      while (tour.index < script.stops.length - 1) {
        tour.next();
      }
      expect(hooks.sets, 2);
      expect(hooks.isMidasAssistantMode, isTrue);

      // النهاية تعيد وضع المستخدم، وقد انتهت الجولة فيه أصلاً فلا ضبط جديد.
      script.onTourEnd();
      expect(hooks.isMidasAssistantMode, isTrue);
      expect(hooks.sets, 2);
    },
  );

  test(
    'a semantic-default user is returned to semantic after the assistant',
    () {
      final script = scriptFor();
      startAt(script, MidadTourStop.assistantChips);
      expect(hooks.isMidasAssistantMode, isTrue);
      expect(hooks.sets, 1);

      // حتى الختام لا ضبط جديد، والنهاية تعيد الدلالي إلى المستخدم.
      while (tour.index < script.stops.length - 1) {
        tour.next();
      }
      expect(hooks.sets, 1);
      script.onTourEnd();
      expect(hooks.isMidasAssistantMode, isFalse);
      expect(hooks.sets, 2);
    },
  );

  test('an offline tour of an assistant user skips the assistant stops', () {
    hooks
      ..isMidasAssistantMode = true
      ..isMidadOnline = false;
    final script = scriptFor();
    startAt(script, MidadTourStop.intro);
    expect(hooks.isMidasAssistantMode, isFalse);

    // حتى الختام: لم تدخل الجولة وضع المساعد.
    while (tour.index < script.stops.length - 1) {
      tour.next();
    }
    expect(hooks.isMidasAssistantMode, isFalse);
    script.onTourEnd();
    expect(hooks.isMidasAssistantMode, isTrue);
  });

  test('walking back from the assistant stops returns to semantic', () {
    final script = scriptFor();
    startAt(script, MidadTourStop.modelSelector);
    expect(hooks.isMidasAssistantMode, isTrue);

    // قبل منتقي النموذج محطة مساعد أخرى: لا تغيير.
    tour.previous();
    expect(tour.index, script.stops.indexOf(MidadTourStop.assistantChips));
    expect(hooks.isMidasAssistantMode, isTrue);

    // وما قبلها محطة دلالية: عودة إلى الدلالي.
    tour.previous();
    expect(tour.index, script.stops.indexOf(MidadTourStop.sectionFilter));
    expect(hooks.isMidasAssistantMode, isFalse);
  });

  test('the download tour never touches the mode', () {
    final download = downloadScriptFor();
    startDownloadAt(download, MidadDownloadTourStop.intro);
    while (tour.index < download.stops.length - 1) {
      tour.next();
    }
    download.onTourEnd();
    expect(hooks.sets, 0);
    expect(hooks.isMidasAssistantMode, isFalse);
  });

  test('assistant tour texts reuse their counterparts in the other tours', () {
    expect(
      midadAssistantTourTitleKey(MidadAssistantTourStop.intro),
      'assistantMode',
    );
    expect(
      midadAssistantTourDescKey(MidadAssistantTourStop.intro),
      'midadAssistantTourIntroDesc',
    );
    expect(
      midadAssistantTourTitleKey(MidadAssistantTourStop.modeToggle),
      'midadTourModeToggleTitle',
    );
    expect(
      midadAssistantTourTitleKey(MidadAssistantTourStop.inputField),
      'askMidad',
    );
    expect(
      midadAssistantTourDescKey(MidadAssistantTourStop.inputField),
      'midadAssistantTourInputFieldDesc',
    );
    expect(
      midadAssistantTourTitleKey(MidadAssistantTourStop.sendButton),
      'midadTourSendButtonTitle',
    );
    expect(
      midadAssistantTourDescKey(MidadAssistantTourStop.sendButton),
      'midadAssistantTourSendButtonDesc',
    );
    expect(
      midadAssistantTourDescKey(MidadAssistantTourStop.modelSelector),
      'midadTourModelSelectorDesc',
    );
    expect(
      midadAssistantTourTitleKey(MidadAssistantTourStop.closing),
      'mushafTourClosingTitle',
    );
    expect(
      midadAssistantTourDescKey(MidadAssistantTourStop.closing),
      'midadTourClosingDesc',
    );
  });

  test('assistant tour stops follow the screen state at start', () {
    // بلا اتصال: أزرار الشريط وحدها، فشريط إدخال المساعد لا يُركَّب.
    hooks.isMidadOnline = false;
    expect(assistantScriptFor().stops, [
      MidadAssistantTourStop.intro,
      MidadAssistantTourStop.modeToggle,
      MidadAssistantTourStop.newChat,
      MidadAssistantTourStop.history,
      MidadAssistantTourStop.closing,
    ]);

    // محادثة قائمة: تسقط محطة اقتراحات الترحيب.
    hooks = _FakeHooks()..isMidadAssistantFresh = false;
    expect(
      assistantScriptFor().stops,
      MidadAssistantTourStop.values
          .where((s) => s != MidadAssistantTourStop.assistantChips)
          .toList(),
    );

    // بلا مزودين: تسقط محطة منتقي النموذج.
    hooks = _FakeHooks()..hasMidadProviders = false;
    expect(
      assistantScriptFor().stops,
      MidadAssistantTourStop.values
          .where((s) => s != MidadAssistantTourStop.modelSelector)
          .toList(),
    );
  });

  test('assistant tour targets and never touches the mode', () {
    final script = assistantScriptFor();
    expect(script.steps.length, MidadAssistantTourStop.values.length);
    expect(script.steps.first.targetKey, isNull);
    expect(script.steps.last.targetKey, isNull);

    Key? targetOf(MidadAssistantTourStop stop) =>
        script.steps[MidadAssistantTourStop.values.indexOf(stop)].targetKey;
    expect(
      targetOf(MidadAssistantTourStop.inputField),
      same(MidadTourKeys.inputField),
    );
    expect(
      targetOf(MidadAssistantTourStop.sendButton),
      same(MidadTourKeys.sendButton),
    );
    expect(
      targetOf(MidadAssistantTourStop.assistantChips),
      same(MidadTourKeys.assistantChips),
    );
    expect(
      targetOf(MidadAssistantTourStop.modelSelector),
      same(MidadTourKeys.modelSelector),
    );

    // الجولة كلها لا تبدّل الوضع ولا تنتظر تفاعلاً.
    tour.start(steps: script.steps);
    for (final step in script.steps) {
      expect(step.requireInteraction, isFalse, reason: step.title);
    }
    script.onTourEnd();
    expect(hooks.sets, 0);
  });

  test('a step report from another tour moves nothing', () {
    final script = scriptFor();
    tour.start(
      steps: const [TourStep(title: 'other', description: '')],
    );
    script.onStepChanged(0);
    expect(hooks.sets, 0);

    // Nor an index this tour does not have.
    startAt(script, MidadTourStop.intro);
    script.onStepChanged(script.stops.length);
    expect(hooks.sets, 0);
  });

  test('every tour text exists in all 11 locale files', () {
    for (final locale in locales) {
      final strings =
          jsonDecode(File('assets/locales/$locale.json').readAsStringSync())
              as Map<String, dynamic>;
      for (final stop in MidadTourStop.values) {
        for (final key in [midadTourTitleKey(stop), midadTourDescKey(stop)]) {
          expect(
            strings[key],
            isA<String>().having((s) => s.trim(), 'not blank', isNotEmpty),
            reason: '$locale.json is missing "$key"',
          );
        }
      }
      for (final stop in MidadDownloadTourStop.values) {
        for (final key in [
          midadDownloadTourTitleKey(stop),
          midadDownloadTourDescKey(stop),
        ]) {
          expect(
            strings[key],
            isA<String>().having((s) => s.trim(), 'not blank', isNotEmpty),
            reason: '$locale.json is missing "$key"',
          );
        }
      }
      for (final stop in MidadAssistantTourStop.values) {
        for (final key in [
          midadAssistantTourTitleKey(stop),
          midadAssistantTourDescKey(stop),
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

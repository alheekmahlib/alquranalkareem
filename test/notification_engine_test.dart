import 'package:flutter_test/flutter_test.dart';

import 'package:alquranalkareem/core/services/notification_engine.dart';

void main() {
  group('NotificationEngine.evaluate — ساعات الهدوء', () {
    test('ذروة مسائية (23:00) داخل الهدوء تُقصّ إلى ما قبل الهدوء (21:00)', () {
      final now = DateTime(2026, 8, 24, 10, 0);
      final decision = _evaluate(now: now, histogram: {23: 3}, hasQuran: true);
      expect(decision.shouldSend, isTrue);
      expect(decision.sendAt, DateTime(2026, 8, 24, 21, 0));
    });

    test('ذروة فجرية (02:00) داخل الهدوء تُدفع إلى نهايته (07:00)', () {
      final now = DateTime(2026, 8, 24, 1, 0);
      final decision = _evaluate(now: now, histogram: {2: 3}, hasQuran: true);
      expect(decision.sendAt, DateTime(2026, 8, 24, 7, 0));
    });

    test('ذروة خارج الهدوء (20:00) تبقى كما هي', () {
      final now = DateTime(2026, 8, 24, 10, 0);
      final decision = _evaluate(now: now, histogram: {20: 3}, hasQuran: true);
      expect(decision.sendAt, DateTime(2026, 8, 24, 20, 0));
    });

    test('تعطيل ساعات الهدوء يترك الذروة الليلية (23:00) كما هي', () {
      final now = DateTime(2026, 8, 24, 10, 0);
      final decision = _evaluate(
        now: now,
        histogram: {23: 3},
        quietHoursEnabled: false,
        hasQuran: true,
      );
      expect(decision.sendAt, DateTime(2026, 8, 24, 23, 0));
    });

    test('الوقت اليدوي داخل الهدوء يُحترم ولا يُقصّ', () {
      final now = DateTime(2026, 8, 24, 21, 0);
      final decision = _evaluate(now: now, manualHour: 23, hasQuran: true);
      expect(decision.sendAt, DateTime(2026, 8, 24, 23, 0));
    });

    test('نطاق هدوء نهاري (01:00→06:00) يعمل', () {
      final now = DateTime(2026, 8, 24, 0, 30);
      final decision = _evaluate(
        now: now,
        histogram: {3: 3},
        quietStart: 1,
        quietEnd: 6,
        hasQuran: true,
      );
      expect(decision.sendAt, DateTime(2026, 8, 24, 6, 0));
    });
  });

  group('evaluate — اختيار الوقت الذكي', () {
    test('ذروة مدرج الساعات تُستخدم عند توفر 3 عينات', () {
      final now = DateTime(2026, 8, 24, 10, 0);
      final decision = _evaluate(
        now: now,
        histogram: {21: 1, 22: 4, 5: 1},
        hasQuran: true,
      );
      // الذروة 22 داخل الهدوء (22-7) فتُقصّ إلى آخر ساعة قبله.
      expect(decision.sendAt, DateTime(2026, 8, 24, 21, 0));
    });

    test('تعادل الأصوات يُحسم للساعة الأبكر', () {
      final now = DateTime(2026, 8, 24, 10, 0);
      final decision = _evaluate(
        now: now,
        histogram: {22: 2, 21: 2, 9: 1},
        hasQuran: true,
      );
      expect(decision.sendAt, DateTime(2026, 8, 24, 21, 0));
    });

    test('مدرج أقل من 3 عينات يُهمل ويعود للافتراضي 20:00', () {
      final now = DateTime(2026, 8, 24, 10, 0);
      final decision = _evaluate(now: now, histogram: {23: 2}, hasQuran: true);
      expect(decision.sendAt, DateTime(2026, 8, 24, 20, 0));
    });

    test('الوقت اليدوي يغلّب المدرج', () {
      final now = DateTime(2026, 8, 24, 8, 0);
      final decision = _evaluate(
        now: now,
        manualHour: 9,
        manualMinute: 30,
        histogram: {22: 5},
        hasQuran: true,
      );
      expect(decision.sendAt, DateTime(2026, 8, 24, 9, 30));
    });

    test('وقت اليوم فات → يُجدول للغد', () {
      final now = DateTime(2026, 8, 24, 21, 0);
      final decision = _evaluate(now: now, manualHour: 20, hasQuran: true);
      expect(decision.sendAt, DateTime(2026, 8, 25, 20, 0));
    });
  });

  group('evaluate — قواعد التخطي', () {
    test('التذكيرات معطلة → تخطٍ', () {
      final decision = _evaluate(now: DateTime(2026, 8, 24), enabled: false);
      expect(decision.shouldSend, isFalse);
      expect(decision.reason, SkipReason.disabled);
    });

    test('قرأ المستخدم اليوم → تخطٍ', () {
      final now = DateTime(2026, 8, 24, 21, 0);
      final decision = _evaluate(
        now: now,
        lastReadAt: DateTime(2026, 8, 24, 6, 0),
        hasQuran: true,
      );
      expect(decision.reason, SkipReason.readToday);
    });

    test('قرأ أمس (وليس اليوم) → لا تخطٍ', () {
      final now = DateTime(2026, 8, 24, 21, 0);
      final decision = _evaluate(
        now: now,
        lastReadAt: DateTime(2026, 8, 23, 23, 0),
        hasQuran: true,
      );
      expect(decision.shouldSend, isTrue);
    });

    test('جدولة معلقة في المستقبل → تخطٍ قبل الأوان دون المساس بها', () {
      final now = DateTime(2026, 8, 24, 10, 0);
      final decision = _evaluate(
        now: now,
        pendingDigestAt: DateTime(2026, 8, 24, 20, 0),
        hasQuran: true,
      );
      expect(decision.reason, SkipReason.tooSoon);
    });

    test('لم يمرّ الفاصل (يومي) → تخطٍ', () {
      final now = DateTime(2026, 8, 24, 10, 0);
      final decision = _evaluate(
        now: now,
        lastNotifiedAt: DateTime(2026, 8, 23, 20, 0),
        hasQuran: true,
      );
      expect(decision.reason, SkipReason.tooSoon);
    });

    test('بعد مرور الفاصل (أسبوعي) → إرسال للغد', () {
      final now = DateTime(2026, 8, 24, 21, 0);
      final decision = _evaluate(
        now: now,
        frequencyLevel: FrequencyLevel.weekly,
        lastNotifiedAt: DateTime(2026, 8, 17, 20, 0),
        hasQuran: true,
      );
      expect(decision.shouldSend, isTrue);
      // الافتراضي 20:00 فات اليوم فيُجدول للغد.
      expect(decision.sendAt, DateTime(2026, 8, 25, 20, 0));
    });

    test('لا محتوى إطلاقًا → تخطٍ (مستخدم جديد)', () {
      final decision = _evaluate(now: DateTime(2026, 8, 24, 10, 0));
      expect(decision.reason, SkipReason.noContent);
    });
  });

  group('processInteraction — سلم التغذية الراجعة', () {
    test('بلا إشعار سابق → لا تغيير', () {
      final result = NotificationEngine.processInteraction(
        now: DateTime(2026, 8, 24),
        frequencyLevel: FrequencyLevel.every2Days,
        engagementPoints: 1,
        consecutiveIgnored: 1,
        lastNotifiedCounted: false,
      );
      expect(result.frequencyLevel, FrequencyLevel.every2Days);
      expect(result.engagementPoints, 1);
      expect(result.consecutiveIgnored, 1);
    });

    test('تفاعل بعد الإشعار → نقطة، و3 نقاط ترفع التردد درجة', () {
      final notifiedAt = DateTime(2026, 8, 20, 20, 0);
      var result = _interact(
        notifiedAt: notifiedAt,
        interactedAt: DateTime(2026, 8, 20, 21, 0),
        now: DateTime(2026, 8, 20, 21, 0),
        points: 0,
        level: FrequencyLevel.every3Days,
      );
      expect(result.engagementPoints, 1);
      expect(result.frequencyLevel, FrequencyLevel.every3Days);

      result = _interact(
        notifiedAt: notifiedAt,
        interactedAt: DateTime(2026, 8, 20, 21, 0),
        now: DateTime(2026, 8, 20, 21, 0),
        points: 2,
        level: FrequencyLevel.every3Days,
      );
      expect(result.engagementPoints, 0);
      expect(result.frequencyLevel, FrequencyLevel.every2Days);
      expect(result.consecutiveIgnored, 0);
      expect(result.lastNotifiedCounted, isTrue);
    });

    test('تفاعل يُحسب مرة واحدة فقط لكل إشعار', () {
      final notifiedAt = DateTime(2026, 8, 20, 20, 0);
      final first = _interact(
        notifiedAt: notifiedAt,
        interactedAt: DateTime(2026, 8, 20, 20, 5),
        now: DateTime(2026, 8, 20, 20, 5),
        points: 0,
      );
      expect(first.lastNotifiedCounted, isTrue);

      final second = _interact(
        notifiedAt: notifiedAt,
        interactedAt: DateTime(2026, 8, 20, 20, 6),
        now: DateTime(2026, 8, 20, 20, 6),
        points: first.engagementPoints,
        lastCounted: true,
      );
      expect(second.engagementPoints, first.engagementPoints);
    });

    test('إشعاران متتاليان بلا تفاعل يخفضان التردد درجة', () {
      var result = _interact(
        notifiedAt: DateTime(2026, 8, 18, 20, 0),
        interactedAt: null,
        now: DateTime(2026, 8, 21, 20, 1),
        level: FrequencyLevel.daily,
      );
      expect(result.consecutiveIgnored, 1);
      expect(result.frequencyLevel, FrequencyLevel.daily);

      result = _interact(
        notifiedAt: DateTime(2026, 8, 20, 20, 0),
        interactedAt: null,
        now: DateTime(2026, 8, 23, 20, 1),
        level: FrequencyLevel.daily,
        ignored: 1,
      );
      expect(result.consecutiveIgnored, 0);
      expect(result.frequencyLevel, FrequencyLevel.every2Days);
      expect(result.lastNotifiedCounted, isTrue);
    });

    test('النافذة (48 ساعة) ما زالت مفتوحة بلا تفاعل → لا حكم بعد', () {
      final result = _interact(
        notifiedAt: DateTime(2026, 8, 20, 20, 0),
        interactedAt: null,
        now: DateTime(2026, 8, 21, 20, 0),
        level: FrequencyLevel.daily,
      );
      expect(result.lastNotifiedCounted, isFalse);
      expect(result.consecutiveIgnored, 0);
    });

    test('الأسبوعي أرضية لا ينزل تحتها', () {
      final result = _interact(
        notifiedAt: DateTime(2026, 8, 1, 20, 0),
        interactedAt: null,
        now: DateTime(2026, 8, 10, 20, 0),
        level: FrequencyLevel.weekly,
        ignored: 1,
      );
      expect(result.frequencyLevel, FrequencyLevel.weekly);
    });

    test('اليومي سقف لا يُرفع فوقه', () {
      final result = _interact(
        notifiedAt: DateTime(2026, 8, 20, 20, 0),
        interactedAt: DateTime(2026, 8, 20, 21, 0),
        now: DateTime(2026, 8, 20, 21, 0),
        points: 5,
        level: FrequencyLevel.daily,
      );
      expect(result.frequencyLevel, FrequencyLevel.daily);
    });
  });
}

EngineDecision _evaluate({
  required DateTime now,
  bool enabled = true,
  int? manualHour,
  int? manualMinute,
  bool quietHoursEnabled = true,
  int quietStart = 22,
  int quietEnd = 7,
  FrequencyLevel frequencyLevel = FrequencyLevel.daily,
  DateTime? lastNotifiedAt,
  DateTime? pendingDigestAt,
  DateTime? lastReadAt,
  Map<int, int> histogram = const {},
  bool hasQuran = false,
  bool hasBooks = false,
  bool hasKhatmah = false,
}) {
  return NotificationEngine.evaluate(
    EngineInputs(
      now: now,
      enabled: enabled,
      manualHour: manualHour,
      manualMinute: manualMinute,
      quietHoursEnabled: quietHoursEnabled,
      quietStartHour: quietStart,
      quietEndHour: quietEnd,
      frequencyLevel: frequencyLevel,
      lastNotifiedAt: lastNotifiedAt,
      pendingDigestAt: pendingDigestAt,
      lastReadAt: lastReadAt,
      readingHourHistogram: histogram,
      hasQuranProgress: hasQuran,
      hasBookProgress: hasBooks,
      hasKhatmahProgress: hasKhatmah,
    ),
  );
}

EngagementResult _interact({
  required DateTime notifiedAt,
  required DateTime now,
  DateTime? interactedAt,
  int points = 0,
  int ignored = 0,
  FrequencyLevel level = FrequencyLevel.daily,
  bool lastCounted = false,
}) {
  return NotificationEngine.processInteraction(
    now: now,
    frequencyLevel: level,
    engagementPoints: points,
    consecutiveIgnored: ignored,
    lastNotifiedCounted: lastCounted,
    lastNotifiedAt: notifiedAt,
    lastInteractedAt: interactedAt,
  );
}

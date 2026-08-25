/// محرك قرار الإشعارات الذكية — منطق نقي بلا أي تبعيات Flutter/GetX
/// ليكون قابلًا للاختبار الكامل. [NotificationManager] هو المنسق الذي
/// يزوّده بالمدخلات من GetStorage وينفّذ قراراته عبر NotifyHelper.
///
/// عقد الأداء: هذا المحرك لا يعرف شيئًا عن الإشعارات أو الجدولة؛
/// هو يحوّل مدخلات مجرّدة إلى قرار قابل للتنفيذ.

/// مستويات التردد: الفهرس = المستوى، والقيمة = الأيام بين الإشعارات.
///
/// كلما صغُر المستوى زاد التردد — المستوى 0 يومي، والمستوى 3 أسبوعي
/// (أرضية لا ينزل تحتها المحرك أبدًا كي لا نفقد تواصل المستخدم كليًا).
enum FrequencyLevel {
  daily(0),
  every2Days(1),
  every3Days(2),
  weekly(3);

  const FrequencyLevel(this.level);

  final int level;

  int get intervalDays => switch (level) {
    0 => 1,
    1 => 2,
    2 => 3,
    _ => 7,
  };

  /// هل يمكن خفض التردد درجة (مستوى أعلى = أقل تكرارًا)؟
  bool get canDecreaseFrequency => level < FrequencyLevel.weekly.level;

  /// هل يمكن رفع التردد درجة (مستوى أدنى = أكثر تكرارًا)؟
  bool get canIncreaseFrequency => level > FrequencyLevel.daily.level;

  FrequencyLevel get lessFrequent =>
      canDecreaseFrequency ? FrequencyLevel.values[level + 1] : this;

  FrequencyLevel get moreFrequent =>
      canIncreaseFrequency ? FrequencyLevel.values[level - 1] : this;

  static FrequencyLevel fromIndex(int index) {
    if (index < 0 || index > FrequencyLevel.values.length - 1) {
      return FrequencyLevel.daily;
    }
    return FrequencyLevel.values[index];
  }
}

/// أسباب عدم الإرسال — تُستخدم في السجلات والاختبارات.
enum SkipReason {
  /// التذكيرات معطلة من الإعدادات.
  disabled,

  /// المستخدم قرأ اليوم — لا حاجة لتذكيره.
  readToday,

  /// لم يمرّ الفاصل الكافي منذ آخر إشعار.
  tooSoon,

  /// لا يوجد محتوى فعلي للتنبيه به.
  noContent,
}

class EngineInputs {
  const EngineInputs({
    required this.now,
    this.enabled = true,
    this.manualHour,
    this.manualMinute,
    this.quietHoursEnabled = true,
    this.quietStartHour = 22,
    this.quietEndHour = 7,
    this.frequencyLevel = FrequencyLevel.daily,
    this.lastNotifiedAt,
    this.pendingDigestAt,
    this.lastReadAt,
    required this.readingHourHistogram,
    this.hasQuranProgress = false,
    this.hasBookProgress = false,
    this.hasKhatmahProgress = false,
  });

  final DateTime now;

  /// تفعيل التذكيرات الذكية من إعدادات المستخدم.
  final bool enabled;

  /// الوقت اليدوي الذي حدده المستخدم (0-23) — يلغي الاختيار التلقائي.
  final int? manualHour;
  final int? manualMinute;

  final bool quietHoursEnabled;
  final int quietStartHour;
  final int quietEndHour;

  final FrequencyLevel frequencyLevel;

  /// وقت إطلاق آخر إشعار (المخطط له — وليس وقت الجدولة).
  final DateTime? lastNotifiedAt;

  /// جدولة معلقة لم تُطلق بعد — يجب عدم المساس بها عند [SkipReason.tooSoon].
  final DateTime? pendingDigestAt;

  final DateTime? lastReadAt;

  /// مدرج ساعات القراءة: مفتاح = الساعة (0-23)، قيمة = عدد العينات.
  final Map<int, int> readingHourHistogram;

  final bool hasQuranProgress;
  final bool hasBookProgress;
  final bool hasKhatmahProgress;
}

class EngineDecision {
  const EngineDecision({required this.shouldSend, this.sendAt, this.reason});

  const EngineDecision.skip(this.reason) : shouldSend = false, sendAt = null;

  const EngineDecision.send(this.sendAt) : shouldSend = true, reason = null;

  final bool shouldSend;
  final DateTime? sendAt;
  final SkipReason? reason;
}

/// ناتج معالجة التفاعل مع آخر إشعار — العدادات المحدّثة فقط.
class EngagementResult {
  const EngagementResult({
    required this.frequencyLevel,
    required this.engagementPoints,
    required this.consecutiveIgnored,
    required this.lastNotifiedCounted,
  });

  /// المستوى الحالي للتردد.
  final FrequencyLevel frequencyLevel;

  /// نقاط التفاعل منذ آخر ترقية للتردد.
  final int engagementPoints;

  /// عدد الإشعارات المتتالية التي لم يتفاعل معها المستخدم.
  final int consecutiveIgnored;

  /// هل حُسب آخر إشعار في التغذية الراجعة؟ (يُمنع عدّه مرتين)
  final bool lastNotifiedCounted;
}

class NotificationEngine {
  /// ساعة الإرسال الافتراضية عند غياب سجل القراءة والوقت اليدوي.
  static const int defaultReminderHour = 20;

  /// نافذة التفاعل بعد الإشعار — فتح أو قراءة خلالها يُحسب تفاعلًا.
  static const Duration engagementWindow = Duration(hours: 48);

  /// نقاط التفاعل اللازمة لرفع التردد درجة.
  static const int pointsToIncreaseFrequency = 3;

  /// إشعارات متتالية بلا تفاعل لخفض التردد درجة.
  static const int ignoredToDecreaseFrequency = 2;

  /// أقل عدد عينات في مدرج الساعات قبل الوثوق به.
  static const int minHistogramSamples = 3;

  /// يقيّم ما إذا كان يجب إرسال تذكير الآن ومتى.
  static EngineDecision evaluate(EngineInputs inputs) {
    if (!inputs.enabled) {
      return const EngineDecision.skip(SkipReason.disabled);
    }

    // جدولة معلقة لم تُطلق بعد → لا نلمسها إطلاقًا (تحمي سقف التردد).
    final pending = inputs.pendingDigestAt;
    if (pending != null && pending.isAfter(inputs.now)) {
      return const EngineDecision.skip(SkipReason.tooSoon);
    }

    // من قرأ اليوم لا يُذكَّر.
    if (_isSameLocalDay(inputs.lastReadAt, inputs.now)) {
      return const EngineDecision.skip(SkipReason.readToday);
    }

    // سقف الفاصل الزمني حسب مستوى التردد.
    final lastNotified = inputs.lastNotifiedAt;
    if (lastNotified != null) {
      final earliest = lastNotified.add(
        Duration(days: inputs.frequencyLevel.intervalDays),
      );
      if (inputs.now.isBefore(earliest)) {
        return const EngineDecision.skip(SkipReason.tooSoon);
      }
    }

    // لا إشعارات فارغة — يجب وجود محتوى فعلي.
    if (!inputs.hasQuranProgress &&
        !inputs.hasBookProgress &&
        !inputs.hasKhatmahProgress) {
      return const EngineDecision.skip(SkipReason.noContent);
    }

    final sendAt = _resolveSendAt(inputs);
    return EngineDecision.send(sendAt);
  }

  /// معالجة التفاعل مع آخر إشعار (فتح التطبيق أو القراءة بعده).
  ///
  /// تُستدعى من onAppOpened وtrack* — كل إشعار يُحسب مرة واحدة عبر
  /// [lastNotifiedCounted] فلا يضر تكرار الاستدعاء.
  static EngagementResult processInteraction({
    required DateTime now,
    required FrequencyLevel frequencyLevel,
    required int engagementPoints,
    required int consecutiveIgnored,
    required bool lastNotifiedCounted,
    DateTime? lastNotifiedAt,
    DateTime? lastInteractedAt,
  }) {
    if (lastNotifiedAt == null || lastNotifiedCounted) {
      return EngagementResult(
        frequencyLevel: frequencyLevel,
        engagementPoints: engagementPoints,
        consecutiveIgnored: consecutiveIgnored,
        lastNotifiedCounted: lastNotifiedCounted,
      );
    }

    // تفاعل: فتح أو قراءة بعد إطلاق الإشعار وقبل الآن.
    if (lastInteractedAt != null &&
        lastInteractedAt.isAfter(lastNotifiedAt) &&
        !lastInteractedAt.isAfter(now)) {
      var level = frequencyLevel;
      var points = engagementPoints + 1;
      if (points >= pointsToIncreaseFrequency) {
        level = level.moreFrequent;
        points = 0;
      }
      return EngagementResult(
        frequencyLevel: level,
        engagementPoints: points,
        consecutiveIgnored: 0,
        lastNotifiedCounted: true,
      );
    }

    // تجاهل: انقضت نافذة التفاعل بلا أي فتح أو قراءة.
    if (now.isAfter(lastNotifiedAt.add(engagementWindow))) {
      var level = frequencyLevel;
      var ignored = consecutiveIgnored + 1;
      if (ignored >= ignoredToDecreaseFrequency) {
        level = level.lessFrequent;
        ignored = 0;
      }
      return EngagementResult(
        frequencyLevel: level,
        engagementPoints: 0,
        consecutiveIgnored: ignored,
        lastNotifiedCounted: true,
      );
    }

    // النافذة ما زالت مفتوحة — لا حكم بعد.
    return EngagementResult(
      frequencyLevel: frequencyLevel,
      engagementPoints: engagementPoints,
      consecutiveIgnored: consecutiveIgnored,
      lastNotifiedCounted: false,
    );
  }

  /// يحسم وقت الإرسال: يدوي ← ذروة المدرج ← الافتراضي، ثم القصّ خارج
  /// ساعات الهدوء، ثم الدفع للغد إن كان الوقت فات اليوم.
  ///
  /// الوقت اليدوي الصريح يتجاوز القصّ — نية المستخدم المعلنة تغلب
  /// الحماية المطبقة على الأوقات التلقائية فقط.
  static DateTime _resolveSendAt(EngineInputs inputs) {
    final now = inputs.now;
    final isManual = inputs.manualHour != null;
    final hour =
        inputs.manualHour ?? _histogramPeak(inputs.readingHourHistogram);
    final minute = inputs.manualMinute ?? 0;

    var candidate = DateTime(now.year, now.month, now.day, hour, minute);
    if (!isManual) {
      candidate = _clampOutsideQuietHours(
        candidate,
        inputs.quietHoursEnabled,
        inputs.quietStartHour,
        inputs.quietEndHour,
      );
    }

    if (!candidate.isAfter(now)) {
      candidate = candidate.add(const Duration(days: 1));
    }
    return candidate;
  }

  /// ذروة مدرج ساعات القراءة؛ تعادل الأصوات تُحسم للساعة الأبكر.
  /// يُتجاهل المدرج دون [minHistogramSamples] عينات.
  static int _histogramPeak(Map<int, int> histogram) {
    final total = histogram.values.fold<int>(0, (a, b) => a + b);
    if (total < minHistogramSamples) {
      return defaultReminderHour;
    }
    var peakHour = defaultReminderHour;
    var peakCount = -1;
    final hours = histogram.keys.toList()..sort();
    for (final hour in hours) {
      final count = histogram[hour] ?? 0;
      if (count > peakCount) {
        peakCount = count;
        peakHour = hour;
      }
    }
    return peakHour;
  }

  /// يزيح الوقت التلقائي الواقع داخل ساعات الهدوء إلى أقرب وقت مسموح:
  /// الجهة المسائية (قبل منتصف الليل) تُقصّ إلى آخر ساعة قبل بدء الهدوء —
  /// فمستخدم يقرأ ليلًا يليق به تذكير قبيل عادته لا بعد فواتها —
  /// والجهة الصباحية تُدفع إلى نهاية الهدوء نفسها.
  static DateTime _clampOutsideQuietHours(
    DateTime candidate,
    bool enabled,
    int quietStart,
    int quietEnd,
  ) {
    if (!enabled) return candidate;
    if (!_isInsideQuietHours(candidate.hour, quietStart, quietEnd)) {
      return candidate;
    }

    if (quietStart < quietEnd) {
      // نطاق نهاري (مثل 01:00→06:00): النهاية هي المخرج الطبيعي.
      return DateTime(candidate.year, candidate.month, candidate.day, quietEnd);
    }

    if (candidate.hour >= quietStart) {
      // نطاق عابر لمنتصف الليل، جهة مسائية: آخر ساعة قبل بدء الهدوء.
      final lastAllowed = quietStart - 1;
      if (lastAllowed >= quietEnd) {
        return DateTime(
          candidate.year,
          candidate.month,
          candidate.day,
          lastAllowed,
        );
      }
    }
    return DateTime(candidate.year, candidate.month, candidate.day, quietEnd);
  }

  /// هل الساعة داخل نطاق الهدوء؟ يدعم النطاقات العابرة لمنتصف الليل
  /// (مثل 22→7) والنطاقات النهارية (مثل 1→6).
  static bool _isInsideQuietHours(int hour, int quietStart, int quietEnd) {
    if (quietStart == quietEnd) return false;
    if (quietStart < quietEnd) {
      return hour >= quietStart && hour < quietEnd;
    }
    return hour >= quietStart || hour < quietEnd;
  }

  static bool _isSameLocalDay(DateTime? a, DateTime b) {
    if (a == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

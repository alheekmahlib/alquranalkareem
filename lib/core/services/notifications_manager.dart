import 'dart:convert' show jsonDecode;
import 'dart:developer' show log;

import 'package:flutter/services.dart' show rootBundle;
import 'package:get_storage/get_storage.dart';

import '../../presentation/screens/quran_page/widgets/khatmah/data/data_source/khatmah_database.dart';
import 'notification_engine.dart';
import 'notifications_helper.dart';

/// منسق الإشعارات الذكية — الجسر بين محرك القرار النقي ([NotificationEngine])
/// والبنية التحتية للتطبيق (GetStorage + [NotifyHelper]).
///
/// عقد الأداء: دوال `track*` خفيفة عمدًا — كتابة GetStorage فقط دون أي
/// جدولة أو استدعاءات منصة، فيُمنع استدعاؤها أثناء قلب صفحات المصحف
/// إلا عبر مستمع debounce بعد استقرار الصفحة. كل الجدولة تحدث في
/// [evaluateAndReschedule] عند فتح التطبيق أو في مهمة الخلفية فقط.
class NotificationManager {
  NotificationManager._();

  static final NotificationManager instance = NotificationManager._();

  final GetStorage _box = GetStorage();

  /// معرّف ثابت لهضم القراءة اليومي — إصلاح لتراكم المعرفات العشوائية
  /// (hashCode/millisecond) في النظام السابق.
  static const int readingDigestId = 900001;

  // ─── مفاتيح GetStorage ───
  static const String _kEnabled = 'sn_enabled';
  static const String _kManualHour = 'sn_manual_hour';
  static const String _kManualMinute = 'sn_manual_minute';
  static const String _kQuietEnabled = 'sn_quiet_enabled';
  static const String _kQuietStart = 'sn_quiet_start';
  static const String _kQuietEnd = 'sn_quiet_end';
  static const String _kContentQuran = 'sn_content_quran';
  static const String _kContentBooks = 'sn_content_books';
  static const String _kContentKhatmah = 'sn_content_khatmah';
  static const String _kFreqLevel = 'sn_freq_level';
  static const String _kEngagementPoints = 'sn_engagement_points';
  static const String _kConsecutiveIgnored = 'sn_consecutive_ignored';
  static const String _kLastNotifiedAt = 'sn_last_notified_at';
  static const String _kLastNotifiedCounted = 'sn_last_notified_counted';
  static const String _kPendingDigestAt = 'sn_pending_digest_at';
  static const String _kLastReadAt = 'sn_last_read_at';
  static const String _kLastOpenedAt = 'sn_last_opened_at';
  static const String _kReadingHours = 'sn_reading_hours';
  static const String _kLastBook = 'sn_last_book';
  static const String _kLegacyCleaned = 'sn_legacy_cleaned';

  // ─── تتبّع أحداث القراءة (خفيف — بلا أي جدولة) ───

  /// يُستدعى من مستمع debounce الخاص بصفحة القرآن بعد استقرارها.
  void trackQuranReading() => _recordReadingEvent();

  /// يُستدعى عند تشغيل الاستماع لسورة.
  void trackAudioListening() => _recordReadingEvent();

  /// يُستدعى عند إكمال يوم من الختمة.
  void trackKhatmahUpdate() => _recordReadingEvent();

  /// يُستدعى عند تغيّر صفحة كتاب في المكتبة الإسلامية.
  void trackBookReading({
    required String bookName,
    required int bookNumber,
    required int page,
    required int totalPages,
  }) {
    _recordReadingEvent();
    _box.write(_kLastBook, {
      'name': bookName,
      'bookNumber': bookNumber,
      'page': page,
      'totalPages': totalPages,
      'at': DateTime.now().toIso8601String(),
    });
  }

  void _recordReadingEvent() {
    final now = DateTime.now();
    _box.write(_kLastReadAt, now.toIso8601String());

    final histogram = readReadingHistogram();
    histogram[now.hour] = (histogram[now.hour] ?? 0) + 1;
    _box.write(_kReadingHours, histogram);

    _processEngagement(interactedAt: now);
  }

  // ─── دورة حياة التطبيق ───

  /// يُستدعى مرة واحدة عند فتح التطبيق (من شاشة البداية):
  /// تنظيف جدولات النظام القديم، تسجيل الفتح في حلقة التغذية الراجعة،
  /// ثم إعادة التقييم.
  Future<void> onAppOpened() async {
    try {
      await _cancelLegacySchedules();
      final now = DateTime.now();
      _box.write(_kLastOpenedAt, now.toIso8601String());
      _processEngagement(interactedAt: now);
      await evaluateAndReschedule();
    } catch (e) {
      // لا يجوز تعطيل شاشة البداية لأي سبب متعلق بالإشعارات.
      log('onAppOpened skipped: $e', name: 'NotificationManager');
    }
  }

  /// إلغاء تذكيرات "متابعة القراءة" المجدولة بالنظام القديم
  /// (معرفاتها كانت `'quran'.tr.hashCode` و`'quranAudio'.tr.hashCode`).
  /// تُنفَّذ مرة واحدة فقط بعد التحديث؛ التذكيرات القديمة أحادية
  /// فتتلاشى وحدها حتى لو اختلفت لغة الجدولة عن الحالية.
  Future<void> _cancelLegacySchedules() async {
    if (_box.read(_kLegacyCleaned) == true) return;
    try {
      final helper = NotifyHelper();
      await helper.cancelNotification((await _t('quran')).hashCode);
      await helper.cancelNotification((await _t('quranAudio')).hashCode);
    } catch (e) {
      log('legacy schedule cleanup skipped: $e', name: 'NotificationManager');
    }
    _box.write(_kLegacyCleaned, true);
  }

  // ─── التقييم والجدولة ───

  /// نقطة الجدولة الوحيدة: تستشير المحرك ثم تنفّذ قراره.
  ///
  /// [force] يلغي الجدولة المعلقة قبل التقييم — تُستخدم عند تغيير
  /// الإعدادات كي يُعاد الحساب بالوقت الجديد بدل انتظار المعلقة.
  Future<void> evaluateAndReschedule({bool force = false}) async {
    try {
      // جدولة معلقة انقضت (أُطلقت فعلًا) تُنظَّف كي لا تحجب القرار.
      final stalePending = _readDate(_kPendingDigestAt);
      if (stalePending != null && !stalePending.isAfter(DateTime.now())) {
        _box.remove(_kPendingDigestAt);
      }

      if (force) {
        await _cancelPendingDigest();
      }

      final content = await _buildDigestContent();
      final decision = NotificationEngine.evaluate(
        EngineInputs(
          now: DateTime.now(),
          enabled: isEnabled,
          manualHour: manualHour,
          manualMinute: manualMinute,
          quietHoursEnabled: isQuietHoursEnabled,
          quietStartHour: quietStartHour,
          quietEndHour: quietEndHour,
          frequencyLevel: frequencyLevel,
          lastNotifiedAt: _readDate(_kLastNotifiedAt),
          pendingDigestAt: _readDate(_kPendingDigestAt),
          lastReadAt: _readDate(_kLastReadAt),
          readingHourHistogram: readReadingHistogram(),
          hasQuranProgress: content.hasQuran,
          hasBookProgress: content.hasBook,
          hasKhatmahProgress: content.hasKhatmah,
        ),
      );

      switch (decision.reason) {
        case SkipReason.tooSoon:
          // جدولة معلقة مستقبلية تحمي سقف التردد — تُترك كما هي.
          return;
        case SkipReason.disabled:
        case SkipReason.readToday:
        case SkipReason.noContent:
          await _cancelPendingDigest();
          return;
        default:
          break;
      }

      await _cancelPendingDigest();
      await NotifyHelper().scheduledNotification(
        reminderId: readingDigestId,
        title: await _t('continueReading'),
        summary: content.summary,
        body: content.parts.join('\n'),
        isRepeats: false,
        time: decision.sendAt,
        payload: {
          'type': 'reading_digest',
          'target': content.primaryTarget,
          if (content.primaryTarget == 'book') ...{
            'bookNumber': '${content.bookNumber}',
            'page': '${content.bookPage}',
          },
        },
      );
      _writeDate(_kLastNotifiedAt, decision.sendAt!);
      _writeDate(_kPendingDigestAt, decision.sendAt!);
      _box.write(_kLastNotifiedCounted, false);
      log(
        'Smart digest scheduled at ${decision.sendAt} '
        '(level: ${frequencyLevel.level})',
        name: 'NotificationManager',
      );
    } catch (e) {
      log('evaluateAndReschedule failed: $e', name: 'NotificationManager');
    }
  }

  Future<void> _cancelPendingDigest() async {
    try {
      await NotifyHelper().cancelNotification(readingDigestId);
    } catch (_) {}
    _box.remove(_kPendingDigestAt);
  }

  // ─── حلقة التغذية الراجعة ───

  void _processEngagement({required DateTime interactedAt}) {
    final lastNotifiedAt = _readDate(_kLastNotifiedAt);
    if (lastNotifiedAt == null) return;

    final result = NotificationEngine.processInteraction(
      now: DateTime.now(),
      frequencyLevel: frequencyLevel,
      engagementPoints: _box.read(_kEngagementPoints) ?? 0,
      consecutiveIgnored: _box.read(_kConsecutiveIgnored) ?? 0,
      lastNotifiedCounted: _box.read(_kLastNotifiedCounted) ?? true,
      lastNotifiedAt: lastNotifiedAt,
      lastInteractedAt: interactedAt,
    );

    _box.write(_kFreqLevel, result.frequencyLevel.level);
    _box.write(_kEngagementPoints, result.engagementPoints);
    _box.write(_kConsecutiveIgnored, result.consecutiveIgnored);
    _box.write(_kLastNotifiedCounted, result.lastNotifiedCounted);
  }

  // ─── بناء محتوى الهضم اليومي ───

  Future<_DigestContent> _buildDigestContent() async {
    final parts = <String>[];
    var hasQuran = false;
    var hasBook = false;
    var hasKhatmah = false;
    var primaryTarget = 'quran';
    var summary = '';
    int? bookNumber;
    int? bookPage;

    if (isQuranContentEnabled) {
      final page = _box.read('last_page');
      if (page is int && page >= 1 && page <= 604) {
        parts.add(await _t('notifyQuranBody', {'currentPageNumber': '$page'}));
        hasQuran = true;
        summary = await _t('quran');
        primaryTarget = 'quran';
      }
    }

    if (isBooksContentEnabled) {
      final raw = _box.read(_kLastBook);
      if (raw is Map) {
        final name = raw['name'];
        final number = raw['bookNumber'];
        final at = DateTime.tryParse('${raw['at'] ?? ''}');
        if (name is String &&
            name.isNotEmpty &&
            number is int &&
            at != null &&
            DateTime.now().difference(at).inDays <= 30) {
          parts.add(await _t('notifyBooksBody', {'bookName': name}));
          hasBook = true;
          bookNumber = number;
          bookPage = raw['page'] is int ? raw['page'] as int : null;
          if (!hasQuran) {
            summary = name;
            primaryTarget = 'book';
          }
        }
      }
    }

    final khatmahPart = await _buildKhatmahPart();
    if (khatmahPart != null) {
      parts.add(khatmahPart);
      hasKhatmah = true;
      if (parts.length == 1) {
        summary = await _t('khatmah');
        primaryTarget = 'khatmah';
      }
    }

    return _DigestContent(
      parts,
      summary,
      primaryTarget,
      hasQuran,
      hasBook,
      hasKhatmah,
      bookNumber,
      bookPage,
    );
  }

  /// جملة تقدم الختمة النشطة الأكثر إنجازًا، أو null إن لم توجد.
  Future<String?> _buildKhatmahPart() async {
    if (!isKhatmahContentEnabled) return null;
    try {
      final db = KhatmahDatabase();
      final khatmas = await db.getAllKhatmas();
      var bestDone = 0;
      var bestTotal = 0;
      for (final khatmah in khatmas) {
        if (khatmah.isCompleted) continue;
        final days = await db.getDaysForKhatmah(khatmah.id);
        final done = days.where((day) => day.isCompleted).length;
        if (done > 0 && done < khatmah.daysCount && done > bestDone) {
          bestDone = done;
          bestTotal = khatmah.daysCount;
        }
      }
      if (bestDone == 0) return null;
      return _t('khatmaRemainingDays', {
        'done': '$bestDone',
        'total': '$bestTotal',
      });
    } catch (e) {
      // قاعدة البيانات قد لا تكون متاحة في سياق الخلفية — يُتجاهل الجزء.
      log('khatmah digest part skipped: $e', name: 'NotificationManager');
      return null;
    }
  }

  // ─── الإعدادات (كل تغيير يعيد الجدولة فورًا) ───

  bool get isEnabled => _box.read(_kEnabled) ?? true;

  Future<void> setEnabled(bool value) async {
    _box.write(_kEnabled, value);
    await evaluateAndReschedule(force: true);
  }

  int? get manualHour =>
      _box.read(_kManualHour) is int ? _box.read(_kManualHour) as int : null;

  int? get manualMinute => _box.read(_kManualMinute) is int
      ? _box.read(_kManualMinute) as int
      : null;

  /// تعيين وقت يدوي، أو null للعودة إلى الاختيار التلقائي الذكي.
  Future<void> setManualTime(int? hour, [int? minute]) async {
    if (hour == null || hour < 0 || hour > 23) {
      _box.remove(_kManualHour);
      _box.remove(_kManualMinute);
    } else {
      _box.write(_kManualHour, hour);
      _box.write(_kManualMinute, (minute ?? 0).clamp(0, 59));
    }
    await evaluateAndReschedule(force: true);
  }

  bool get isQuietHoursEnabled => _box.read(_kQuietEnabled) ?? true;

  Future<void> setQuietHoursEnabled(bool value) async {
    _box.write(_kQuietEnabled, value);
    await evaluateAndReschedule(force: true);
  }

  int get quietStartHour => _box.read(_kQuietStart) ?? 22;

  int get quietEndHour => _box.read(_kQuietEnd) ?? 7;

  Future<void> setQuietHours(int startHour, int endHour) async {
    _box.write(_kQuietStart, startHour.clamp(0, 23));
    _box.write(_kQuietEnd, endHour.clamp(0, 23));
    await evaluateAndReschedule(force: true);
  }

  bool get isQuranContentEnabled => _box.read(_kContentQuran) ?? true;

  Future<void> setQuranContentEnabled(bool value) async {
    _box.write(_kContentQuran, value);
    await evaluateAndReschedule(force: true);
  }

  bool get isBooksContentEnabled => _box.read(_kContentBooks) ?? true;

  Future<void> setBooksContentEnabled(bool value) async {
    _box.write(_kContentBooks, value);
    await evaluateAndReschedule(force: true);
  }

  bool get isKhatmahContentEnabled => _box.read(_kContentKhatmah) ?? true;

  Future<void> setKhatmahContentEnabled(bool value) async {
    _box.write(_kContentKhatmah, value);
    await evaluateAndReschedule(force: true);
  }

  FrequencyLevel get frequencyLevel =>
      FrequencyLevel.fromIndex(_box.read(_kFreqLevel) ?? 0);

  // ─── مدرج ساعات القراءة ───

  /// مفتاح = الساعة (0-23)، قيمة = عدد أحداث القراءة.
  /// GetStorage يستدير المفاتيح إلى نصوص عند الحفظ فتُقرأ بالمحوّل.
  Map<int, int> readReadingHistogram() {
    final raw = _box.read(_kReadingHours);
    if (raw is! Map) return {};
    final result = <int, int>{};
    raw.forEach((key, value) {
      final hour = int.tryParse('$key');
      final count = value is int ? value : int.tryParse('$value');
      if (hour != null && hour >= 0 && hour <= 23 && count != null) {
        result[hour] = count;
      }
    });
    return result;
  }

  // ─── الترجمة (تعمل حتى في سياق headless حيث لا يتاح `.tr`) ───

  Map<String, String>? _langMap;
  String? _langMapCode;

  Future<String> _t(String key, [Map<String, String>? params]) async {
    final map = await _loadLangMap();
    var text = map[key] ?? key;
    params?.forEach((k, v) => text = text.replaceAll('@$k', v));
    return text;
  }

  Future<Map<String, String>> _loadLangMap() async {
    final code = (_box.read('lang') as String?) ?? 'ar';
    if (_langMap != null && _langMapCode == code) return _langMap!;
    try {
      final raw = await rootBundle.loadString('assets/locales/$code.json');
      final decoded = jsonDecode(raw);
      if (decoded is Map) {
        _langMap = decoded.map((k, v) => MapEntry('$k', '$v'));
        _langMapCode = code;
        return _langMap!;
      }
    } catch (e) {
      log('locale load failed for $code: $e', name: 'NotificationManager');
    }
    return {};
  }

  // ─── أدوات ───

  DateTime? _readDate(String key) {
    final raw = _box.read(key);
    if (raw is! String) return null;
    return DateTime.tryParse(raw);
  }

  void _writeDate(String key, DateTime value) {
    _box.write(key, value.toIso8601String());
  }
}

/// محتوى هضم القراءة المُجمَّع لإشعار يومي واحد.
class _DigestContent {
  _DigestContent(
    this.parts,
    this.summary,
    this.primaryTarget,
    this.hasQuran,
    this.hasBook,
    this.hasKhatmah,
    this.bookNumber,
    this.bookPage,
  );

  final List<String> parts;
  final String summary;

  /// الهدف عند النقر على الإشعار: quran | book | khatmah.
  final String primaryTarget;
  final bool hasQuran;
  final bool hasBook;
  final bool hasKhatmah;
  final int? bookNumber;
  final int? bookPage;
}

/// ثوابت ميزة مزامنة الأجهزة عبر QR.
///
/// النطاق: علامات/أذكار/خطط (Drift) + موضع القراءة والصوت +
/// إعدادات المصحف والعرض (GetStorage عبر قائمة المفاتيح أدناه).
/// المقاربة فرقية: لا نعدل حزمة quran_library بل نقارن القيم الحالية
/// مقابل آخر snapshot محلي.
class SyncConstants {
  SyncConstants._();

  // --- مفاتيح الحالة المحلية (GetStorage) ---
  static const String roomId = 'SYNC_ROOM_ID';
  static const String deviceId = 'SYNC_DEVICE_ID';
  static const String cursor = 'SYNC_CURSOR';
  static const String lastSyncedKv = 'SYNC_LAST_SYNCED_KV';
  static const String lastSyncAt = 'SYNC_LAST_AT';
  static const String lastPushedAt = 'SYNC_LAST_PUSHED_AT';

  /// محتوى QR — رابط deep-link قابل للنسخ يدويًا كبديل عن المسح.
  static const String qrPrefix = 'alquranalkareem://sync?room=';

  /// الحد الأقصى للعناصر في دفعة دفع واحدة (يطابق حد الخادم).
  static const int maxBatchSize = 500;

  /// مهلة debounce بعد التغييرات المحلية قبل دفعها.
  static const Duration pushDebounce = Duration(seconds: 10);

  /// عمر tombstones المحلية قبل تنظيفها.
  static const Duration tombstoneRetention = Duration(days: 90);

  /// مفاتيح GetStorage الدقيقة المتتبعة في المزامنة.
  static const Set<String> trackedKeys = {
    // موضع قراءة القرآن والصوت (quran_library)
    'last_page',
    'LAST_SURAH',
    'LAST_POSITION',
    'SURAH_READER_INDEX',
    'AYAH_READER_INDEX',
    'READER_NAME',

    // اختيار التفسير/الترجمة (quran_library)
    'TAFSEER_VAL',
    'TAFSEER_TABLE_VAL',
    'TRANS',
    'TRANSLATE_VALUE',
    'IS_TAFSEER',
    'FONT_SIZE',

    // إعدادات المصحف والعرض
    'font_size',
    'isTajweed',
    'fontsSelected2',
    'DISPLAY_MODE',
    'AUTO_SCROLL_SPEED',
    'BACKGROUND_PICKER_COLOR',
    'BACKGROUND_PICKER_COLOR_FOR_BOOK',
    'IS_TASHKIL',

    // الإعدادات العامة
    'SET_THEME',
    'APP_FONT_FAMILY',
    'SCREEN_SELECTED_VALUE',

    // اللغة
    'lang',
    'langName',
    'languageCode',
    'countryCode',
    'isUseEnglishNumbers',
    'languageFont',
  };

  /// بادئات المفاتيح المتتبعة (مثل آخر قراءة لكل كتاب: lastRead_7).
  static const List<String> trackedKeyPrefixes = ['lastRead_'];

  static bool isTrackedKey(String key) =>
      trackedKeys.contains(key) ||
      trackedKeyPrefixes.any((prefix) => key.startsWith(prefix));

  /// أنواع العناصر المتزامنة — تطابق ALLOWED_KINDS في sync_service.
  static const Set<String> itemKinds = {
    'bookmark',
    'bookmark_ayah',
    'adhkar',
    'khatmah',
    'khatmah_day',
    'books_bookmark',
    'kv',
  };
}

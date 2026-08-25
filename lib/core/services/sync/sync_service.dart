import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart' as drift;
import 'package:get_storage/get_storage.dart';
import 'package:uuid/uuid.dart';

import '../../utils/constants/sync_constants.dart';
import '../../../database/bookmark_db/bookmark_database.dart';
import '../../../presentation/screens/books/data/data_sources/books_bookmark_database.dart';
import '../../../presentation/screens/quran_page/widgets/khatmah/data/data_source/khatmah_database.dart';
import 'sync_api.dart';
import 'sync_logic.dart';
import 'sync_models.dart';

/// محرك مزامنة الأجهزة عبر QR.
///
/// دورة المزامنة: سحب (since cursor) ← تطبيق LWW محليًا ← دفع التغييرات
/// (صفوف Drift عبر updatedAt + فرق KV) ← تحديث المؤشرات. جميع العمليات
/// idempotent وفشل الشبكة يُعاد عند التريغر التالي.
class SyncService {
  SyncService({SyncApi? api}) : _api = api ?? SyncApi();

  final SyncApi _api;
  final GetStorage _box = GetStorage();
  final Uuid _uuid = const Uuid();
  final BookmarkDatabase _bookmarksDb = BookmarkDatabase();
  final KhatmahDatabase _khatmahDb = KhatmahDatabase();
  final BooksBookmarkDatabase _booksDb = BooksBookmarkDatabase();

  bool _syncing = false;
  bool get isSyncing => _syncing;

  /// تُستدعى بعد تطبيق تغييرات بعيدة كي تنعكس على الواجهات المفتوحة.
  void Function()? onRemoteChangesApplied;

  String? get roomId => _box.read(SyncConstants.roomId);
  String? get deviceId => _box.read(SyncConstants.deviceId);
  int get cursor => _box.read(SyncConstants.cursor) ?? 0;
  int get lastPushedAt => _box.read(SyncConstants.lastPushedAt) ?? 0;
  int? get lastSyncAt => _box.read(SyncConstants.lastSyncAt);

  bool get isPaired => roomId != null && deviceId != null;

  /// معلومات الغرفة لشاشة الحالة — يعيد null عند غياب الشبكة.
  Future<SyncRoomInfo?> roomInfo() async {
    if (!isPaired) return null;
    final result = await _api.roomInfo(roomId!);
    return result.fold((failure) => null, (info) => info);
  }

  // ---------- الإقران ----------

  /// إنشاء غرفة جديدة على الخادم وتسجيل هذا الجهاز فيها.
  Future<Either2<String>> createGroup() async {
    final created = await _api.createRoom();
    return created.fold((failure) => Either2.fail(failure.message), (
      roomId,
    ) async {
      final deviceId = _uuid.v4();
      final joined = await _api.joinRoom(roomId, deviceId);
      return joined.fold((failure) => Either2.fail(failure.message), (_) async {
        _box.write(SyncConstants.roomId, roomId);
        _box.write(SyncConstants.deviceId, deviceId);
        _box.write(SyncConstants.cursor, 0);
        _box.write(SyncConstants.lastPushedAt, 0);
        await syncNow();
        return Either2.ok(roomId);
      });
    });
  }

  /// الانضمام لغرفة قائمة عبر QR أو رمز نصي (يقبل رابط deep-link كاملًا).
  Future<Either2<String>> joinGroup(String scanned) async {
    final roomId = SyncLogic.extractRoomId(scanned);
    if (roomId == null || roomId.length < 10) {
      return Either2.fail('invalidSyncCode');
    }
    final deviceId = _uuid.v4();
    final joined = await _api.joinRoom(roomId, deviceId);
    return joined.fold((failure) => Either2.fail('${failure.code}'), (
      result,
    ) async {
      _box.write(SyncConstants.roomId, roomId);
      _box.write(SyncConstants.deviceId, deviceId);
      _box.write(SyncConstants.lastPushedAt, 0);
      // دمج تلقائي: نطبّق snapshot ثم ندفع كل ما هو محلي.
      final applied = await _applyItems(
        SyncLogic.sortParentsFirst(result.items),
      );
      _box.write(SyncConstants.cursor, result.latestSeq);
      await syncNow();
      if (applied) onRemoteChangesApplied?.call();
      return Either2.ok(roomId);
    });
  }

  /// مغادرة الغرفة محليًا — البيانات تبقى، ويمكن إعادة الإقران لاحقًا.
  Future<void> resetSync() async {
    await _box.remove(SyncConstants.roomId);
    await _box.remove(SyncConstants.deviceId);
    await _box.remove(SyncConstants.cursor);
    await _box.remove(SyncConstants.lastPushedAt);
    await _box.remove(SyncConstants.lastSyncAt);
    await _box.remove(SyncConstants.lastSyncedKv);
  }

  // ---------- دورة المزامنة ----------

  Future<void> syncNow() async {
    if (!isPaired || _syncing) return;
    _syncing = true;
    try {
      final pushStart = DateTime.now().millisecondsSinceEpoch;
      final pulled = await _pull();
      if (pulled == null) return; // فشل الشبكة — يُعاد لاحقًا.
      await _push(pushStart);
      if (pulled) onRemoteChangesApplied?.call();
      _box.write(
        SyncConstants.lastSyncAt,
        DateTime.now().millisecondsSinceEpoch,
      );
      await _cleanupTombstones();
    } finally {
      _syncing = false;
    }
  }

  /// يسحب التغييرات البعيدة. يعيد true إن طُبّق أي تغيير، وnull عند فشل الشبكة.
  Future<bool?> _pull() async {
    var appliedAny = false;
    var since = cursor;
    while (true) {
      final result = await _api.pullChanges(roomId!, since);
      final outcome = result.fold((failure) => null, (data) => data);
      if (outcome == null) return null;
      final (changes, latestSeq, hasMore) = outcome;
      final foreign = changes
          .where((change) => change.deviceId != deviceId)
          .toList(growable: false);
      final applied = await _applyItems(SyncLogic.sortParentsFirst(foreign));
      appliedAny = appliedAny || applied;
      since = latestSeq;
      _box.write(SyncConstants.cursor, latestSeq);
      if (!hasMore) break;
    }
    return appliedAny;
  }

  Future<bool> _push(int pushStart) async {
    await _backfillSyncUuids();
    final dirty = <SyncChange>[];
    dirty.addAll(await _collectDirtyDbRows());
    dirty.addAll(await _collectDirtyKv());
    if (dirty.isEmpty) {
      _box.write(SyncConstants.lastPushedAt, pushStart);
      return false;
    }
    // الخطة قبل أيامها حتى يجد الجهاز الآخر الأب قبل الأبناء.
    final sorted = SyncLogic.sortParentsFirst(dirty);
    for (var i = 0; i < sorted.length; i += SyncConstants.maxBatchSize) {
      final chunk = sorted.sublist(
        i,
        (i + SyncConstants.maxBatchSize).clamp(0, sorted.length),
      );
      final result = await _api.pushChanges(roomId!, deviceId!, chunk);
      if (result.isLeft) return false; // يعاد الدفع كاملًا في الدورة القادمة.
    }
    _box.write(SyncConstants.lastPushedAt, pushStart);
    await _saveKvSnapshot();
    return true;
  }

  // ---------- تجميع التغييرات المحلية ----------

  /// تعيين syncUuid وupdatedAt للصفوف القديمة التي نشأت قبل تفعيل المزامنة.
  Future<void> _backfillSyncUuids() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _backfillTable(
      'bookmarks',
      (id, uuid, ts) => _bookmarksDb.customStatement(
        'UPDATE bookmarks SET "sync_uuid" = ?, "updated_at" = ? WHERE "id" = ?',
        [uuid, ts, id],
      ),
      now,
    );
    await _backfillTable(
      'bookmarks_ayahs',
      (id, uuid, ts) => _bookmarksDb.customStatement(
        'UPDATE bookmarks_ayahs SET "sync_uuid" = ?, "updated_at" = ? WHERE "id" = ?',
        [uuid, ts, id],
      ),
      now,
    );
    await _backfillTable(
      'adhkar',
      (id, uuid, ts) => _bookmarksDb.customStatement(
        'UPDATE adhkar SET "sync_uuid" = ?, "updated_at" = ? WHERE "id" = ?',
        [uuid, ts, id],
      ),
      now,
    );
    await _backfillTable(
      'khatmahs',
      (id, uuid, ts) => _khatmahDb.customStatement(
        'UPDATE khatmahs SET "sync_uuid" = ?, "updated_at" = ? WHERE "id" = ?',
        [uuid, ts, id],
      ),
      now,
    );
    await _backfillTable(
      'khatmah_days',
      (id, uuid, ts) => _khatmahDb.customStatement(
        'UPDATE khatmah_days SET "sync_uuid" = ?, "updated_at" = ? WHERE "id" = ?',
        [uuid, ts, id],
      ),
      now,
    );
    await _backfillTable(
      'books_bookmark',
      (id, uuid, ts) => _booksDb.customStatement(
        'UPDATE books_bookmark SET "sync_uuid" = ?, "updated_at" = ? WHERE "id" = ?',
        [uuid, ts, id],
      ),
      now,
    );
  }

  Future<void> _backfillTable(
    String table,
    void Function(int id, String uuid, int ts) update,
    int now,
  ) async {
    final db = table == 'khatmahs' || table == 'khatmah_days'
        ? _khatmahDb
        : table == 'books_bookmark'
        ? _booksDb
        : _bookmarksDb;
    final rows = await db
        .customSelect(
          'SELECT "id" FROM $table WHERE "sync_uuid" IS NULL AND "deleted" = 0',
        )
        .get();
    for (final row in rows) {
      update(row.read<int>('id'), _uuid.v4(), now);
    }
  }

  Future<List<SyncChange>> _collectDirtyDbRows() async {
    final since = lastPushedAt;
    final changes = <SyncChange>[];

    final bookmarks = await (_bookmarksDb.select(
      _bookmarksDb.bookmarks,
    )..where((t) => t.updatedAt.isBiggerThanValue(since))).get();
    for (final row in bookmarks) {
      if (row.syncUuid == null) continue;
      changes.add(
        SyncChange(
          kind: 'bookmark',
          key: row.syncUuid!,
          payload: jsonEncode({
            'sorahName': row.sorahName,
            'pageNum': row.pageNum,
            'lastRead': row.lastRead,
          }),
          updatedAt: row.updatedAt,
          deleted: row.deleted,
        ),
      );
    }

    final ayahs = await (_bookmarksDb.select(
      _bookmarksDb.bookmarksAyahs,
    )..where((t) => t.updatedAt.isBiggerThanValue(since))).get();
    for (final row in ayahs) {
      if (row.syncUuid == null) continue;
      changes.add(
        SyncChange(
          kind: 'bookmark_ayah',
          key: row.syncUuid!,
          payload: jsonEncode({
            'surahName': row.surahName,
            'surahNumber': row.surahNumber,
            'pageNumber': row.pageNumber,
            'ayahNumber': row.ayahNumber,
            'ayahUQNumber': row.ayahUQNumber,
            'lastRead': row.lastRead,
          }),
          updatedAt: row.updatedAt,
          deleted: row.deleted,
        ),
      );
    }

    final adhkar = await (_bookmarksDb.select(
      _bookmarksDb.adhkar,
    )..where((t) => t.updatedAt.isBiggerThanValue(since))).get();
    for (final row in adhkar) {
      if (row.syncUuid == null) continue;
      changes.add(
        SyncChange(
          kind: 'adhkar',
          key: row.syncUuid!,
          payload: jsonEncode({
            'category': row.category,
            'count': row.count,
            'description': row.description,
            'reference': row.reference,
            'zekr': row.zekr,
          }),
          updatedAt: row.updatedAt,
          deleted: row.deleted,
        ),
      );
    }

    final khatmahs = await (_khatmahDb.select(
      _khatmahDb.khatmahs,
    )..where((t) => t.updatedAt.isBiggerThanValue(since))).get();
    final khatmahIdToUuid = <int, String>{};
    for (final row in khatmahs) {
      if (row.syncUuid == null) continue;
      khatmahIdToUuid[row.id] = row.syncUuid!;
      changes.add(
        SyncChange(
          kind: 'khatmah',
          key: row.syncUuid!,
          payload: jsonEncode({
            'name': row.name,
            'currentPage': row.currentPage,
            'startAyahNumber': row.startAyahNumber,
            'endAyahNumber': row.endAyahNumber,
            'isCompleted': row.isCompleted,
            'daysCount': row.daysCount,
            'isTahzibSahabah': row.isTahzibSahabah,
            'color': row.color,
            'startPage': row.startPage,
            'endPage': row.endPage,
          }),
          updatedAt: row.updatedAt,
          deleted: row.deleted,
        ),
      );
    }

    // أيام الخطط: كل الأيام المتسخة (وليس فقط خطط هذه الدفعة).
    if (khatmahIdToUuid.isNotEmpty) {
      // نحتاج uuid آباء كل الأيام — نجلبها كاملة إن ناقصت الخريطة.
    }
    final allKhatmahs = await _khatmahDb
        .customSelect('SELECT "id", "sync_uuid" FROM khatmahs')
        .get();
    for (final row in allKhatmahs) {
      final uuid = row.read<String?>('sync_uuid');
      if (uuid != null) khatmahIdToUuid[row.read<int>('id')] = uuid;
    }

    final days = await (_khatmahDb.select(
      _khatmahDb.khatmahDays,
    )..where((t) => t.updatedAt.isBiggerThanValue(since))).get();
    for (final row in days) {
      if (row.syncUuid == null) continue;
      final parentUuid = khatmahIdToUuid[row.khatmahId];
      if (parentUuid == null) continue;
      changes.add(
        SyncChange(
          kind: 'khatmah_day',
          key: row.syncUuid!,
          payload: jsonEncode({
            'parent': parentUuid,
            'day': row.day,
            'isCompleted': row.isCompleted,
            'startPage': row.startPage,
            'endPage': row.endPage,
          }),
          updatedAt: row.updatedAt,
          deleted: row.deleted,
        ),
      );
    }

    final bookMarks = await (_booksDb.select(
      _booksDb.booksBookmark,
    )..where((t) => t.updatedAt.isBiggerThanValue(since))).get();
    for (final row in bookMarks) {
      if (row.syncUuid == null) continue;
      changes.add(
        SyncChange(
          kind: 'books_bookmark',
          key: row.syncUuid!,
          payload: jsonEncode({
            'bookName': row.bookName,
            'bookNumber': row.bookNumber,
            'currentPage': row.currentPage,
          }),
          updatedAt: row.updatedAt,
          deleted: row.deleted,
        ),
      );
    }

    return changes;
  }

  List<SyncChange> _collectDirtyKvNow(int now) {
    final current = _readKvSnapshot();
    final lastSynced =
        (GetStorage().read(SyncConstants.lastSyncedKv) as Map?)
            ?.cast<String, dynamic>() ??
        <String, dynamic>{};
    return SyncLogic.kvDiff(current, lastSynced, now);
  }

  Future<List<SyncChange>> _collectDirtyKv() async =>
      _collectDirtyKvNow(DateTime.now().millisecondsSinceEpoch);

  Map<String, dynamic> _readKvSnapshot() {
    final snapshot = <String, dynamic>{};
    for (final key in _box.getKeys().cast<String>()) {
      if (SyncConstants.isTrackedKey(key)) {
        snapshot[key] = _box.read(key);
      }
    }
    return snapshot;
  }

  Future<void> _saveKvSnapshot() async {
    await _box.write(SyncConstants.lastSyncedKv, _readKvSnapshot());
  }

  // ---------- تطبيق التغييرات البعيدة (LWW) ----------

  Future<bool> _applyItems(List<SyncChange> items) async {
    var appliedAny = false;
    for (final item in items) {
      final applied = await _applyItem(item);
      appliedAny = appliedAny || applied;
    }
    return appliedAny;
  }

  Future<bool> _applyItem(SyncChange item) async {
    switch (item.kind) {
      case 'bookmark':
        return _applyBookmark(item);
      case 'bookmark_ayah':
        return _applyBookmarkAyah(item);
      case 'adhkar':
        return _applyAdhkar(item);
      case 'khatmah':
        return _applyKhatmah(item);
      case 'khatmah_day':
        return _applyKhatmahDay(item);
      case 'books_bookmark':
        return _applyBooksBookmark(item);
      case 'kv':
        return _applyKv(item);
      default:
        return false;
    }
  }

  Map<String, dynamic> _decodePayload(SyncChange item) {
    if (item.payload.isEmpty) return {};
    return Map<String, dynamic>.from(jsonDecode(item.payload) as Map);
  }

  Future<bool> _applyBookmark(SyncChange item) async {
    final db = _bookmarksDb;
    final existing = await (db.select(
      db.bookmarks,
    )..where((t) => t.syncUuid.equals(item.key))).getSingleOrNull();
    if (existing != null && existing.updatedAt >= item.updatedAt) return false;
    final data = _decodePayload(item);
    if (existing == null) {
      if (item.deleted) return false;
      await db
          .into(db.bookmarks)
          .insert(
            BookmarksCompanion.insert(
              sorahName: data['sorahName'] as String? ?? '',
              pageNum: (data['pageNum'] as num?)?.toInt() ?? 0,
              lastRead: data['lastRead'] as String? ?? '',
              syncUuid: drift.Value(item.key),
              updatedAt: drift.Value(item.updatedAt),
            ),
          );
      return true;
    }
    await (db.update(
      db.bookmarks,
    )..where((t) => t.syncUuid.equals(item.key))).write(
      BookmarksCompanion(
        sorahName: drift.Value(
          data['sorahName'] as String? ?? existing.sorahName,
        ),
        pageNum: drift.Value(
          (data['pageNum'] as num?)?.toInt() ?? existing.pageNum,
        ),
        lastRead: drift.Value(data['lastRead'] as String? ?? existing.lastRead),
        deleted: drift.Value(item.deleted),
        updatedAt: drift.Value(item.updatedAt),
      ),
    );
    return true;
  }

  Future<bool> _applyBookmarkAyah(SyncChange item) async {
    final db = _bookmarksDb;
    final existing = await (db.select(
      db.bookmarksAyahs,
    )..where((t) => t.syncUuid.equals(item.key))).getSingleOrNull();
    if (existing != null && existing.updatedAt >= item.updatedAt) return false;
    final data = _decodePayload(item);
    if (existing == null) {
      if (item.deleted) return false;
      await db
          .into(db.bookmarksAyahs)
          .insert(
            BookmarksAyahsCompanion.insert(
              surahName: data['surahName'] as String? ?? '',
              surahNumber: (data['surahNumber'] as num?)?.toInt() ?? 0,
              pageNumber: (data['pageNumber'] as num?)?.toInt() ?? 0,
              ayahNumber: (data['ayahNumber'] as num?)?.toInt() ?? 0,
              ayahUQNumber: (data['ayahUQNumber'] as num?)?.toInt() ?? 0,
              lastRead: data['lastRead'] as String? ?? '',
              syncUuid: drift.Value(item.key),
              updatedAt: drift.Value(item.updatedAt),
            ),
          );
      return true;
    }
    await (db.update(
      db.bookmarksAyahs,
    )..where((t) => t.syncUuid.equals(item.key))).write(
      BookmarksAyahsCompanion(
        surahName: drift.Value(
          data['surahName'] as String? ?? existing.surahName,
        ),
        surahNumber: drift.Value(
          (data['surahNumber'] as num?)?.toInt() ?? existing.surahNumber,
        ),
        pageNumber: drift.Value(
          (data['pageNumber'] as num?)?.toInt() ?? existing.pageNumber,
        ),
        ayahNumber: drift.Value(
          (data['ayahNumber'] as num?)?.toInt() ?? existing.ayahNumber,
        ),
        ayahUQNumber: drift.Value(
          (data['ayahUQNumber'] as num?)?.toInt() ?? existing.ayahUQNumber,
        ),
        lastRead: drift.Value(data['lastRead'] as String? ?? existing.lastRead),
        deleted: drift.Value(item.deleted),
        updatedAt: drift.Value(item.updatedAt),
      ),
    );
    return true;
  }

  Future<bool> _applyAdhkar(SyncChange item) async {
    final db = _bookmarksDb;
    final existing = await (db.select(
      db.adhkar,
    )..where((t) => t.syncUuid.equals(item.key))).getSingleOrNull();
    if (existing != null && existing.updatedAt >= item.updatedAt) return false;
    final data = _decodePayload(item);
    if (existing == null) {
      if (item.deleted) return false;
      await db
          .into(db.adhkar)
          .insert(
            AdhkarCompanion.insert(
              category: data['category'] as String? ?? '',
              count: data['count'] as String? ?? '',
              description: data['description'] as String? ?? '',
              reference: data['reference'] as String? ?? '',
              zekr: data['zekr'] as String? ?? '',
              syncUuid: drift.Value(item.key),
              updatedAt: drift.Value(item.updatedAt),
            ),
          );
      return true;
    }
    await (db.update(
      db.adhkar,
    )..where((t) => t.syncUuid.equals(item.key))).write(
      AdhkarCompanion(
        category: drift.Value(data['category'] as String? ?? existing.category),
        count: drift.Value(data['count'] as String? ?? existing.count),
        description: drift.Value(
          data['description'] as String? ?? existing.description,
        ),
        reference: drift.Value(
          data['reference'] as String? ?? existing.reference,
        ),
        zekr: drift.Value(data['zekr'] as String? ?? existing.zekr),
        deleted: drift.Value(item.deleted),
        updatedAt: drift.Value(item.updatedAt),
      ),
    );
    return true;
  }

  Future<bool> _applyKhatmah(SyncChange item) async {
    final db = _khatmahDb;
    final existing = await (db.select(
      db.khatmahs,
    )..where((t) => t.syncUuid.equals(item.key))).getSingleOrNull();
    if (existing != null && existing.updatedAt >= item.updatedAt) return false;
    final data = _decodePayload(item);
    if (existing == null) {
      if (item.deleted) return false;
      await db
          .into(db.khatmahs)
          .insert(
            KhatmahsCompanion.insert(
              name: drift.Value(data['name'] as String?),
              currentPage: drift.Value((data['currentPage'] as num?)?.toInt()),
              startAyahNumber: drift.Value(
                (data['startAyahNumber'] as num?)?.toInt(),
              ),
              endAyahNumber: drift.Value(
                (data['endAyahNumber'] as num?)?.toInt(),
              ),
              isCompleted: drift.Value(data['isCompleted'] as bool? ?? false),
              daysCount: drift.Value(
                (data['daysCount'] as num?)?.toInt() ?? 30,
              ),
              isTahzibSahabah: drift.Value(
                data['isTahzibSahabah'] as bool? ?? false,
              ),
              color: drift.Value((data['color'] as num?)?.toInt()),
              startPage: drift.Value((data['startPage'] as num?)?.toInt()),
              endPage: drift.Value((data['endPage'] as num?)?.toInt()),
              syncUuid: drift.Value(item.key),
              updatedAt: drift.Value(item.updatedAt),
            ),
          );
      return true;
    }
    await (db.update(
      db.khatmahs,
    )..where((t) => t.syncUuid.equals(item.key))).write(
      KhatmahsCompanion(
        name: drift.Value(data['name'] as String? ?? existing.name),
        currentPage: drift.Value(
          (data['currentPage'] as num?)?.toInt() ?? existing.currentPage,
        ),
        startAyahNumber: drift.Value(
          (data['startAyahNumber'] as num?)?.toInt() ??
              existing.startAyahNumber,
        ),
        endAyahNumber: drift.Value(
          (data['endAyahNumber'] as num?)?.toInt() ?? existing.endAyahNumber,
        ),
        isCompleted: drift.Value(
          data['isCompleted'] as bool? ?? existing.isCompleted,
        ),
        daysCount: drift.Value(
          (data['daysCount'] as num?)?.toInt() ?? existing.daysCount,
        ),
        isTahzibSahabah: drift.Value(
          data['isTahzibSahabah'] as bool? ?? existing.isTahzibSahabah,
        ),
        color: drift.Value((data['color'] as num?)?.toInt() ?? existing.color),
        startPage: drift.Value(
          (data['startPage'] as num?)?.toInt() ?? existing.startPage,
        ),
        endPage: drift.Value(
          (data['endPage'] as num?)?.toInt() ?? existing.endPage,
        ),
        deleted: drift.Value(item.deleted),
        updatedAt: drift.Value(item.updatedAt),
      ),
    );
    return true;
  }

  Future<bool> _applyKhatmahDay(SyncChange item) async {
    final db = _khatmahDb;
    final data = _decodePayload(item);
    final parentUuid = data['parent'] as String?;
    if (parentUuid == null) return false;
    final parent = await (db.select(
      db.khatmahs,
    )..where((t) => t.syncUuid.equals(parentUuid))).getSingleOrNull();
    if (parent == null || parent.deleted) return false;
    final existing = await (db.select(
      db.khatmahDays,
    )..where((t) => t.syncUuid.equals(item.key))).getSingleOrNull();
    if (existing != null && existing.updatedAt >= item.updatedAt) return false;
    if (existing == null) {
      if (item.deleted) return false;
      await db
          .into(db.khatmahDays)
          .insert(
            KhatmahDaysCompanion.insert(
              khatmahId: parent.id,
              day: (data['day'] as num?)?.toInt() ?? 1,
              isCompleted: drift.Value(data['isCompleted'] as bool? ?? false),
              startPage: drift.Value((data['startPage'] as num?)?.toInt()),
              endPage: drift.Value((data['endPage'] as num?)?.toInt()),
              syncUuid: drift.Value(item.key),
              updatedAt: drift.Value(item.updatedAt),
            ),
          );
      return true;
    }
    await (db.update(
      db.khatmahDays,
    )..where((t) => t.syncUuid.equals(item.key))).write(
      KhatmahDaysCompanion(
        khatmahId: drift.Value(parent.id),
        day: drift.Value((data['day'] as num?)?.toInt() ?? existing.day),
        isCompleted: drift.Value(
          data['isCompleted'] as bool? ?? existing.isCompleted,
        ),
        startPage: drift.Value(
          (data['startPage'] as num?)?.toInt() ?? existing.startPage,
        ),
        endPage: drift.Value(
          (data['endPage'] as num?)?.toInt() ?? existing.endPage,
        ),
        deleted: drift.Value(item.deleted),
        updatedAt: drift.Value(item.updatedAt),
      ),
    );
    return true;
  }

  Future<bool> _applyBooksBookmark(SyncChange item) async {
    final db = _booksDb;
    final existing = await (db.select(
      db.booksBookmark,
    )..where((t) => t.syncUuid.equals(item.key))).getSingleOrNull();
    if (existing != null && existing.updatedAt >= item.updatedAt) return false;
    final data = _decodePayload(item);
    if (existing == null) {
      if (item.deleted) return false;
      await db
          .into(db.booksBookmark)
          .insert(
            BooksBookmarkCompanion.insert(
              bookName: drift.Value(data['bookName'] as String?),
              bookNumber: drift.Value((data['bookNumber'] as num?)?.toInt()),
              currentPage: drift.Value((data['currentPage'] as num?)?.toInt()),
              syncUuid: drift.Value(item.key),
              updatedAt: drift.Value(item.updatedAt),
            ),
          );
      return true;
    }
    await (db.update(
      db.booksBookmark,
    )..where((t) => t.syncUuid.equals(item.key))).write(
      BooksBookmarkCompanion(
        bookName: drift.Value(data['bookName'] as String? ?? existing.bookName),
        bookNumber: drift.Value(
          (data['bookNumber'] as num?)?.toInt() ?? existing.bookNumber,
        ),
        currentPage: drift.Value(
          (data['currentPage'] as num?)?.toInt() ?? existing.currentPage,
        ),
        deleted: drift.Value(item.deleted),
        updatedAt: drift.Value(item.updatedAt),
      ),
    );
    return true;
  }

  /// KV: مفتاح GetStorage متتبع. الحماية من ping-pong: إن كان المفتاح متسخًا
  /// محليًا (قيمته الحالية ≠ آخر قيمة مزامَنة) فالتغيير المحلي يفوز ولا نطبّق.
  Future<bool> _applyKv(SyncChange item) async {
    final data = _decodePayload(item);
    final value = data['v'];
    final lastSynced =
        (_box.read(SyncConstants.lastSyncedKv) as Map?)
            ?.cast<String, dynamic>() ??
        <String, dynamic>{};
    final current = _box.read(item.key);
    final isDirtyLocally =
        !lastSynced.containsKey(item.key) || lastSynced[item.key] != current;
    if (isDirtyLocally && current != null) {
      // التغيير المحلي أحدث — سيُدفع في الدورة نفسها.
      return false;
    }
    if (item.deleted) {
      await _box.remove(item.key);
    } else {
      await _box.write(item.key, value);
    }
    lastSynced[item.key] = value;
    await _box.write(SyncConstants.lastSyncedKv, lastSynced);
    return current != value;
  }

  // ---------- تنظيف tombstones المحلية ----------

  Future<void> _cleanupTombstones() async {
    final cutoff = DateTime.now()
        .subtract(SyncConstants.tombstoneRetention)
        .millisecondsSinceEpoch;
    final staleParents = await _khatmahDb
        .customSelect(
          'SELECT "id" FROM khatmahs WHERE "deleted" = 1 AND "updated_at" < ?',
          variables: [drift.Variable.withInt(cutoff)],
        )
        .get();
    if (staleParents.isNotEmpty) {
      final ids = staleParents.map((row) => row.read<int>('id')).toList();
      final placeholders = List.filled(ids.length, '?').join(',');
      await _khatmahDb.customStatement(
        'DELETE FROM khatmah_days WHERE "khatmah_id" IN ($placeholders)',
        ids,
      );
      await _khatmahDb.customStatement(
        'DELETE FROM khatmahs WHERE "id" IN ($placeholders)',
        ids,
      );
    }
    await _khatmahDb.customStatement(
      'DELETE FROM khatmah_days WHERE "deleted" = 1 AND "updated_at" < ?',
      [cutoff],
    );
    await _bookmarksDb.customStatement(
      'DELETE FROM bookmarks WHERE "deleted" = 1 AND "updated_at" < ?',
      [cutoff],
    );
    await _bookmarksDb.customStatement(
      'DELETE FROM bookmarks_ayahs WHERE "deleted" = 1 AND "updated_at" < ?',
      [cutoff],
    );
    await _bookmarksDb.customStatement(
      'DELETE FROM adhkar WHERE "deleted" = 1 AND "updated_at" < ?',
      [cutoff],
    );
    await _booksDb.customStatement(
      'DELETE FROM books_bookmark WHERE "deleted" = 1 AND "updated_at" < ?',
      [cutoff],
    );
  }
}

/// نتيجة عملية صغيرة (نجاح برسالة أو فشل برسالة) — أخف من Either للداخل.
class Either2<T> {
  const Either2._(this.ok, this.value);
  final bool ok;
  final T value;

  factory Either2.ok(T value) => Either2._(true, value);
  factory Either2.fail(T message) => Either2._(false, message);
}

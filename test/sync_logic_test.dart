import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:alquranalkareem/core/services/sync/sync_logic.dart';
import 'package:alquranalkareem/core/services/sync/sync_models.dart';
import 'package:alquranalkareem/core/utils/constants/sync_constants.dart';

void main() {
  group('SyncLogic.extractRoomId', () {
    test('يستخرج المعرف من رابط deep-link الخاص بالتطبيق', () {
      const link = 'alquranalkareem://sync?room=AbCdEf12345678901234';
      expect(SyncLogic.extractRoomId(link), 'AbCdEf12345678901234');
    });

    test('يستخرج المعرف من URI عام يحتوي باراميتر room', () {
      const link = 'https://example.com/pair?room=Xyz789abc123';
      expect(SyncLogic.extractRoomId(link), 'Xyz789abc123');
    });

    test('يعيد الرمز الخام كما هو مع تجاهل الفراغات', () {
      expect(SyncLogic.extractRoomId('  RawCode123  '), 'RawCode123');
    });
  });

  group('SyncLogic.sortParentsFirst', () {
    test('يقدم الخطط على أيامها ويحافظ على ترتيب البقية', () {
      final items = [
        const SyncChange(
          kind: 'khatmah_day',
          key: 'd1',
          payload: '',
          updatedAt: 1,
          deleted: false,
        ),
        const SyncChange(
          kind: 'bookmark',
          key: 'b1',
          payload: '',
          updatedAt: 1,
          deleted: false,
        ),
        const SyncChange(
          kind: 'khatmah',
          key: 'k1',
          payload: '',
          updatedAt: 1,
          deleted: false,
        ),
        const SyncChange(
          kind: 'kv',
          key: 'font_size',
          payload: '',
          updatedAt: 1,
          deleted: false,
        ),
      ];
      final sorted = SyncLogic.sortParentsFirst(items);
      expect(sorted.map((e) => e.kind).toList(), [
        'bookmark',
        'khatmah',
        'kv',
        'khatmah_day',
      ]);
    });
  });

  group('SyncLogic.kvDiff', () {
    const now = 1756000000000;

    test('لا تغييرات عندما تتطابق القيم مع آخر مزامنة', () {
      final diff = SyncLogic.kvDiff(
        {'font_size': 20, 'lang': 'ar'},
        {'font_size': 20, 'lang': 'ar'},
        now,
      );
      expect(diff, isEmpty);
    });

    test('يكتشف المفتاح الجديد والقيمة المتغيرة', () {
      final diff = SyncLogic.kvDiff(
        {'last_page': 30, 'SET_THEME': 'dark'},
        {'last_page': 25},
        now,
      );
      expect(diff.length, 2);
      final keys = diff.map((c) => c.key).toSet();
      expect(keys, {'last_page', 'SET_THEME'});
      for (final change in diff) {
        expect(change.kind, 'kv');
        expect(change.deleted, false);
        expect(change.updatedAt, now);
      }
      final decodedLastPage =
          (jsonDecode(diff.firstWhere((c) => c.key == 'last_page').payload)
              as Map)['v'];
      expect(decodedLastPage, 30);
    });

    test('يتجاهل المفاتيح المحذوفة محليًا (v1)', () {
      final diff = SyncLogic.kvDiff(
        {'font_size': 20},
        {'font_size': 20, 'SET_THEME': 'dark'},
        now,
      );
      expect(diff, isEmpty);
    });

    test('يفلت القيم النصية المحتوية على علامات اقتباس', () {
      final diff = SyncLogic.kvDiff({'x': 'a"b\\c'}, {}, now);
      final decoded = (jsonDecode(diff.single.payload) as Map)['v'];
      expect(decoded, 'a"b\\c');
    });
  });

  group('SyncConstants.isTrackedKey', () {
    test('يتعرف على المفاتيح الدقيقة وبادئات الكتب', () {
      expect(SyncConstants.isTrackedKey('last_page'), isTrue);
      expect(SyncConstants.isTrackedKey('lastRead_7'), isTrue);
      expect(SyncConstants.isTrackedKey('SURAH_READER_INDEX'), isTrue);
      expect(SyncConstants.isTrackedKey('SEARCH_HISTORY'), isFalse);
      expect(SyncConstants.isTrackedKey('sn_reading_hours'), isFalse);
    });
  });

  group('SyncChange serialization', () {
    test('round-trip من وإلى JSON السحب', () {
      const change = SyncChange(
        kind: 'bookmark',
        key: 'uuid-1',
        payload: '{"pageNum":3}',
        updatedAt: 1756000000123,
        deleted: true,
        seq: 42,
        deviceId: 'device-a',
      );
      final request = change.toRequestJson();
      expect(request['deleted'], isTrue);
      expect(request['updated_at'], 1756000000123);

      final pulled = SyncChange.fromPullJson({
        'kind': 'bookmark',
        'key': 'uuid-1',
        'payload': '{"pageNum":3}',
        'updated_at': 1756000000123,
        'deleted': 1,
        'seq': 42,
        'device_id': 'device-a',
      });
      expect(pulled.deleted, isTrue);
      expect(pulled.seq, 42);
      expect(pulled.deviceId, 'device-a');
    });
  });
}

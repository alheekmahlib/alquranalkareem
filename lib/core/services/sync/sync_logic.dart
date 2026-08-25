import '../../utils/constants/sync_constants.dart';
import 'sync_models.dart';

/// منطق المزامنة النقي (بلا DB ولا شبكة) — مفصول ليسهل اختباره.
class SyncLogic {
  SyncLogic._();

  /// يستخرج room_id من مخرجات QR: رابط deep-link كامل أو رمز خام.
  static String? extractRoomId(String input) {
    final trimmed = input.trim();
    if (trimmed.startsWith(SyncConstants.qrPrefix)) {
      return trimmed.substring(SyncConstants.qrPrefix.length);
    }
    final uri = Uri.tryParse(trimmed);
    if (uri != null && uri.queryParameters.containsKey('room')) {
      return uri.queryParameters['room'];
    }
    return trimmed;
  }

  /// يرتب عناصر المزامنة بحيث تسبق الخطة (الأب) أيامها (الأبناء)
  /// فيجدها الجهاز المستقبل قبل أيامها عند التطبيق.
  static List<SyncChange> sortParentsFirst(List<SyncChange> items) {
    final parents = items.where((item) => item.kind != 'khatmah_day').toList();
    final days = items.where((item) => item.kind == 'khatmah_day').toList();
    return [...parents, ...days];
  }

  /// فرق KV: المفاتيح الجديدة أو المتغيرة منذ آخر snapshot.
  /// المفاتيح المحذوفة محليًا لا تُزامن في v1 (الحذف الناعم للجداول فقط).
  static List<SyncChange> kvDiff(
    Map<String, dynamic> current,
    Map<String, dynamic> lastSynced,
    int now,
  ) {
    final changes = <SyncChange>[];
    current.forEach((key, value) {
      if (!lastSynced.containsKey(key) || lastSynced[key] != value) {
        changes.add(
          SyncChange(
            kind: 'kv',
            key: key,
            payload: '{"v":${_encodeValue(value)}}',
            updatedAt: now,
            deleted: false,
          ),
        );
      }
    });
    return changes;
  }

  static String _encodeValue(dynamic value) {
    if (value == null) return 'null';
    if (value is String) {
      final escaped = value.replaceAll('\\', '\\\\').replaceAll('"', '\\"');
      return '"$escaped"';
    }
    return value.toString();
  }
}

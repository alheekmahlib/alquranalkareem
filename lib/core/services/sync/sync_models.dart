/// نماذج بيانات ميزة مزامنة الأجهزة عبر QR.
///
/// `SyncChange` هو العنصر الوحيد المتنقل بين الأجهزة: نوع + مفتاح مستقر
/// (syncUuid للصفوف، اسم مفتاح GetStorage للـ KV) + حمولة JSON +
/// طابع زمني LWW + علم حذف (tombstone).
class SyncChange {
  const SyncChange({
    required this.kind,
    required this.key,
    required this.payload,
    required this.updatedAt,
    required this.deleted,
    this.seq,
    this.deviceId,
  });

  final String kind;
  final String key;
  final String payload;
  final int updatedAt;
  final bool deleted;
  final int? seq;
  final String? deviceId;

  Map<String, dynamic> toRequestJson() => {
    'kind': kind,
    'key': key,
    'payload': payload,
    'updated_at': updatedAt,
    'deleted': deleted,
  };

  factory SyncChange.fromPullJson(Map<String, dynamic> json) => SyncChange(
    kind: json['kind'] as String,
    key: json['key'] as String,
    payload: json['payload'] as String? ?? '',
    updatedAt: (json['updated_at'] as num).toInt(),
    deleted: (json['deleted'] as num?) == 1,
    seq: (json['seq'] as num?)?.toInt(),
    deviceId: json['device_id'] as String?,
  );
}

/// نتيجة الانضمام لغرفة مزامنة.
class SyncJoinResult {
  const SyncJoinResult({
    required this.latestSeq,
    required this.deviceCount,
    required this.items,
  });

  final int latestSeq;
  final int deviceCount;
  final List<SyncChange> items;
}

/// حالة الغرفة لعرضها في شاشة المزامنة.
class SyncRoomInfo {
  const SyncRoomInfo({
    required this.deviceCount,
    required this.lastActiveAt,
    required this.latestSeq,
  });

  final int deviceCount;
  final int lastActiveAt;
  final int latestSeq;
}

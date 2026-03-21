class PlayListModel {
  int id;
  String name;
  String readerName;
  int fromSurahNumber;
  String fromSurahName;
  int fromAyah;
  int fromAyahUQ;
  int toSurahNumber;
  String toSurahName;
  int toAyah;
  int toAyahUQ;
  String? createdAt;

  PlayListModel({
    required this.id,
    required this.name,
    required this.readerName,
    required this.fromSurahNumber,
    required this.fromSurahName,
    required this.fromAyah,
    required this.fromAyahUQ,
    required this.toSurahNumber,
    required this.toSurahName,
    required this.toAyah,
    required this.toAyahUQ,
    this.createdAt,
  });

  int get totalAyahs => toAyahUQ - fromAyahUQ + 1;

  String get displayName {
    if (name.isNotEmpty) return name;
    final from = fromSurahName.replaceAll('سُورَةُ ', '');
    final to = toSurahName.replaceAll('سُورَةُ ', '');
    if (fromSurahNumber == toSurahNumber) return from;
    return '$from - $to';
  }

  /// يدعم النسخة القديمة (حقول startNum/endNum) والجديدة
  factory PlayListModel.fromJson(Map<String, dynamic> json) {
    // Migration: النموذج القديم (startNum بدون fromSurahNumber)
    if (json.containsKey('startNum') && !json.containsKey('fromSurahNumber')) {
      return PlayListModel(
        id: json['id'],
        name: json['name'] ?? '',
        readerName: json['readerName'] ?? '',
        fromSurahNumber: json['surahNum'] ?? 1,
        fromSurahName: json['surahName'] ?? '',
        fromAyah: json['startNum'],
        fromAyahUQ: json['startUQNum'],
        toSurahNumber: json['surahNum'] ?? 1,
        toSurahName: json['surahName'] ?? '',
        toAyah: json['endNum'],
        toAyahUQ: json['endUQNum'],
        createdAt: json['createdAt'],
      );
    }
    // Migration: نموذج segments (التنسيق السابق بالمقاطع)
    if (json.containsKey('segments')) {
      final segments = json['segments'] as List;
      final first = segments.first as Map<String, dynamic>;
      final last = segments.last as Map<String, dynamic>;
      return PlayListModel(
        id: json['id'],
        name: json['name'] ?? '',
        readerName: json['readerName'] ?? '',
        fromSurahNumber: first['surahNumber'],
        fromSurahName: first['surahName'] ?? '',
        fromAyah: first['startAyah'],
        fromAyahUQ: first['startAyahUQ'],
        toSurahNumber: last['surahNumber'],
        toSurahName: last['surahName'] ?? '',
        toAyah: last['endAyah'],
        toAyahUQ: last['endAyahUQ'],
        createdAt: json['createdAt'],
      );
    }
    return PlayListModel(
      id: json['id'],
      name: json['name'] ?? '',
      readerName: json['readerName'] ?? '',
      fromSurahNumber: json['fromSurahNumber'],
      fromSurahName: json['fromSurahName'] ?? '',
      fromAyah: json['fromAyah'],
      fromAyahUQ: json['fromAyahUQ'],
      toSurahNumber: json['toSurahNumber'],
      toSurahName: json['toSurahName'] ?? '',
      toAyah: json['toAyah'],
      toAyahUQ: json['toAyahUQ'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'readerName': readerName,
      'fromSurahNumber': fromSurahNumber,
      'fromSurahName': fromSurahName,
      'fromAyah': fromAyah,
      'fromAyahUQ': fromAyahUQ,
      'toSurahNumber': toSurahNumber,
      'toSurahName': toSurahName,
      'toAyah': toAyah,
      'toAyahUQ': toAyahUQ,
      'createdAt': createdAt ?? DateTime.now().toIso8601String(),
    };
  }
}

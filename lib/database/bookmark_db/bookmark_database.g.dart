// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_database.dart';

// ignore_for_file: type=lint
class $BookmarksTable extends Bookmarks
    with TableInfo<$BookmarksTable, Bookmark> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookmarksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sorahNameMeta = const VerificationMeta(
    'sorahName',
  );
  @override
  late final GeneratedColumn<String> sorahName = GeneratedColumn<String>(
    'sorah_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pageNumMeta = const VerificationMeta(
    'pageNum',
  );
  @override
  late final GeneratedColumn<int> pageNum = GeneratedColumn<int>(
    'page_num',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastReadMeta = const VerificationMeta(
    'lastRead',
  );
  @override
  late final GeneratedColumn<String> lastRead = GeneratedColumn<String>(
    'last_read',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncUuidMeta = const VerificationMeta(
    'syncUuid',
  );
  @override
  late final GeneratedColumn<String> syncUuid = GeneratedColumn<String>(
    'sync_uuid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sorahName,
    pageNum,
    lastRead,
    syncUuid,
    updatedAt,
    deleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bookmarks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Bookmark> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sorah_name')) {
      context.handle(
        _sorahNameMeta,
        sorahName.isAcceptableOrUnknown(data['sorah_name']!, _sorahNameMeta),
      );
    } else if (isInserting) {
      context.missing(_sorahNameMeta);
    }
    if (data.containsKey('page_num')) {
      context.handle(
        _pageNumMeta,
        pageNum.isAcceptableOrUnknown(data['page_num']!, _pageNumMeta),
      );
    } else if (isInserting) {
      context.missing(_pageNumMeta);
    }
    if (data.containsKey('last_read')) {
      context.handle(
        _lastReadMeta,
        lastRead.isAcceptableOrUnknown(data['last_read']!, _lastReadMeta),
      );
    } else if (isInserting) {
      context.missing(_lastReadMeta);
    }
    if (data.containsKey('sync_uuid')) {
      context.handle(
        _syncUuidMeta,
        syncUuid.isAcceptableOrUnknown(data['sync_uuid']!, _syncUuidMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Bookmark map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Bookmark(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sorahName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sorah_name'],
      )!,
      pageNum: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_num'],
      )!,
      lastRead: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_read'],
      )!,
      syncUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_uuid'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
    );
  }

  @override
  $BookmarksTable createAlias(String alias) {
    return $BookmarksTable(attachedDatabase, alias);
  }
}

class Bookmark extends DataClass implements Insertable<Bookmark> {
  final int id;
  final String sorahName;
  final int pageNum;
  final String lastRead;
  final String? syncUuid;
  final int updatedAt;
  final bool deleted;
  const Bookmark({
    required this.id,
    required this.sorahName,
    required this.pageNum,
    required this.lastRead,
    this.syncUuid,
    required this.updatedAt,
    required this.deleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sorah_name'] = Variable<String>(sorahName);
    map['page_num'] = Variable<int>(pageNum);
    map['last_read'] = Variable<String>(lastRead);
    if (!nullToAbsent || syncUuid != null) {
      map['sync_uuid'] = Variable<String>(syncUuid);
    }
    map['updated_at'] = Variable<int>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  BookmarksCompanion toCompanion(bool nullToAbsent) {
    return BookmarksCompanion(
      id: Value(id),
      sorahName: Value(sorahName),
      pageNum: Value(pageNum),
      lastRead: Value(lastRead),
      syncUuid: syncUuid == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUuid),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
    );
  }

  factory Bookmark.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Bookmark(
      id: serializer.fromJson<int>(json['id']),
      sorahName: serializer.fromJson<String>(json['sorahName']),
      pageNum: serializer.fromJson<int>(json['pageNum']),
      lastRead: serializer.fromJson<String>(json['lastRead']),
      syncUuid: serializer.fromJson<String?>(json['syncUuid']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sorahName': serializer.toJson<String>(sorahName),
      'pageNum': serializer.toJson<int>(pageNum),
      'lastRead': serializer.toJson<String>(lastRead),
      'syncUuid': serializer.toJson<String?>(syncUuid),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  Bookmark copyWith({
    int? id,
    String? sorahName,
    int? pageNum,
    String? lastRead,
    Value<String?> syncUuid = const Value.absent(),
    int? updatedAt,
    bool? deleted,
  }) => Bookmark(
    id: id ?? this.id,
    sorahName: sorahName ?? this.sorahName,
    pageNum: pageNum ?? this.pageNum,
    lastRead: lastRead ?? this.lastRead,
    syncUuid: syncUuid.present ? syncUuid.value : this.syncUuid,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
  );
  Bookmark copyWithCompanion(BookmarksCompanion data) {
    return Bookmark(
      id: data.id.present ? data.id.value : this.id,
      sorahName: data.sorahName.present ? data.sorahName.value : this.sorahName,
      pageNum: data.pageNum.present ? data.pageNum.value : this.pageNum,
      lastRead: data.lastRead.present ? data.lastRead.value : this.lastRead,
      syncUuid: data.syncUuid.present ? data.syncUuid.value : this.syncUuid,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Bookmark(')
          ..write('id: $id, ')
          ..write('sorahName: $sorahName, ')
          ..write('pageNum: $pageNum, ')
          ..write('lastRead: $lastRead, ')
          ..write('syncUuid: $syncUuid, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sorahName,
    pageNum,
    lastRead,
    syncUuid,
    updatedAt,
    deleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bookmark &&
          other.id == this.id &&
          other.sorahName == this.sorahName &&
          other.pageNum == this.pageNum &&
          other.lastRead == this.lastRead &&
          other.syncUuid == this.syncUuid &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted);
}

class BookmarksCompanion extends UpdateCompanion<Bookmark> {
  final Value<int> id;
  final Value<String> sorahName;
  final Value<int> pageNum;
  final Value<String> lastRead;
  final Value<String?> syncUuid;
  final Value<int> updatedAt;
  final Value<bool> deleted;
  const BookmarksCompanion({
    this.id = const Value.absent(),
    this.sorahName = const Value.absent(),
    this.pageNum = const Value.absent(),
    this.lastRead = const Value.absent(),
    this.syncUuid = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
  });
  BookmarksCompanion.insert({
    this.id = const Value.absent(),
    required String sorahName,
    required int pageNum,
    required String lastRead,
    this.syncUuid = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
  }) : sorahName = Value(sorahName),
       pageNum = Value(pageNum),
       lastRead = Value(lastRead);
  static Insertable<Bookmark> custom({
    Expression<int>? id,
    Expression<String>? sorahName,
    Expression<int>? pageNum,
    Expression<String>? lastRead,
    Expression<String>? syncUuid,
    Expression<int>? updatedAt,
    Expression<bool>? deleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sorahName != null) 'sorah_name': sorahName,
      if (pageNum != null) 'page_num': pageNum,
      if (lastRead != null) 'last_read': lastRead,
      if (syncUuid != null) 'sync_uuid': syncUuid,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
    });
  }

  BookmarksCompanion copyWith({
    Value<int>? id,
    Value<String>? sorahName,
    Value<int>? pageNum,
    Value<String>? lastRead,
    Value<String?>? syncUuid,
    Value<int>? updatedAt,
    Value<bool>? deleted,
  }) {
    return BookmarksCompanion(
      id: id ?? this.id,
      sorahName: sorahName ?? this.sorahName,
      pageNum: pageNum ?? this.pageNum,
      lastRead: lastRead ?? this.lastRead,
      syncUuid: syncUuid ?? this.syncUuid,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sorahName.present) {
      map['sorah_name'] = Variable<String>(sorahName.value);
    }
    if (pageNum.present) {
      map['page_num'] = Variable<int>(pageNum.value);
    }
    if (lastRead.present) {
      map['last_read'] = Variable<String>(lastRead.value);
    }
    if (syncUuid.present) {
      map['sync_uuid'] = Variable<String>(syncUuid.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookmarksCompanion(')
          ..write('id: $id, ')
          ..write('sorahName: $sorahName, ')
          ..write('pageNum: $pageNum, ')
          ..write('lastRead: $lastRead, ')
          ..write('syncUuid: $syncUuid, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }
}

class $BookmarksAyahsTable extends BookmarksAyahs
    with TableInfo<$BookmarksAyahsTable, BookmarksAyah> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookmarksAyahsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _surahNameMeta = const VerificationMeta(
    'surahName',
  );
  @override
  late final GeneratedColumn<String> surahName = GeneratedColumn<String>(
    'surah_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _surahNumberMeta = const VerificationMeta(
    'surahNumber',
  );
  @override
  late final GeneratedColumn<int> surahNumber = GeneratedColumn<int>(
    'surah_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pageNumberMeta = const VerificationMeta(
    'pageNumber',
  );
  @override
  late final GeneratedColumn<int> pageNumber = GeneratedColumn<int>(
    'page_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ayahNumberMeta = const VerificationMeta(
    'ayahNumber',
  );
  @override
  late final GeneratedColumn<int> ayahNumber = GeneratedColumn<int>(
    'ayah_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ayahUQNumberMeta = const VerificationMeta(
    'ayahUQNumber',
  );
  @override
  late final GeneratedColumn<int> ayahUQNumber = GeneratedColumn<int>(
    'ayah_u_q_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastReadMeta = const VerificationMeta(
    'lastRead',
  );
  @override
  late final GeneratedColumn<String> lastRead = GeneratedColumn<String>(
    'last_read',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncUuidMeta = const VerificationMeta(
    'syncUuid',
  );
  @override
  late final GeneratedColumn<String> syncUuid = GeneratedColumn<String>(
    'sync_uuid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    surahName,
    surahNumber,
    pageNumber,
    ayahNumber,
    ayahUQNumber,
    lastRead,
    syncUuid,
    updatedAt,
    deleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bookmarks_ayahs';
  @override
  VerificationContext validateIntegrity(
    Insertable<BookmarksAyah> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('surah_name')) {
      context.handle(
        _surahNameMeta,
        surahName.isAcceptableOrUnknown(data['surah_name']!, _surahNameMeta),
      );
    } else if (isInserting) {
      context.missing(_surahNameMeta);
    }
    if (data.containsKey('surah_number')) {
      context.handle(
        _surahNumberMeta,
        surahNumber.isAcceptableOrUnknown(
          data['surah_number']!,
          _surahNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_surahNumberMeta);
    }
    if (data.containsKey('page_number')) {
      context.handle(
        _pageNumberMeta,
        pageNumber.isAcceptableOrUnknown(data['page_number']!, _pageNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_pageNumberMeta);
    }
    if (data.containsKey('ayah_number')) {
      context.handle(
        _ayahNumberMeta,
        ayahNumber.isAcceptableOrUnknown(data['ayah_number']!, _ayahNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_ayahNumberMeta);
    }
    if (data.containsKey('ayah_u_q_number')) {
      context.handle(
        _ayahUQNumberMeta,
        ayahUQNumber.isAcceptableOrUnknown(
          data['ayah_u_q_number']!,
          _ayahUQNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ayahUQNumberMeta);
    }
    if (data.containsKey('last_read')) {
      context.handle(
        _lastReadMeta,
        lastRead.isAcceptableOrUnknown(data['last_read']!, _lastReadMeta),
      );
    } else if (isInserting) {
      context.missing(_lastReadMeta);
    }
    if (data.containsKey('sync_uuid')) {
      context.handle(
        _syncUuidMeta,
        syncUuid.isAcceptableOrUnknown(data['sync_uuid']!, _syncUuidMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BookmarksAyah map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BookmarksAyah(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      surahName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}surah_name'],
      )!,
      surahNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}surah_number'],
      )!,
      pageNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_number'],
      )!,
      ayahNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ayah_number'],
      )!,
      ayahUQNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ayah_u_q_number'],
      )!,
      lastRead: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_read'],
      )!,
      syncUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_uuid'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
    );
  }

  @override
  $BookmarksAyahsTable createAlias(String alias) {
    return $BookmarksAyahsTable(attachedDatabase, alias);
  }
}

class BookmarksAyah extends DataClass implements Insertable<BookmarksAyah> {
  final int id;
  final String surahName;
  final int surahNumber;
  final int pageNumber;
  final int ayahNumber;
  final int ayahUQNumber;
  final String lastRead;
  final String? syncUuid;
  final int updatedAt;
  final bool deleted;
  const BookmarksAyah({
    required this.id,
    required this.surahName,
    required this.surahNumber,
    required this.pageNumber,
    required this.ayahNumber,
    required this.ayahUQNumber,
    required this.lastRead,
    this.syncUuid,
    required this.updatedAt,
    required this.deleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['surah_name'] = Variable<String>(surahName);
    map['surah_number'] = Variable<int>(surahNumber);
    map['page_number'] = Variable<int>(pageNumber);
    map['ayah_number'] = Variable<int>(ayahNumber);
    map['ayah_u_q_number'] = Variable<int>(ayahUQNumber);
    map['last_read'] = Variable<String>(lastRead);
    if (!nullToAbsent || syncUuid != null) {
      map['sync_uuid'] = Variable<String>(syncUuid);
    }
    map['updated_at'] = Variable<int>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  BookmarksAyahsCompanion toCompanion(bool nullToAbsent) {
    return BookmarksAyahsCompanion(
      id: Value(id),
      surahName: Value(surahName),
      surahNumber: Value(surahNumber),
      pageNumber: Value(pageNumber),
      ayahNumber: Value(ayahNumber),
      ayahUQNumber: Value(ayahUQNumber),
      lastRead: Value(lastRead),
      syncUuid: syncUuid == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUuid),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
    );
  }

  factory BookmarksAyah.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookmarksAyah(
      id: serializer.fromJson<int>(json['id']),
      surahName: serializer.fromJson<String>(json['surahName']),
      surahNumber: serializer.fromJson<int>(json['surahNumber']),
      pageNumber: serializer.fromJson<int>(json['pageNumber']),
      ayahNumber: serializer.fromJson<int>(json['ayahNumber']),
      ayahUQNumber: serializer.fromJson<int>(json['ayahUQNumber']),
      lastRead: serializer.fromJson<String>(json['lastRead']),
      syncUuid: serializer.fromJson<String?>(json['syncUuid']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'surahName': serializer.toJson<String>(surahName),
      'surahNumber': serializer.toJson<int>(surahNumber),
      'pageNumber': serializer.toJson<int>(pageNumber),
      'ayahNumber': serializer.toJson<int>(ayahNumber),
      'ayahUQNumber': serializer.toJson<int>(ayahUQNumber),
      'lastRead': serializer.toJson<String>(lastRead),
      'syncUuid': serializer.toJson<String?>(syncUuid),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  BookmarksAyah copyWith({
    int? id,
    String? surahName,
    int? surahNumber,
    int? pageNumber,
    int? ayahNumber,
    int? ayahUQNumber,
    String? lastRead,
    Value<String?> syncUuid = const Value.absent(),
    int? updatedAt,
    bool? deleted,
  }) => BookmarksAyah(
    id: id ?? this.id,
    surahName: surahName ?? this.surahName,
    surahNumber: surahNumber ?? this.surahNumber,
    pageNumber: pageNumber ?? this.pageNumber,
    ayahNumber: ayahNumber ?? this.ayahNumber,
    ayahUQNumber: ayahUQNumber ?? this.ayahUQNumber,
    lastRead: lastRead ?? this.lastRead,
    syncUuid: syncUuid.present ? syncUuid.value : this.syncUuid,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
  );
  BookmarksAyah copyWithCompanion(BookmarksAyahsCompanion data) {
    return BookmarksAyah(
      id: data.id.present ? data.id.value : this.id,
      surahName: data.surahName.present ? data.surahName.value : this.surahName,
      surahNumber: data.surahNumber.present
          ? data.surahNumber.value
          : this.surahNumber,
      pageNumber: data.pageNumber.present
          ? data.pageNumber.value
          : this.pageNumber,
      ayahNumber: data.ayahNumber.present
          ? data.ayahNumber.value
          : this.ayahNumber,
      ayahUQNumber: data.ayahUQNumber.present
          ? data.ayahUQNumber.value
          : this.ayahUQNumber,
      lastRead: data.lastRead.present ? data.lastRead.value : this.lastRead,
      syncUuid: data.syncUuid.present ? data.syncUuid.value : this.syncUuid,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookmarksAyah(')
          ..write('id: $id, ')
          ..write('surahName: $surahName, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('ayahUQNumber: $ayahUQNumber, ')
          ..write('lastRead: $lastRead, ')
          ..write('syncUuid: $syncUuid, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    surahName,
    surahNumber,
    pageNumber,
    ayahNumber,
    ayahUQNumber,
    lastRead,
    syncUuid,
    updatedAt,
    deleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookmarksAyah &&
          other.id == this.id &&
          other.surahName == this.surahName &&
          other.surahNumber == this.surahNumber &&
          other.pageNumber == this.pageNumber &&
          other.ayahNumber == this.ayahNumber &&
          other.ayahUQNumber == this.ayahUQNumber &&
          other.lastRead == this.lastRead &&
          other.syncUuid == this.syncUuid &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted);
}

class BookmarksAyahsCompanion extends UpdateCompanion<BookmarksAyah> {
  final Value<int> id;
  final Value<String> surahName;
  final Value<int> surahNumber;
  final Value<int> pageNumber;
  final Value<int> ayahNumber;
  final Value<int> ayahUQNumber;
  final Value<String> lastRead;
  final Value<String?> syncUuid;
  final Value<int> updatedAt;
  final Value<bool> deleted;
  const BookmarksAyahsCompanion({
    this.id = const Value.absent(),
    this.surahName = const Value.absent(),
    this.surahNumber = const Value.absent(),
    this.pageNumber = const Value.absent(),
    this.ayahNumber = const Value.absent(),
    this.ayahUQNumber = const Value.absent(),
    this.lastRead = const Value.absent(),
    this.syncUuid = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
  });
  BookmarksAyahsCompanion.insert({
    this.id = const Value.absent(),
    required String surahName,
    required int surahNumber,
    required int pageNumber,
    required int ayahNumber,
    required int ayahUQNumber,
    required String lastRead,
    this.syncUuid = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
  }) : surahName = Value(surahName),
       surahNumber = Value(surahNumber),
       pageNumber = Value(pageNumber),
       ayahNumber = Value(ayahNumber),
       ayahUQNumber = Value(ayahUQNumber),
       lastRead = Value(lastRead);
  static Insertable<BookmarksAyah> custom({
    Expression<int>? id,
    Expression<String>? surahName,
    Expression<int>? surahNumber,
    Expression<int>? pageNumber,
    Expression<int>? ayahNumber,
    Expression<int>? ayahUQNumber,
    Expression<String>? lastRead,
    Expression<String>? syncUuid,
    Expression<int>? updatedAt,
    Expression<bool>? deleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (surahName != null) 'surah_name': surahName,
      if (surahNumber != null) 'surah_number': surahNumber,
      if (pageNumber != null) 'page_number': pageNumber,
      if (ayahNumber != null) 'ayah_number': ayahNumber,
      if (ayahUQNumber != null) 'ayah_u_q_number': ayahUQNumber,
      if (lastRead != null) 'last_read': lastRead,
      if (syncUuid != null) 'sync_uuid': syncUuid,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
    });
  }

  BookmarksAyahsCompanion copyWith({
    Value<int>? id,
    Value<String>? surahName,
    Value<int>? surahNumber,
    Value<int>? pageNumber,
    Value<int>? ayahNumber,
    Value<int>? ayahUQNumber,
    Value<String>? lastRead,
    Value<String?>? syncUuid,
    Value<int>? updatedAt,
    Value<bool>? deleted,
  }) {
    return BookmarksAyahsCompanion(
      id: id ?? this.id,
      surahName: surahName ?? this.surahName,
      surahNumber: surahNumber ?? this.surahNumber,
      pageNumber: pageNumber ?? this.pageNumber,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      ayahUQNumber: ayahUQNumber ?? this.ayahUQNumber,
      lastRead: lastRead ?? this.lastRead,
      syncUuid: syncUuid ?? this.syncUuid,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (surahName.present) {
      map['surah_name'] = Variable<String>(surahName.value);
    }
    if (surahNumber.present) {
      map['surah_number'] = Variable<int>(surahNumber.value);
    }
    if (pageNumber.present) {
      map['page_number'] = Variable<int>(pageNumber.value);
    }
    if (ayahNumber.present) {
      map['ayah_number'] = Variable<int>(ayahNumber.value);
    }
    if (ayahUQNumber.present) {
      map['ayah_u_q_number'] = Variable<int>(ayahUQNumber.value);
    }
    if (lastRead.present) {
      map['last_read'] = Variable<String>(lastRead.value);
    }
    if (syncUuid.present) {
      map['sync_uuid'] = Variable<String>(syncUuid.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookmarksAyahsCompanion(')
          ..write('id: $id, ')
          ..write('surahName: $surahName, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('ayahUQNumber: $ayahUQNumber, ')
          ..write('lastRead: $lastRead, ')
          ..write('syncUuid: $syncUuid, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }
}

class $AdhkarTable extends Adhkar with TableInfo<$AdhkarTable, AdhkarData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AdhkarTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<String> count = GeneratedColumn<String>(
    'count',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referenceMeta = const VerificationMeta(
    'reference',
  );
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
    'reference',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _zekrMeta = const VerificationMeta('zekr');
  @override
  late final GeneratedColumn<String> zekr = GeneratedColumn<String>(
    'zekr',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncUuidMeta = const VerificationMeta(
    'syncUuid',
  );
  @override
  late final GeneratedColumn<String> syncUuid = GeneratedColumn<String>(
    'sync_uuid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    category,
    count,
    description,
    reference,
    zekr,
    syncUuid,
    updatedAt,
    deleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'adhkar';
  @override
  VerificationContext validateIntegrity(
    Insertable<AdhkarData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
        _countMeta,
        count.isAcceptableOrUnknown(data['count']!, _countMeta),
      );
    } else if (isInserting) {
      context.missing(_countMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('reference')) {
      context.handle(
        _referenceMeta,
        reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta),
      );
    } else if (isInserting) {
      context.missing(_referenceMeta);
    }
    if (data.containsKey('zekr')) {
      context.handle(
        _zekrMeta,
        zekr.isAcceptableOrUnknown(data['zekr']!, _zekrMeta),
      );
    } else if (isInserting) {
      context.missing(_zekrMeta);
    }
    if (data.containsKey('sync_uuid')) {
      context.handle(
        _syncUuidMeta,
        syncUuid.isAcceptableOrUnknown(data['sync_uuid']!, _syncUuidMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AdhkarData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AdhkarData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      count: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}count'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      reference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference'],
      )!,
      zekr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}zekr'],
      )!,
      syncUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_uuid'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
    );
  }

  @override
  $AdhkarTable createAlias(String alias) {
    return $AdhkarTable(attachedDatabase, alias);
  }
}

class AdhkarData extends DataClass implements Insertable<AdhkarData> {
  final int id;
  final String category;
  final String count;
  final String description;
  final String reference;
  final String zekr;
  final String? syncUuid;
  final int updatedAt;
  final bool deleted;
  const AdhkarData({
    required this.id,
    required this.category,
    required this.count,
    required this.description,
    required this.reference,
    required this.zekr,
    this.syncUuid,
    required this.updatedAt,
    required this.deleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category'] = Variable<String>(category);
    map['count'] = Variable<String>(count);
    map['description'] = Variable<String>(description);
    map['reference'] = Variable<String>(reference);
    map['zekr'] = Variable<String>(zekr);
    if (!nullToAbsent || syncUuid != null) {
      map['sync_uuid'] = Variable<String>(syncUuid);
    }
    map['updated_at'] = Variable<int>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  AdhkarCompanion toCompanion(bool nullToAbsent) {
    return AdhkarCompanion(
      id: Value(id),
      category: Value(category),
      count: Value(count),
      description: Value(description),
      reference: Value(reference),
      zekr: Value(zekr),
      syncUuid: syncUuid == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUuid),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
    );
  }

  factory AdhkarData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AdhkarData(
      id: serializer.fromJson<int>(json['id']),
      category: serializer.fromJson<String>(json['category']),
      count: serializer.fromJson<String>(json['count']),
      description: serializer.fromJson<String>(json['description']),
      reference: serializer.fromJson<String>(json['reference']),
      zekr: serializer.fromJson<String>(json['zekr']),
      syncUuid: serializer.fromJson<String?>(json['syncUuid']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'category': serializer.toJson<String>(category),
      'count': serializer.toJson<String>(count),
      'description': serializer.toJson<String>(description),
      'reference': serializer.toJson<String>(reference),
      'zekr': serializer.toJson<String>(zekr),
      'syncUuid': serializer.toJson<String?>(syncUuid),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  AdhkarData copyWith({
    int? id,
    String? category,
    String? count,
    String? description,
    String? reference,
    String? zekr,
    Value<String?> syncUuid = const Value.absent(),
    int? updatedAt,
    bool? deleted,
  }) => AdhkarData(
    id: id ?? this.id,
    category: category ?? this.category,
    count: count ?? this.count,
    description: description ?? this.description,
    reference: reference ?? this.reference,
    zekr: zekr ?? this.zekr,
    syncUuid: syncUuid.present ? syncUuid.value : this.syncUuid,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
  );
  AdhkarData copyWithCompanion(AdhkarCompanion data) {
    return AdhkarData(
      id: data.id.present ? data.id.value : this.id,
      category: data.category.present ? data.category.value : this.category,
      count: data.count.present ? data.count.value : this.count,
      description: data.description.present
          ? data.description.value
          : this.description,
      reference: data.reference.present ? data.reference.value : this.reference,
      zekr: data.zekr.present ? data.zekr.value : this.zekr,
      syncUuid: data.syncUuid.present ? data.syncUuid.value : this.syncUuid,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AdhkarData(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('count: $count, ')
          ..write('description: $description, ')
          ..write('reference: $reference, ')
          ..write('zekr: $zekr, ')
          ..write('syncUuid: $syncUuid, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    category,
    count,
    description,
    reference,
    zekr,
    syncUuid,
    updatedAt,
    deleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AdhkarData &&
          other.id == this.id &&
          other.category == this.category &&
          other.count == this.count &&
          other.description == this.description &&
          other.reference == this.reference &&
          other.zekr == this.zekr &&
          other.syncUuid == this.syncUuid &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted);
}

class AdhkarCompanion extends UpdateCompanion<AdhkarData> {
  final Value<int> id;
  final Value<String> category;
  final Value<String> count;
  final Value<String> description;
  final Value<String> reference;
  final Value<String> zekr;
  final Value<String?> syncUuid;
  final Value<int> updatedAt;
  final Value<bool> deleted;
  const AdhkarCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.count = const Value.absent(),
    this.description = const Value.absent(),
    this.reference = const Value.absent(),
    this.zekr = const Value.absent(),
    this.syncUuid = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
  });
  AdhkarCompanion.insert({
    this.id = const Value.absent(),
    required String category,
    required String count,
    required String description,
    required String reference,
    required String zekr,
    this.syncUuid = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
  }) : category = Value(category),
       count = Value(count),
       description = Value(description),
       reference = Value(reference),
       zekr = Value(zekr);
  static Insertable<AdhkarData> custom({
    Expression<int>? id,
    Expression<String>? category,
    Expression<String>? count,
    Expression<String>? description,
    Expression<String>? reference,
    Expression<String>? zekr,
    Expression<String>? syncUuid,
    Expression<int>? updatedAt,
    Expression<bool>? deleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (count != null) 'count': count,
      if (description != null) 'description': description,
      if (reference != null) 'reference': reference,
      if (zekr != null) 'zekr': zekr,
      if (syncUuid != null) 'sync_uuid': syncUuid,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
    });
  }

  AdhkarCompanion copyWith({
    Value<int>? id,
    Value<String>? category,
    Value<String>? count,
    Value<String>? description,
    Value<String>? reference,
    Value<String>? zekr,
    Value<String?>? syncUuid,
    Value<int>? updatedAt,
    Value<bool>? deleted,
  }) {
    return AdhkarCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      count: count ?? this.count,
      description: description ?? this.description,
      reference: reference ?? this.reference,
      zekr: zekr ?? this.zekr,
      syncUuid: syncUuid ?? this.syncUuid,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (count.present) {
      map['count'] = Variable<String>(count.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (zekr.present) {
      map['zekr'] = Variable<String>(zekr.value);
    }
    if (syncUuid.present) {
      map['sync_uuid'] = Variable<String>(syncUuid.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AdhkarCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('count: $count, ')
          ..write('description: $description, ')
          ..write('reference: $reference, ')
          ..write('zekr: $zekr, ')
          ..write('syncUuid: $syncUuid, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }
}

abstract class _$BookmarkDatabase extends GeneratedDatabase {
  _$BookmarkDatabase(QueryExecutor e) : super(e);
  $BookmarkDatabaseManager get managers => $BookmarkDatabaseManager(this);
  late final $BookmarksTable bookmarks = $BookmarksTable(this);
  late final $BookmarksAyahsTable bookmarksAyahs = $BookmarksAyahsTable(this);
  late final $AdhkarTable adhkar = $AdhkarTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    bookmarks,
    bookmarksAyahs,
    adhkar,
  ];
}

typedef $$BookmarksTableCreateCompanionBuilder =
    BookmarksCompanion Function({
      Value<int> id,
      required String sorahName,
      required int pageNum,
      required String lastRead,
      Value<String?> syncUuid,
      Value<int> updatedAt,
      Value<bool> deleted,
    });
typedef $$BookmarksTableUpdateCompanionBuilder =
    BookmarksCompanion Function({
      Value<int> id,
      Value<String> sorahName,
      Value<int> pageNum,
      Value<String> lastRead,
      Value<String?> syncUuid,
      Value<int> updatedAt,
      Value<bool> deleted,
    });

class $$BookmarksTableFilterComposer
    extends Composer<_$BookmarkDatabase, $BookmarksTable> {
  $$BookmarksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sorahName => $composableBuilder(
    column: $table.sorahName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pageNum => $composableBuilder(
    column: $table.pageNum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastRead => $composableBuilder(
    column: $table.lastRead,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncUuid => $composableBuilder(
    column: $table.syncUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BookmarksTableOrderingComposer
    extends Composer<_$BookmarkDatabase, $BookmarksTable> {
  $$BookmarksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sorahName => $composableBuilder(
    column: $table.sorahName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pageNum => $composableBuilder(
    column: $table.pageNum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastRead => $composableBuilder(
    column: $table.lastRead,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncUuid => $composableBuilder(
    column: $table.syncUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BookmarksTableAnnotationComposer
    extends Composer<_$BookmarkDatabase, $BookmarksTable> {
  $$BookmarksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sorahName =>
      $composableBuilder(column: $table.sorahName, builder: (column) => column);

  GeneratedColumn<int> get pageNum =>
      $composableBuilder(column: $table.pageNum, builder: (column) => column);

  GeneratedColumn<String> get lastRead =>
      $composableBuilder(column: $table.lastRead, builder: (column) => column);

  GeneratedColumn<String> get syncUuid =>
      $composableBuilder(column: $table.syncUuid, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);
}

class $$BookmarksTableTableManager
    extends
        RootTableManager<
          _$BookmarkDatabase,
          $BookmarksTable,
          Bookmark,
          $$BookmarksTableFilterComposer,
          $$BookmarksTableOrderingComposer,
          $$BookmarksTableAnnotationComposer,
          $$BookmarksTableCreateCompanionBuilder,
          $$BookmarksTableUpdateCompanionBuilder,
          (
            Bookmark,
            BaseReferences<_$BookmarkDatabase, $BookmarksTable, Bookmark>,
          ),
          Bookmark,
          PrefetchHooks Function()
        > {
  $$BookmarksTableTableManager(_$BookmarkDatabase db, $BookmarksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookmarksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookmarksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookmarksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> sorahName = const Value.absent(),
                Value<int> pageNum = const Value.absent(),
                Value<String> lastRead = const Value.absent(),
                Value<String?> syncUuid = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
              }) => BookmarksCompanion(
                id: id,
                sorahName: sorahName,
                pageNum: pageNum,
                lastRead: lastRead,
                syncUuid: syncUuid,
                updatedAt: updatedAt,
                deleted: deleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String sorahName,
                required int pageNum,
                required String lastRead,
                Value<String?> syncUuid = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
              }) => BookmarksCompanion.insert(
                id: id,
                sorahName: sorahName,
                pageNum: pageNum,
                lastRead: lastRead,
                syncUuid: syncUuid,
                updatedAt: updatedAt,
                deleted: deleted,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BookmarksTableProcessedTableManager =
    ProcessedTableManager<
      _$BookmarkDatabase,
      $BookmarksTable,
      Bookmark,
      $$BookmarksTableFilterComposer,
      $$BookmarksTableOrderingComposer,
      $$BookmarksTableAnnotationComposer,
      $$BookmarksTableCreateCompanionBuilder,
      $$BookmarksTableUpdateCompanionBuilder,
      (Bookmark, BaseReferences<_$BookmarkDatabase, $BookmarksTable, Bookmark>),
      Bookmark,
      PrefetchHooks Function()
    >;
typedef $$BookmarksAyahsTableCreateCompanionBuilder =
    BookmarksAyahsCompanion Function({
      Value<int> id,
      required String surahName,
      required int surahNumber,
      required int pageNumber,
      required int ayahNumber,
      required int ayahUQNumber,
      required String lastRead,
      Value<String?> syncUuid,
      Value<int> updatedAt,
      Value<bool> deleted,
    });
typedef $$BookmarksAyahsTableUpdateCompanionBuilder =
    BookmarksAyahsCompanion Function({
      Value<int> id,
      Value<String> surahName,
      Value<int> surahNumber,
      Value<int> pageNumber,
      Value<int> ayahNumber,
      Value<int> ayahUQNumber,
      Value<String> lastRead,
      Value<String?> syncUuid,
      Value<int> updatedAt,
      Value<bool> deleted,
    });

class $$BookmarksAyahsTableFilterComposer
    extends Composer<_$BookmarkDatabase, $BookmarksAyahsTable> {
  $$BookmarksAyahsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get surahName => $composableBuilder(
    column: $table.surahName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ayahUQNumber => $composableBuilder(
    column: $table.ayahUQNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastRead => $composableBuilder(
    column: $table.lastRead,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncUuid => $composableBuilder(
    column: $table.syncUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BookmarksAyahsTableOrderingComposer
    extends Composer<_$BookmarkDatabase, $BookmarksAyahsTable> {
  $$BookmarksAyahsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get surahName => $composableBuilder(
    column: $table.surahName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ayahUQNumber => $composableBuilder(
    column: $table.ayahUQNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastRead => $composableBuilder(
    column: $table.lastRead,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncUuid => $composableBuilder(
    column: $table.syncUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BookmarksAyahsTableAnnotationComposer
    extends Composer<_$BookmarkDatabase, $BookmarksAyahsTable> {
  $$BookmarksAyahsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get surahName =>
      $composableBuilder(column: $table.surahName, builder: (column) => column);

  GeneratedColumn<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ayahUQNumber => $composableBuilder(
    column: $table.ayahUQNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastRead =>
      $composableBuilder(column: $table.lastRead, builder: (column) => column);

  GeneratedColumn<String> get syncUuid =>
      $composableBuilder(column: $table.syncUuid, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);
}

class $$BookmarksAyahsTableTableManager
    extends
        RootTableManager<
          _$BookmarkDatabase,
          $BookmarksAyahsTable,
          BookmarksAyah,
          $$BookmarksAyahsTableFilterComposer,
          $$BookmarksAyahsTableOrderingComposer,
          $$BookmarksAyahsTableAnnotationComposer,
          $$BookmarksAyahsTableCreateCompanionBuilder,
          $$BookmarksAyahsTableUpdateCompanionBuilder,
          (
            BookmarksAyah,
            BaseReferences<
              _$BookmarkDatabase,
              $BookmarksAyahsTable,
              BookmarksAyah
            >,
          ),
          BookmarksAyah,
          PrefetchHooks Function()
        > {
  $$BookmarksAyahsTableTableManager(
    _$BookmarkDatabase db,
    $BookmarksAyahsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookmarksAyahsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookmarksAyahsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookmarksAyahsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> surahName = const Value.absent(),
                Value<int> surahNumber = const Value.absent(),
                Value<int> pageNumber = const Value.absent(),
                Value<int> ayahNumber = const Value.absent(),
                Value<int> ayahUQNumber = const Value.absent(),
                Value<String> lastRead = const Value.absent(),
                Value<String?> syncUuid = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
              }) => BookmarksAyahsCompanion(
                id: id,
                surahName: surahName,
                surahNumber: surahNumber,
                pageNumber: pageNumber,
                ayahNumber: ayahNumber,
                ayahUQNumber: ayahUQNumber,
                lastRead: lastRead,
                syncUuid: syncUuid,
                updatedAt: updatedAt,
                deleted: deleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String surahName,
                required int surahNumber,
                required int pageNumber,
                required int ayahNumber,
                required int ayahUQNumber,
                required String lastRead,
                Value<String?> syncUuid = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
              }) => BookmarksAyahsCompanion.insert(
                id: id,
                surahName: surahName,
                surahNumber: surahNumber,
                pageNumber: pageNumber,
                ayahNumber: ayahNumber,
                ayahUQNumber: ayahUQNumber,
                lastRead: lastRead,
                syncUuid: syncUuid,
                updatedAt: updatedAt,
                deleted: deleted,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BookmarksAyahsTableProcessedTableManager =
    ProcessedTableManager<
      _$BookmarkDatabase,
      $BookmarksAyahsTable,
      BookmarksAyah,
      $$BookmarksAyahsTableFilterComposer,
      $$BookmarksAyahsTableOrderingComposer,
      $$BookmarksAyahsTableAnnotationComposer,
      $$BookmarksAyahsTableCreateCompanionBuilder,
      $$BookmarksAyahsTableUpdateCompanionBuilder,
      (
        BookmarksAyah,
        BaseReferences<_$BookmarkDatabase, $BookmarksAyahsTable, BookmarksAyah>,
      ),
      BookmarksAyah,
      PrefetchHooks Function()
    >;
typedef $$AdhkarTableCreateCompanionBuilder =
    AdhkarCompanion Function({
      Value<int> id,
      required String category,
      required String count,
      required String description,
      required String reference,
      required String zekr,
      Value<String?> syncUuid,
      Value<int> updatedAt,
      Value<bool> deleted,
    });
typedef $$AdhkarTableUpdateCompanionBuilder =
    AdhkarCompanion Function({
      Value<int> id,
      Value<String> category,
      Value<String> count,
      Value<String> description,
      Value<String> reference,
      Value<String> zekr,
      Value<String?> syncUuid,
      Value<int> updatedAt,
      Value<bool> deleted,
    });

class $$AdhkarTableFilterComposer
    extends Composer<_$BookmarkDatabase, $AdhkarTable> {
  $$AdhkarTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get zekr => $composableBuilder(
    column: $table.zekr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncUuid => $composableBuilder(
    column: $table.syncUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AdhkarTableOrderingComposer
    extends Composer<_$BookmarkDatabase, $AdhkarTable> {
  $$AdhkarTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get zekr => $composableBuilder(
    column: $table.zekr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncUuid => $composableBuilder(
    column: $table.syncUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AdhkarTableAnnotationComposer
    extends Composer<_$BookmarkDatabase, $AdhkarTable> {
  $$AdhkarTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<String> get zekr =>
      $composableBuilder(column: $table.zekr, builder: (column) => column);

  GeneratedColumn<String> get syncUuid =>
      $composableBuilder(column: $table.syncUuid, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);
}

class $$AdhkarTableTableManager
    extends
        RootTableManager<
          _$BookmarkDatabase,
          $AdhkarTable,
          AdhkarData,
          $$AdhkarTableFilterComposer,
          $$AdhkarTableOrderingComposer,
          $$AdhkarTableAnnotationComposer,
          $$AdhkarTableCreateCompanionBuilder,
          $$AdhkarTableUpdateCompanionBuilder,
          (
            AdhkarData,
            BaseReferences<_$BookmarkDatabase, $AdhkarTable, AdhkarData>,
          ),
          AdhkarData,
          PrefetchHooks Function()
        > {
  $$AdhkarTableTableManager(_$BookmarkDatabase db, $AdhkarTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AdhkarTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AdhkarTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AdhkarTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> count = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> reference = const Value.absent(),
                Value<String> zekr = const Value.absent(),
                Value<String?> syncUuid = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
              }) => AdhkarCompanion(
                id: id,
                category: category,
                count: count,
                description: description,
                reference: reference,
                zekr: zekr,
                syncUuid: syncUuid,
                updatedAt: updatedAt,
                deleted: deleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String category,
                required String count,
                required String description,
                required String reference,
                required String zekr,
                Value<String?> syncUuid = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
              }) => AdhkarCompanion.insert(
                id: id,
                category: category,
                count: count,
                description: description,
                reference: reference,
                zekr: zekr,
                syncUuid: syncUuid,
                updatedAt: updatedAt,
                deleted: deleted,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AdhkarTableProcessedTableManager =
    ProcessedTableManager<
      _$BookmarkDatabase,
      $AdhkarTable,
      AdhkarData,
      $$AdhkarTableFilterComposer,
      $$AdhkarTableOrderingComposer,
      $$AdhkarTableAnnotationComposer,
      $$AdhkarTableCreateCompanionBuilder,
      $$AdhkarTableUpdateCompanionBuilder,
      (
        AdhkarData,
        BaseReferences<_$BookmarkDatabase, $AdhkarTable, AdhkarData>,
      ),
      AdhkarData,
      PrefetchHooks Function()
    >;

class $BookmarkDatabaseManager {
  final _$BookmarkDatabase _db;
  $BookmarkDatabaseManager(this._db);
  $$BookmarksTableTableManager get bookmarks =>
      $$BookmarksTableTableManager(_db, _db.bookmarks);
  $$BookmarksAyahsTableTableManager get bookmarksAyahs =>
      $$BookmarksAyahsTableTableManager(_db, _db.bookmarksAyahs);
  $$AdhkarTableTableManager get adhkar =>
      $$AdhkarTableTableManager(_db, _db.adhkar);
}

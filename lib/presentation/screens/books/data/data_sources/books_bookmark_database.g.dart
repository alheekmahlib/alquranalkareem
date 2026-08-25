// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'books_bookmark_database.dart';

// ignore_for_file: type=lint
class $BooksBookmarkTable extends BooksBookmark
    with TableInfo<$BooksBookmarkTable, BooksBookmarkData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BooksBookmarkTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _bookNameMeta = const VerificationMeta(
    'bookName',
  );
  @override
  late final GeneratedColumn<String> bookName = GeneratedColumn<String>(
    'book_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bookNumberMeta = const VerificationMeta(
    'bookNumber',
  );
  @override
  late final GeneratedColumn<int> bookNumber = GeneratedColumn<int>(
    'book_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentPageMeta = const VerificationMeta(
    'currentPage',
  );
  @override
  late final GeneratedColumn<int> currentPage = GeneratedColumn<int>(
    'current_page',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
    bookName,
    bookNumber,
    currentPage,
    syncUuid,
    updatedAt,
    deleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'books_bookmark';
  @override
  VerificationContext validateIntegrity(
    Insertable<BooksBookmarkData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('book_name')) {
      context.handle(
        _bookNameMeta,
        bookName.isAcceptableOrUnknown(data['book_name']!, _bookNameMeta),
      );
    }
    if (data.containsKey('book_number')) {
      context.handle(
        _bookNumberMeta,
        bookNumber.isAcceptableOrUnknown(data['book_number']!, _bookNumberMeta),
      );
    }
    if (data.containsKey('current_page')) {
      context.handle(
        _currentPageMeta,
        currentPage.isAcceptableOrUnknown(
          data['current_page']!,
          _currentPageMeta,
        ),
      );
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
  BooksBookmarkData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BooksBookmarkData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      bookName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book_name'],
      ),
      bookNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}book_number'],
      ),
      currentPage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_page'],
      ),
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
  $BooksBookmarkTable createAlias(String alias) {
    return $BooksBookmarkTable(attachedDatabase, alias);
  }
}

class BooksBookmarkData extends DataClass
    implements Insertable<BooksBookmarkData> {
  final int id;
  final String? bookName;
  final int? bookNumber;
  final int? currentPage;
  final String? syncUuid;
  final int updatedAt;
  final bool deleted;
  const BooksBookmarkData({
    required this.id,
    this.bookName,
    this.bookNumber,
    this.currentPage,
    this.syncUuid,
    required this.updatedAt,
    required this.deleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || bookName != null) {
      map['book_name'] = Variable<String>(bookName);
    }
    if (!nullToAbsent || bookNumber != null) {
      map['book_number'] = Variable<int>(bookNumber);
    }
    if (!nullToAbsent || currentPage != null) {
      map['current_page'] = Variable<int>(currentPage);
    }
    if (!nullToAbsent || syncUuid != null) {
      map['sync_uuid'] = Variable<String>(syncUuid);
    }
    map['updated_at'] = Variable<int>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  BooksBookmarkCompanion toCompanion(bool nullToAbsent) {
    return BooksBookmarkCompanion(
      id: Value(id),
      bookName: bookName == null && nullToAbsent
          ? const Value.absent()
          : Value(bookName),
      bookNumber: bookNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(bookNumber),
      currentPage: currentPage == null && nullToAbsent
          ? const Value.absent()
          : Value(currentPage),
      syncUuid: syncUuid == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUuid),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
    );
  }

  factory BooksBookmarkData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BooksBookmarkData(
      id: serializer.fromJson<int>(json['id']),
      bookName: serializer.fromJson<String?>(json['bookName']),
      bookNumber: serializer.fromJson<int?>(json['bookNumber']),
      currentPage: serializer.fromJson<int?>(json['currentPage']),
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
      'bookName': serializer.toJson<String?>(bookName),
      'bookNumber': serializer.toJson<int?>(bookNumber),
      'currentPage': serializer.toJson<int?>(currentPage),
      'syncUuid': serializer.toJson<String?>(syncUuid),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  BooksBookmarkData copyWith({
    int? id,
    Value<String?> bookName = const Value.absent(),
    Value<int?> bookNumber = const Value.absent(),
    Value<int?> currentPage = const Value.absent(),
    Value<String?> syncUuid = const Value.absent(),
    int? updatedAt,
    bool? deleted,
  }) => BooksBookmarkData(
    id: id ?? this.id,
    bookName: bookName.present ? bookName.value : this.bookName,
    bookNumber: bookNumber.present ? bookNumber.value : this.bookNumber,
    currentPage: currentPage.present ? currentPage.value : this.currentPage,
    syncUuid: syncUuid.present ? syncUuid.value : this.syncUuid,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
  );
  BooksBookmarkData copyWithCompanion(BooksBookmarkCompanion data) {
    return BooksBookmarkData(
      id: data.id.present ? data.id.value : this.id,
      bookName: data.bookName.present ? data.bookName.value : this.bookName,
      bookNumber: data.bookNumber.present
          ? data.bookNumber.value
          : this.bookNumber,
      currentPage: data.currentPage.present
          ? data.currentPage.value
          : this.currentPage,
      syncUuid: data.syncUuid.present ? data.syncUuid.value : this.syncUuid,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BooksBookmarkData(')
          ..write('id: $id, ')
          ..write('bookName: $bookName, ')
          ..write('bookNumber: $bookNumber, ')
          ..write('currentPage: $currentPage, ')
          ..write('syncUuid: $syncUuid, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    bookName,
    bookNumber,
    currentPage,
    syncUuid,
    updatedAt,
    deleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BooksBookmarkData &&
          other.id == this.id &&
          other.bookName == this.bookName &&
          other.bookNumber == this.bookNumber &&
          other.currentPage == this.currentPage &&
          other.syncUuid == this.syncUuid &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted);
}

class BooksBookmarkCompanion extends UpdateCompanion<BooksBookmarkData> {
  final Value<int> id;
  final Value<String?> bookName;
  final Value<int?> bookNumber;
  final Value<int?> currentPage;
  final Value<String?> syncUuid;
  final Value<int> updatedAt;
  final Value<bool> deleted;
  const BooksBookmarkCompanion({
    this.id = const Value.absent(),
    this.bookName = const Value.absent(),
    this.bookNumber = const Value.absent(),
    this.currentPage = const Value.absent(),
    this.syncUuid = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
  });
  BooksBookmarkCompanion.insert({
    this.id = const Value.absent(),
    this.bookName = const Value.absent(),
    this.bookNumber = const Value.absent(),
    this.currentPage = const Value.absent(),
    this.syncUuid = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
  });
  static Insertable<BooksBookmarkData> custom({
    Expression<int>? id,
    Expression<String>? bookName,
    Expression<int>? bookNumber,
    Expression<int>? currentPage,
    Expression<String>? syncUuid,
    Expression<int>? updatedAt,
    Expression<bool>? deleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookName != null) 'book_name': bookName,
      if (bookNumber != null) 'book_number': bookNumber,
      if (currentPage != null) 'current_page': currentPage,
      if (syncUuid != null) 'sync_uuid': syncUuid,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
    });
  }

  BooksBookmarkCompanion copyWith({
    Value<int>? id,
    Value<String?>? bookName,
    Value<int?>? bookNumber,
    Value<int?>? currentPage,
    Value<String?>? syncUuid,
    Value<int>? updatedAt,
    Value<bool>? deleted,
  }) {
    return BooksBookmarkCompanion(
      id: id ?? this.id,
      bookName: bookName ?? this.bookName,
      bookNumber: bookNumber ?? this.bookNumber,
      currentPage: currentPage ?? this.currentPage,
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
    if (bookName.present) {
      map['book_name'] = Variable<String>(bookName.value);
    }
    if (bookNumber.present) {
      map['book_number'] = Variable<int>(bookNumber.value);
    }
    if (currentPage.present) {
      map['current_page'] = Variable<int>(currentPage.value);
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
    return (StringBuffer('BooksBookmarkCompanion(')
          ..write('id: $id, ')
          ..write('bookName: $bookName, ')
          ..write('bookNumber: $bookNumber, ')
          ..write('currentPage: $currentPage, ')
          ..write('syncUuid: $syncUuid, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }
}

abstract class _$BooksBookmarkDatabase extends GeneratedDatabase {
  _$BooksBookmarkDatabase(QueryExecutor e) : super(e);
  $BooksBookmarkDatabaseManager get managers =>
      $BooksBookmarkDatabaseManager(this);
  late final $BooksBookmarkTable booksBookmark = $BooksBookmarkTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [booksBookmark];
}

typedef $$BooksBookmarkTableCreateCompanionBuilder =
    BooksBookmarkCompanion Function({
      Value<int> id,
      Value<String?> bookName,
      Value<int?> bookNumber,
      Value<int?> currentPage,
      Value<String?> syncUuid,
      Value<int> updatedAt,
      Value<bool> deleted,
    });
typedef $$BooksBookmarkTableUpdateCompanionBuilder =
    BooksBookmarkCompanion Function({
      Value<int> id,
      Value<String?> bookName,
      Value<int?> bookNumber,
      Value<int?> currentPage,
      Value<String?> syncUuid,
      Value<int> updatedAt,
      Value<bool> deleted,
    });

class $$BooksBookmarkTableFilterComposer
    extends Composer<_$BooksBookmarkDatabase, $BooksBookmarkTable> {
  $$BooksBookmarkTableFilterComposer({
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

  ColumnFilters<String> get bookName => $composableBuilder(
    column: $table.bookName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bookNumber => $composableBuilder(
    column: $table.bookNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentPage => $composableBuilder(
    column: $table.currentPage,
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

class $$BooksBookmarkTableOrderingComposer
    extends Composer<_$BooksBookmarkDatabase, $BooksBookmarkTable> {
  $$BooksBookmarkTableOrderingComposer({
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

  ColumnOrderings<String> get bookName => $composableBuilder(
    column: $table.bookName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bookNumber => $composableBuilder(
    column: $table.bookNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentPage => $composableBuilder(
    column: $table.currentPage,
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

class $$BooksBookmarkTableAnnotationComposer
    extends Composer<_$BooksBookmarkDatabase, $BooksBookmarkTable> {
  $$BooksBookmarkTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get bookName =>
      $composableBuilder(column: $table.bookName, builder: (column) => column);

  GeneratedColumn<int> get bookNumber => $composableBuilder(
    column: $table.bookNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentPage => $composableBuilder(
    column: $table.currentPage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncUuid =>
      $composableBuilder(column: $table.syncUuid, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);
}

class $$BooksBookmarkTableTableManager
    extends
        RootTableManager<
          _$BooksBookmarkDatabase,
          $BooksBookmarkTable,
          BooksBookmarkData,
          $$BooksBookmarkTableFilterComposer,
          $$BooksBookmarkTableOrderingComposer,
          $$BooksBookmarkTableAnnotationComposer,
          $$BooksBookmarkTableCreateCompanionBuilder,
          $$BooksBookmarkTableUpdateCompanionBuilder,
          (
            BooksBookmarkData,
            BaseReferences<
              _$BooksBookmarkDatabase,
              $BooksBookmarkTable,
              BooksBookmarkData
            >,
          ),
          BooksBookmarkData,
          PrefetchHooks Function()
        > {
  $$BooksBookmarkTableTableManager(
    _$BooksBookmarkDatabase db,
    $BooksBookmarkTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BooksBookmarkTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BooksBookmarkTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BooksBookmarkTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> bookName = const Value.absent(),
                Value<int?> bookNumber = const Value.absent(),
                Value<int?> currentPage = const Value.absent(),
                Value<String?> syncUuid = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
              }) => BooksBookmarkCompanion(
                id: id,
                bookName: bookName,
                bookNumber: bookNumber,
                currentPage: currentPage,
                syncUuid: syncUuid,
                updatedAt: updatedAt,
                deleted: deleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> bookName = const Value.absent(),
                Value<int?> bookNumber = const Value.absent(),
                Value<int?> currentPage = const Value.absent(),
                Value<String?> syncUuid = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
              }) => BooksBookmarkCompanion.insert(
                id: id,
                bookName: bookName,
                bookNumber: bookNumber,
                currentPage: currentPage,
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

typedef $$BooksBookmarkTableProcessedTableManager =
    ProcessedTableManager<
      _$BooksBookmarkDatabase,
      $BooksBookmarkTable,
      BooksBookmarkData,
      $$BooksBookmarkTableFilterComposer,
      $$BooksBookmarkTableOrderingComposer,
      $$BooksBookmarkTableAnnotationComposer,
      $$BooksBookmarkTableCreateCompanionBuilder,
      $$BooksBookmarkTableUpdateCompanionBuilder,
      (
        BooksBookmarkData,
        BaseReferences<
          _$BooksBookmarkDatabase,
          $BooksBookmarkTable,
          BooksBookmarkData
        >,
      ),
      BooksBookmarkData,
      PrefetchHooks Function()
    >;

class $BooksBookmarkDatabaseManager {
  final _$BooksBookmarkDatabase _db;
  $BooksBookmarkDatabaseManager(this._db);
  $$BooksBookmarkTableTableManager get booksBookmark =>
      $$BooksBookmarkTableTableManager(_db, _db.booksBookmark);
}

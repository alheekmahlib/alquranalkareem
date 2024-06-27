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
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _bookNameMeta =
      const VerificationMeta('bookName');
  @override
  late final GeneratedColumn<String> bookName = GeneratedColumn<String>(
      'book_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _bookNumberMeta =
      const VerificationMeta('bookNumber');
  @override
  late final GeneratedColumn<int> bookNumber = GeneratedColumn<int>(
      'book_number', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _currentPageMeta =
      const VerificationMeta('currentPage');
  @override
  late final GeneratedColumn<int> currentPage = GeneratedColumn<int>(
      'current_page', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, bookName, bookNumber, currentPage];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'books_bookmark';
  @override
  VerificationContext validateIntegrity(Insertable<BooksBookmarkData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('book_name')) {
      context.handle(_bookNameMeta,
          bookName.isAcceptableOrUnknown(data['book_name']!, _bookNameMeta));
    }
    if (data.containsKey('book_number')) {
      context.handle(
          _bookNumberMeta,
          bookNumber.isAcceptableOrUnknown(
              data['book_number']!, _bookNumberMeta));
    }
    if (data.containsKey('current_page')) {
      context.handle(
          _currentPageMeta,
          currentPage.isAcceptableOrUnknown(
              data['current_page']!, _currentPageMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BooksBookmarkData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BooksBookmarkData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      bookName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}book_name']),
      bookNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}book_number']),
      currentPage: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_page']),
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
  const BooksBookmarkData(
      {required this.id, this.bookName, this.bookNumber, this.currentPage});
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
    );
  }

  factory BooksBookmarkData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BooksBookmarkData(
      id: serializer.fromJson<int>(json['id']),
      bookName: serializer.fromJson<String?>(json['bookName']),
      bookNumber: serializer.fromJson<int?>(json['bookNumber']),
      currentPage: serializer.fromJson<int?>(json['currentPage']),
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
    };
  }

  BooksBookmarkData copyWith(
          {int? id,
          Value<String?> bookName = const Value.absent(),
          Value<int?> bookNumber = const Value.absent(),
          Value<int?> currentPage = const Value.absent()}) =>
      BooksBookmarkData(
        id: id ?? this.id,
        bookName: bookName.present ? bookName.value : this.bookName,
        bookNumber: bookNumber.present ? bookNumber.value : this.bookNumber,
        currentPage: currentPage.present ? currentPage.value : this.currentPage,
      );
  @override
  String toString() {
    return (StringBuffer('BooksBookmarkData(')
          ..write('id: $id, ')
          ..write('bookName: $bookName, ')
          ..write('bookNumber: $bookNumber, ')
          ..write('currentPage: $currentPage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, bookName, bookNumber, currentPage);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BooksBookmarkData &&
          other.id == this.id &&
          other.bookName == this.bookName &&
          other.bookNumber == this.bookNumber &&
          other.currentPage == this.currentPage);
}

class BooksBookmarkCompanion extends UpdateCompanion<BooksBookmarkData> {
  final Value<int> id;
  final Value<String?> bookName;
  final Value<int?> bookNumber;
  final Value<int?> currentPage;
  const BooksBookmarkCompanion({
    this.id = const Value.absent(),
    this.bookName = const Value.absent(),
    this.bookNumber = const Value.absent(),
    this.currentPage = const Value.absent(),
  });
  BooksBookmarkCompanion.insert({
    this.id = const Value.absent(),
    this.bookName = const Value.absent(),
    this.bookNumber = const Value.absent(),
    this.currentPage = const Value.absent(),
  });
  static Insertable<BooksBookmarkData> custom({
    Expression<int>? id,
    Expression<String>? bookName,
    Expression<int>? bookNumber,
    Expression<int>? currentPage,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookName != null) 'book_name': bookName,
      if (bookNumber != null) 'book_number': bookNumber,
      if (currentPage != null) 'current_page': currentPage,
    });
  }

  BooksBookmarkCompanion copyWith(
      {Value<int>? id,
      Value<String?>? bookName,
      Value<int?>? bookNumber,
      Value<int?>? currentPage}) {
    return BooksBookmarkCompanion(
      id: id ?? this.id,
      bookName: bookName ?? this.bookName,
      bookNumber: bookNumber ?? this.bookNumber,
      currentPage: currentPage ?? this.currentPage,
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BooksBookmarkCompanion(')
          ..write('id: $id, ')
          ..write('bookName: $bookName, ')
          ..write('bookNumber: $bookNumber, ')
          ..write('currentPage: $currentPage')
          ..write(')'))
        .toString();
  }
}

abstract class _$BooksBookmarkDatabase extends GeneratedDatabase {
  _$BooksBookmarkDatabase(QueryExecutor e) : super(e);
  _$BooksBookmarkDatabaseManager get managers =>
      _$BooksBookmarkDatabaseManager(this);
  late final $BooksBookmarkTable booksBookmark = $BooksBookmarkTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [booksBookmark];
}

typedef $$BooksBookmarkTableInsertCompanionBuilder = BooksBookmarkCompanion
    Function({
  Value<int> id,
  Value<String?> bookName,
  Value<int?> bookNumber,
  Value<int?> currentPage,
});
typedef $$BooksBookmarkTableUpdateCompanionBuilder = BooksBookmarkCompanion
    Function({
  Value<int> id,
  Value<String?> bookName,
  Value<int?> bookNumber,
  Value<int?> currentPage,
});

class $$BooksBookmarkTableTableManager extends RootTableManager<
    _$BooksBookmarkDatabase,
    $BooksBookmarkTable,
    BooksBookmarkData,
    $$BooksBookmarkTableFilterComposer,
    $$BooksBookmarkTableOrderingComposer,
    $$BooksBookmarkTableProcessedTableManager,
    $$BooksBookmarkTableInsertCompanionBuilder,
    $$BooksBookmarkTableUpdateCompanionBuilder> {
  $$BooksBookmarkTableTableManager(
      _$BooksBookmarkDatabase db, $BooksBookmarkTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$BooksBookmarkTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$BooksBookmarkTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$BooksBookmarkTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<String?> bookName = const Value.absent(),
            Value<int?> bookNumber = const Value.absent(),
            Value<int?> currentPage = const Value.absent(),
          }) =>
              BooksBookmarkCompanion(
            id: id,
            bookName: bookName,
            bookNumber: bookNumber,
            currentPage: currentPage,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<String?> bookName = const Value.absent(),
            Value<int?> bookNumber = const Value.absent(),
            Value<int?> currentPage = const Value.absent(),
          }) =>
              BooksBookmarkCompanion.insert(
            id: id,
            bookName: bookName,
            bookNumber: bookNumber,
            currentPage: currentPage,
          ),
        ));
}

class $$BooksBookmarkTableProcessedTableManager extends ProcessedTableManager<
    _$BooksBookmarkDatabase,
    $BooksBookmarkTable,
    BooksBookmarkData,
    $$BooksBookmarkTableFilterComposer,
    $$BooksBookmarkTableOrderingComposer,
    $$BooksBookmarkTableProcessedTableManager,
    $$BooksBookmarkTableInsertCompanionBuilder,
    $$BooksBookmarkTableUpdateCompanionBuilder> {
  $$BooksBookmarkTableProcessedTableManager(super.$state);
}

class $$BooksBookmarkTableFilterComposer
    extends FilterComposer<_$BooksBookmarkDatabase, $BooksBookmarkTable> {
  $$BooksBookmarkTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get bookName => $state.composableBuilder(
      column: $state.table.bookName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get bookNumber => $state.composableBuilder(
      column: $state.table.bookNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get currentPage => $state.composableBuilder(
      column: $state.table.currentPage,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$BooksBookmarkTableOrderingComposer
    extends OrderingComposer<_$BooksBookmarkDatabase, $BooksBookmarkTable> {
  $$BooksBookmarkTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get bookName => $state.composableBuilder(
      column: $state.table.bookName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get bookNumber => $state.composableBuilder(
      column: $state.table.bookNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get currentPage => $state.composableBuilder(
      column: $state.table.currentPage,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class _$BooksBookmarkDatabaseManager {
  final _$BooksBookmarkDatabase _db;
  _$BooksBookmarkDatabaseManager(this._db);
  $$BooksBookmarkTableTableManager get booksBookmark =>
      $$BooksBookmarkTableTableManager(_db, _db.booksBookmark);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tafsir_database.dart';

// ignore_for_file: type=lint
class $TafsirTableTable extends TafsirTable
    with TableInfo<$TafsirTableTable, TafsirTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TafsirTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'index', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _surahNumMeta =
      const VerificationMeta('surahNum');
  @override
  late final GeneratedColumn<int> surahNum = GeneratedColumn<int>(
      'sura', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _ayahNumMeta =
      const VerificationMeta('ayahNum');
  @override
  late final GeneratedColumn<int> ayahNum = GeneratedColumn<int>(
      'aya', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _tafsirTextMeta =
      const VerificationMeta('tafsirText');
  @override
  late final GeneratedColumn<String> tafsirText = GeneratedColumn<String>(
      'Text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pageNumMeta =
      const VerificationMeta('pageNum');
  @override
  late final GeneratedColumn<int> pageNum = GeneratedColumn<int>(
      'PageNum', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, surahNum, ayahNum, tafsirText, pageNum];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tafsir_table';
  @override
  VerificationContext validateIntegrity(Insertable<TafsirTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('index')) {
      context.handle(
          _idMeta, id.isAcceptableOrUnknown(data['index']!, _idMeta));
    }
    if (data.containsKey('sura')) {
      context.handle(_surahNumMeta,
          surahNum.isAcceptableOrUnknown(data['sura']!, _surahNumMeta));
    } else if (isInserting) {
      context.missing(_surahNumMeta);
    }
    if (data.containsKey('aya')) {
      context.handle(_ayahNumMeta,
          ayahNum.isAcceptableOrUnknown(data['aya']!, _ayahNumMeta));
    } else if (isInserting) {
      context.missing(_ayahNumMeta);
    }
    if (data.containsKey('Text')) {
      context.handle(_tafsirTextMeta,
          tafsirText.isAcceptableOrUnknown(data['Text']!, _tafsirTextMeta));
    } else if (isInserting) {
      context.missing(_tafsirTextMeta);
    }
    if (data.containsKey('PageNum')) {
      context.handle(_pageNumMeta,
          pageNum.isAcceptableOrUnknown(data['PageNum']!, _pageNumMeta));
    } else if (isInserting) {
      context.missing(_pageNumMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TafsirTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TafsirTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}index'])!,
      surahNum: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sura'])!,
      ayahNum: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}aya'])!,
      tafsirText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}Text'])!,
      pageNum: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}PageNum'])!,
    );
  }

  @override
  $TafsirTableTable createAlias(String alias) {
    return $TafsirTableTable(attachedDatabase, alias);
  }
}

class TafsirTableData extends DataClass implements Insertable<TafsirTableData> {
  final int id;
  final int surahNum;
  final int ayahNum;
  final String tafsirText;
  final int pageNum;
  const TafsirTableData(
      {required this.id,
      required this.surahNum,
      required this.ayahNum,
      required this.tafsirText,
      required this.pageNum});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['index'] = Variable<int>(id);
    map['sura'] = Variable<int>(surahNum);
    map['aya'] = Variable<int>(ayahNum);
    map['Text'] = Variable<String>(tafsirText);
    map['PageNum'] = Variable<int>(pageNum);
    return map;
  }

  TafsirTableCompanion toCompanion(bool nullToAbsent) {
    return TafsirTableCompanion(
      id: Value(id),
      surahNum: Value(surahNum),
      ayahNum: Value(ayahNum),
      tafsirText: Value(tafsirText),
      pageNum: Value(pageNum),
    );
  }

  factory TafsirTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TafsirTableData(
      id: serializer.fromJson<int>(json['id']),
      surahNum: serializer.fromJson<int>(json['surahNum']),
      ayahNum: serializer.fromJson<int>(json['ayahNum']),
      tafsirText: serializer.fromJson<String>(json['tafsirText']),
      pageNum: serializer.fromJson<int>(json['pageNum']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'surahNum': serializer.toJson<int>(surahNum),
      'ayahNum': serializer.toJson<int>(ayahNum),
      'tafsirText': serializer.toJson<String>(tafsirText),
      'pageNum': serializer.toJson<int>(pageNum),
    };
  }

  TafsirTableData copyWith(
          {int? id,
          int? surahNum,
          int? ayahNum,
          String? tafsirText,
          int? pageNum}) =>
      TafsirTableData(
        id: id ?? this.id,
        surahNum: surahNum ?? this.surahNum,
        ayahNum: ayahNum ?? this.ayahNum,
        tafsirText: tafsirText ?? this.tafsirText,
        pageNum: pageNum ?? this.pageNum,
      );
  TafsirTableData copyWithCompanion(TafsirTableCompanion data) {
    return TafsirTableData(
      id: data.id.present ? data.id.value : this.id,
      surahNum: data.surahNum.present ? data.surahNum.value : this.surahNum,
      ayahNum: data.ayahNum.present ? data.ayahNum.value : this.ayahNum,
      tafsirText:
          data.tafsirText.present ? data.tafsirText.value : this.tafsirText,
      pageNum: data.pageNum.present ? data.pageNum.value : this.pageNum,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TafsirTableData(')
          ..write('id: $id, ')
          ..write('surahNum: $surahNum, ')
          ..write('ayahNum: $ayahNum, ')
          ..write('tafsirText: $tafsirText, ')
          ..write('pageNum: $pageNum')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, surahNum, ayahNum, tafsirText, pageNum);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TafsirTableData &&
          other.id == this.id &&
          other.surahNum == this.surahNum &&
          other.ayahNum == this.ayahNum &&
          other.tafsirText == this.tafsirText &&
          other.pageNum == this.pageNum);
}

class TafsirTableCompanion extends UpdateCompanion<TafsirTableData> {
  final Value<int> id;
  final Value<int> surahNum;
  final Value<int> ayahNum;
  final Value<String> tafsirText;
  final Value<int> pageNum;
  const TafsirTableCompanion({
    this.id = const Value.absent(),
    this.surahNum = const Value.absent(),
    this.ayahNum = const Value.absent(),
    this.tafsirText = const Value.absent(),
    this.pageNum = const Value.absent(),
  });
  TafsirTableCompanion.insert({
    this.id = const Value.absent(),
    required int surahNum,
    required int ayahNum,
    required String tafsirText,
    required int pageNum,
  })  : surahNum = Value(surahNum),
        ayahNum = Value(ayahNum),
        tafsirText = Value(tafsirText),
        pageNum = Value(pageNum);
  static Insertable<TafsirTableData> custom({
    Expression<int>? id,
    Expression<int>? surahNum,
    Expression<int>? ayahNum,
    Expression<String>? tafsirText,
    Expression<int>? pageNum,
  }) {
    return RawValuesInsertable({
      if (id != null) 'index': id,
      if (surahNum != null) 'sura': surahNum,
      if (ayahNum != null) 'aya': ayahNum,
      if (tafsirText != null) 'Text': tafsirText,
      if (pageNum != null) 'PageNum': pageNum,
    });
  }

  TafsirTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? surahNum,
      Value<int>? ayahNum,
      Value<String>? tafsirText,
      Value<int>? pageNum}) {
    return TafsirTableCompanion(
      id: id ?? this.id,
      surahNum: surahNum ?? this.surahNum,
      ayahNum: ayahNum ?? this.ayahNum,
      tafsirText: tafsirText ?? this.tafsirText,
      pageNum: pageNum ?? this.pageNum,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['index'] = Variable<int>(id.value);
    }
    if (surahNum.present) {
      map['sura'] = Variable<int>(surahNum.value);
    }
    if (ayahNum.present) {
      map['aya'] = Variable<int>(ayahNum.value);
    }
    if (tafsirText.present) {
      map['Text'] = Variable<String>(tafsirText.value);
    }
    if (pageNum.present) {
      map['PageNum'] = Variable<int>(pageNum.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TafsirTableCompanion(')
          ..write('id: $id, ')
          ..write('surahNum: $surahNum, ')
          ..write('ayahNum: $ayahNum, ')
          ..write('tafsirText: $tafsirText, ')
          ..write('pageNum: $pageNum')
          ..write(')'))
        .toString();
  }
}

abstract class _$TafsirDatabase extends GeneratedDatabase {
  _$TafsirDatabase(QueryExecutor e) : super(e);
  $TafsirDatabaseManager get managers => $TafsirDatabaseManager(this);
  late final $TafsirTableTable tafsirTable = $TafsirTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [tafsirTable];
}

typedef $$TafsirTableTableCreateCompanionBuilder = TafsirTableCompanion
    Function({
  Value<int> id,
  required int surahNum,
  required int ayahNum,
  required String tafsirText,
  required int pageNum,
});
typedef $$TafsirTableTableUpdateCompanionBuilder = TafsirTableCompanion
    Function({
  Value<int> id,
  Value<int> surahNum,
  Value<int> ayahNum,
  Value<String> tafsirText,
  Value<int> pageNum,
});

class $$TafsirTableTableTableManager extends RootTableManager<
    _$TafsirDatabase,
    $TafsirTableTable,
    TafsirTableData,
    $$TafsirTableTableFilterComposer,
    $$TafsirTableTableOrderingComposer,
    $$TafsirTableTableCreateCompanionBuilder,
    $$TafsirTableTableUpdateCompanionBuilder> {
  $$TafsirTableTableTableManager(_$TafsirDatabase db, $TafsirTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$TafsirTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$TafsirTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> surahNum = const Value.absent(),
            Value<int> ayahNum = const Value.absent(),
            Value<String> tafsirText = const Value.absent(),
            Value<int> pageNum = const Value.absent(),
          }) =>
              TafsirTableCompanion(
            id: id,
            surahNum: surahNum,
            ayahNum: ayahNum,
            tafsirText: tafsirText,
            pageNum: pageNum,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int surahNum,
            required int ayahNum,
            required String tafsirText,
            required int pageNum,
          }) =>
              TafsirTableCompanion.insert(
            id: id,
            surahNum: surahNum,
            ayahNum: ayahNum,
            tafsirText: tafsirText,
            pageNum: pageNum,
          ),
        ));
}

class $$TafsirTableTableFilterComposer
    extends FilterComposer<_$TafsirDatabase, $TafsirTableTable> {
  $$TafsirTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get surahNum => $state.composableBuilder(
      column: $state.table.surahNum,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get ayahNum => $state.composableBuilder(
      column: $state.table.ayahNum,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get tafsirText => $state.composableBuilder(
      column: $state.table.tafsirText,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get pageNum => $state.composableBuilder(
      column: $state.table.pageNum,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$TafsirTableTableOrderingComposer
    extends OrderingComposer<_$TafsirDatabase, $TafsirTableTable> {
  $$TafsirTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get surahNum => $state.composableBuilder(
      column: $state.table.surahNum,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get ayahNum => $state.composableBuilder(
      column: $state.table.ayahNum,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get tafsirText => $state.composableBuilder(
      column: $state.table.tafsirText,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get pageNum => $state.composableBuilder(
      column: $state.table.pageNum,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $TafsirDatabaseManager {
  final _$TafsirDatabase _db;
  $TafsirDatabaseManager(this._db);
  $$TafsirTableTableTableManager get tafsirTable =>
      $$TafsirTableTableTableManager(_db, _db.tafsirTable);
}

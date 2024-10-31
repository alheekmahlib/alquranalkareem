// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quran_database.dart';

// ignore_for_file: type=lint
class $QuranTableTable extends QuranTable
    with TableInfo<$QuranTableTable, QuranTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuranTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'ID', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _surahNumMeta =
      const VerificationMeta('surahNum');
  @override
  late final GeneratedColumn<int> surahNum = GeneratedColumn<int>(
      'SoraNum', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _ayaNumMeta = const VerificationMeta('ayaNum');
  @override
  late final GeneratedColumn<int> ayaNum = GeneratedColumn<int>(
      'AyaNum', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _pageNumMeta =
      const VerificationMeta('pageNum');
  @override
  late final GeneratedColumn<int> pageNum = GeneratedColumn<int>(
      'PageNum', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _sorahNameMeta =
      const VerificationMeta('sorahName');
  @override
  late final GeneratedColumn<String> sorahName = GeneratedColumn<String>(
      'SoraName_ar', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sorahNameEnMeta =
      const VerificationMeta('sorahNameEn');
  @override
  late final GeneratedColumn<String> sorahNameEn = GeneratedColumn<String>(
      'SoraName_En', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ayaTextMeta =
      const VerificationMeta('ayaText');
  @override
  late final GeneratedColumn<String> ayaText = GeneratedColumn<String>(
      'AyaDiac', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _searchTextColumnMeta =
      const VerificationMeta('searchTextColumn');
  @override
  late final GeneratedColumn<String> searchTextColumn = GeneratedColumn<String>(
      'SearchText', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _soraNameSearchMeta =
      const VerificationMeta('soraNameSearch');
  @override
  late final GeneratedColumn<String> soraNameSearch = GeneratedColumn<String>(
      'SoraNameSearch', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _partNumMeta =
      const VerificationMeta('partNum');
  @override
  late final GeneratedColumn<int> partNum = GeneratedColumn<int>(
      'PartNum', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        surahNum,
        ayaNum,
        pageNum,
        sorahName,
        sorahNameEn,
        ayaText,
        searchTextColumn,
        soraNameSearch,
        partNum
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quran_table';
  @override
  VerificationContext validateIntegrity(Insertable<QuranTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('ID')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['ID']!, _idMeta));
    }
    if (data.containsKey('SoraNum')) {
      context.handle(_surahNumMeta,
          surahNum.isAcceptableOrUnknown(data['SoraNum']!, _surahNumMeta));
    } else if (isInserting) {
      context.missing(_surahNumMeta);
    }
    if (data.containsKey('AyaNum')) {
      context.handle(_ayaNumMeta,
          ayaNum.isAcceptableOrUnknown(data['AyaNum']!, _ayaNumMeta));
    } else if (isInserting) {
      context.missing(_ayaNumMeta);
    }
    if (data.containsKey('PageNum')) {
      context.handle(_pageNumMeta,
          pageNum.isAcceptableOrUnknown(data['PageNum']!, _pageNumMeta));
    }
    if (data.containsKey('SoraName_ar')) {
      context.handle(
          _sorahNameMeta,
          sorahName.isAcceptableOrUnknown(
              data['SoraName_ar']!, _sorahNameMeta));
    } else if (isInserting) {
      context.missing(_sorahNameMeta);
    }
    if (data.containsKey('SoraName_En')) {
      context.handle(
          _sorahNameEnMeta,
          sorahNameEn.isAcceptableOrUnknown(
              data['SoraName_En']!, _sorahNameEnMeta));
    } else if (isInserting) {
      context.missing(_sorahNameEnMeta);
    }
    if (data.containsKey('AyaDiac')) {
      context.handle(_ayaTextMeta,
          ayaText.isAcceptableOrUnknown(data['AyaDiac']!, _ayaTextMeta));
    } else if (isInserting) {
      context.missing(_ayaTextMeta);
    }
    if (data.containsKey('SearchText')) {
      context.handle(
          _searchTextColumnMeta,
          searchTextColumn.isAcceptableOrUnknown(
              data['SearchText']!, _searchTextColumnMeta));
    } else if (isInserting) {
      context.missing(_searchTextColumnMeta);
    }
    if (data.containsKey('SoraNameSearch')) {
      context.handle(
          _soraNameSearchMeta,
          soraNameSearch.isAcceptableOrUnknown(
              data['SoraNameSearch']!, _soraNameSearchMeta));
    } else if (isInserting) {
      context.missing(_soraNameSearchMeta);
    }
    if (data.containsKey('PartNum')) {
      context.handle(_partNumMeta,
          partNum.isAcceptableOrUnknown(data['PartNum']!, _partNumMeta));
    } else if (isInserting) {
      context.missing(_partNumMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuranTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuranTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ID'])!,
      surahNum: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}SoraNum'])!,
      ayaNum: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}AyaNum'])!,
      pageNum: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}PageNum']),
      sorahName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}SoraName_ar'])!,
      sorahNameEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}SoraName_En'])!,
      ayaText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}AyaDiac'])!,
      searchTextColumn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}SearchText'])!,
      soraNameSearch: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}SoraNameSearch'])!,
      partNum: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}PartNum'])!,
    );
  }

  @override
  $QuranTableTable createAlias(String alias) {
    return $QuranTableTable(attachedDatabase, alias);
  }
}

class QuranTableData extends DataClass implements Insertable<QuranTableData> {
  final int id;
  final int surahNum;
  final int ayaNum;
  final int? pageNum;
  final String sorahName;
  final String sorahNameEn;
  final String ayaText;
  final String searchTextColumn;
  final String soraNameSearch;
  final int partNum;
  const QuranTableData(
      {required this.id,
      required this.surahNum,
      required this.ayaNum,
      this.pageNum,
      required this.sorahName,
      required this.sorahNameEn,
      required this.ayaText,
      required this.searchTextColumn,
      required this.soraNameSearch,
      required this.partNum});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['ID'] = Variable<int>(id);
    map['SoraNum'] = Variable<int>(surahNum);
    map['AyaNum'] = Variable<int>(ayaNum);
    if (!nullToAbsent || pageNum != null) {
      map['PageNum'] = Variable<int>(pageNum);
    }
    map['SoraName_ar'] = Variable<String>(sorahName);
    map['SoraName_En'] = Variable<String>(sorahNameEn);
    map['AyaDiac'] = Variable<String>(ayaText);
    map['SearchText'] = Variable<String>(searchTextColumn);
    map['SoraNameSearch'] = Variable<String>(soraNameSearch);
    map['PartNum'] = Variable<int>(partNum);
    return map;
  }

  QuranTableCompanion toCompanion(bool nullToAbsent) {
    return QuranTableCompanion(
      id: Value(id),
      surahNum: Value(surahNum),
      ayaNum: Value(ayaNum),
      pageNum: pageNum == null && nullToAbsent
          ? const Value.absent()
          : Value(pageNum),
      sorahName: Value(sorahName),
      sorahNameEn: Value(sorahNameEn),
      ayaText: Value(ayaText),
      searchTextColumn: Value(searchTextColumn),
      soraNameSearch: Value(soraNameSearch),
      partNum: Value(partNum),
    );
  }

  factory QuranTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuranTableData(
      id: serializer.fromJson<int>(json['id']),
      surahNum: serializer.fromJson<int>(json['surahNum']),
      ayaNum: serializer.fromJson<int>(json['ayaNum']),
      pageNum: serializer.fromJson<int?>(json['pageNum']),
      sorahName: serializer.fromJson<String>(json['sorahName']),
      sorahNameEn: serializer.fromJson<String>(json['sorahNameEn']),
      ayaText: serializer.fromJson<String>(json['ayaText']),
      searchTextColumn: serializer.fromJson<String>(json['searchTextColumn']),
      soraNameSearch: serializer.fromJson<String>(json['soraNameSearch']),
      partNum: serializer.fromJson<int>(json['partNum']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'surahNum': serializer.toJson<int>(surahNum),
      'ayaNum': serializer.toJson<int>(ayaNum),
      'pageNum': serializer.toJson<int?>(pageNum),
      'sorahName': serializer.toJson<String>(sorahName),
      'sorahNameEn': serializer.toJson<String>(sorahNameEn),
      'ayaText': serializer.toJson<String>(ayaText),
      'searchTextColumn': serializer.toJson<String>(searchTextColumn),
      'soraNameSearch': serializer.toJson<String>(soraNameSearch),
      'partNum': serializer.toJson<int>(partNum),
    };
  }

  QuranTableData copyWith(
          {int? id,
          int? surahNum,
          int? ayaNum,
          Value<int?> pageNum = const Value.absent(),
          String? sorahName,
          String? sorahNameEn,
          String? ayaText,
          String? searchTextColumn,
          String? soraNameSearch,
          int? partNum}) =>
      QuranTableData(
        id: id ?? this.id,
        surahNum: surahNum ?? this.surahNum,
        ayaNum: ayaNum ?? this.ayaNum,
        pageNum: pageNum.present ? pageNum.value : this.pageNum,
        sorahName: sorahName ?? this.sorahName,
        sorahNameEn: sorahNameEn ?? this.sorahNameEn,
        ayaText: ayaText ?? this.ayaText,
        searchTextColumn: searchTextColumn ?? this.searchTextColumn,
        soraNameSearch: soraNameSearch ?? this.soraNameSearch,
        partNum: partNum ?? this.partNum,
      );
  QuranTableData copyWithCompanion(QuranTableCompanion data) {
    return QuranTableData(
      id: data.id.present ? data.id.value : this.id,
      surahNum: data.surahNum.present ? data.surahNum.value : this.surahNum,
      ayaNum: data.ayaNum.present ? data.ayaNum.value : this.ayaNum,
      pageNum: data.pageNum.present ? data.pageNum.value : this.pageNum,
      sorahName: data.sorahName.present ? data.sorahName.value : this.sorahName,
      sorahNameEn:
          data.sorahNameEn.present ? data.sorahNameEn.value : this.sorahNameEn,
      ayaText: data.ayaText.present ? data.ayaText.value : this.ayaText,
      searchTextColumn: data.searchTextColumn.present
          ? data.searchTextColumn.value
          : this.searchTextColumn,
      soraNameSearch: data.soraNameSearch.present
          ? data.soraNameSearch.value
          : this.soraNameSearch,
      partNum: data.partNum.present ? data.partNum.value : this.partNum,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuranTableData(')
          ..write('id: $id, ')
          ..write('surahNum: $surahNum, ')
          ..write('ayaNum: $ayaNum, ')
          ..write('pageNum: $pageNum, ')
          ..write('sorahName: $sorahName, ')
          ..write('sorahNameEn: $sorahNameEn, ')
          ..write('ayaText: $ayaText, ')
          ..write('searchTextColumn: $searchTextColumn, ')
          ..write('soraNameSearch: $soraNameSearch, ')
          ..write('partNum: $partNum')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, surahNum, ayaNum, pageNum, sorahName,
      sorahNameEn, ayaText, searchTextColumn, soraNameSearch, partNum);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuranTableData &&
          other.id == this.id &&
          other.surahNum == this.surahNum &&
          other.ayaNum == this.ayaNum &&
          other.pageNum == this.pageNum &&
          other.sorahName == this.sorahName &&
          other.sorahNameEn == this.sorahNameEn &&
          other.ayaText == this.ayaText &&
          other.searchTextColumn == this.searchTextColumn &&
          other.soraNameSearch == this.soraNameSearch &&
          other.partNum == this.partNum);
}

class QuranTableCompanion extends UpdateCompanion<QuranTableData> {
  final Value<int> id;
  final Value<int> surahNum;
  final Value<int> ayaNum;
  final Value<int?> pageNum;
  final Value<String> sorahName;
  final Value<String> sorahNameEn;
  final Value<String> ayaText;
  final Value<String> searchTextColumn;
  final Value<String> soraNameSearch;
  final Value<int> partNum;
  const QuranTableCompanion({
    this.id = const Value.absent(),
    this.surahNum = const Value.absent(),
    this.ayaNum = const Value.absent(),
    this.pageNum = const Value.absent(),
    this.sorahName = const Value.absent(),
    this.sorahNameEn = const Value.absent(),
    this.ayaText = const Value.absent(),
    this.searchTextColumn = const Value.absent(),
    this.soraNameSearch = const Value.absent(),
    this.partNum = const Value.absent(),
  });
  QuranTableCompanion.insert({
    this.id = const Value.absent(),
    required int surahNum,
    required int ayaNum,
    this.pageNum = const Value.absent(),
    required String sorahName,
    required String sorahNameEn,
    required String ayaText,
    required String searchTextColumn,
    required String soraNameSearch,
    required int partNum,
  })  : surahNum = Value(surahNum),
        ayaNum = Value(ayaNum),
        sorahName = Value(sorahName),
        sorahNameEn = Value(sorahNameEn),
        ayaText = Value(ayaText),
        searchTextColumn = Value(searchTextColumn),
        soraNameSearch = Value(soraNameSearch),
        partNum = Value(partNum);
  static Insertable<QuranTableData> custom({
    Expression<int>? id,
    Expression<int>? surahNum,
    Expression<int>? ayaNum,
    Expression<int>? pageNum,
    Expression<String>? sorahName,
    Expression<String>? sorahNameEn,
    Expression<String>? ayaText,
    Expression<String>? searchTextColumn,
    Expression<String>? soraNameSearch,
    Expression<int>? partNum,
  }) {
    return RawValuesInsertable({
      if (id != null) 'ID': id,
      if (surahNum != null) 'SoraNum': surahNum,
      if (ayaNum != null) 'AyaNum': ayaNum,
      if (pageNum != null) 'PageNum': pageNum,
      if (sorahName != null) 'SoraName_ar': sorahName,
      if (sorahNameEn != null) 'SoraName_En': sorahNameEn,
      if (ayaText != null) 'AyaDiac': ayaText,
      if (searchTextColumn != null) 'SearchText': searchTextColumn,
      if (soraNameSearch != null) 'SoraNameSearch': soraNameSearch,
      if (partNum != null) 'PartNum': partNum,
    });
  }

  QuranTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? surahNum,
      Value<int>? ayaNum,
      Value<int?>? pageNum,
      Value<String>? sorahName,
      Value<String>? sorahNameEn,
      Value<String>? ayaText,
      Value<String>? searchTextColumn,
      Value<String>? soraNameSearch,
      Value<int>? partNum}) {
    return QuranTableCompanion(
      id: id ?? this.id,
      surahNum: surahNum ?? this.surahNum,
      ayaNum: ayaNum ?? this.ayaNum,
      pageNum: pageNum ?? this.pageNum,
      sorahName: sorahName ?? this.sorahName,
      sorahNameEn: sorahNameEn ?? this.sorahNameEn,
      ayaText: ayaText ?? this.ayaText,
      searchTextColumn: searchTextColumn ?? this.searchTextColumn,
      soraNameSearch: soraNameSearch ?? this.soraNameSearch,
      partNum: partNum ?? this.partNum,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['ID'] = Variable<int>(id.value);
    }
    if (surahNum.present) {
      map['SoraNum'] = Variable<int>(surahNum.value);
    }
    if (ayaNum.present) {
      map['AyaNum'] = Variable<int>(ayaNum.value);
    }
    if (pageNum.present) {
      map['PageNum'] = Variable<int>(pageNum.value);
    }
    if (sorahName.present) {
      map['SoraName_ar'] = Variable<String>(sorahName.value);
    }
    if (sorahNameEn.present) {
      map['SoraName_En'] = Variable<String>(sorahNameEn.value);
    }
    if (ayaText.present) {
      map['AyaDiac'] = Variable<String>(ayaText.value);
    }
    if (searchTextColumn.present) {
      map['SearchText'] = Variable<String>(searchTextColumn.value);
    }
    if (soraNameSearch.present) {
      map['SoraNameSearch'] = Variable<String>(soraNameSearch.value);
    }
    if (partNum.present) {
      map['PartNum'] = Variable<int>(partNum.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuranTableCompanion(')
          ..write('id: $id, ')
          ..write('surahNum: $surahNum, ')
          ..write('ayaNum: $ayaNum, ')
          ..write('pageNum: $pageNum, ')
          ..write('sorahName: $sorahName, ')
          ..write('sorahNameEn: $sorahNameEn, ')
          ..write('ayaText: $ayaText, ')
          ..write('searchTextColumn: $searchTextColumn, ')
          ..write('soraNameSearch: $soraNameSearch, ')
          ..write('partNum: $partNum')
          ..write(')'))
        .toString();
  }
}

abstract class _$QuranDatabase extends GeneratedDatabase {
  _$QuranDatabase(QueryExecutor e) : super(e);
  $QuranDatabaseManager get managers => $QuranDatabaseManager(this);
  late final $QuranTableTable quranTable = $QuranTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [quranTable];
}

typedef $$QuranTableTableCreateCompanionBuilder = QuranTableCompanion Function({
  Value<int> id,
  required int surahNum,
  required int ayaNum,
  Value<int?> pageNum,
  required String sorahName,
  required String sorahNameEn,
  required String ayaText,
  required String searchTextColumn,
  required String soraNameSearch,
  required int partNum,
});
typedef $$QuranTableTableUpdateCompanionBuilder = QuranTableCompanion Function({
  Value<int> id,
  Value<int> surahNum,
  Value<int> ayaNum,
  Value<int?> pageNum,
  Value<String> sorahName,
  Value<String> sorahNameEn,
  Value<String> ayaText,
  Value<String> searchTextColumn,
  Value<String> soraNameSearch,
  Value<int> partNum,
});

class $$QuranTableTableFilterComposer
    extends Composer<_$QuranDatabase, $QuranTableTable> {
  $$QuranTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get surahNum => $composableBuilder(
      column: $table.surahNum, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ayaNum => $composableBuilder(
      column: $table.ayaNum, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get pageNum => $composableBuilder(
      column: $table.pageNum, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sorahName => $composableBuilder(
      column: $table.sorahName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sorahNameEn => $composableBuilder(
      column: $table.sorahNameEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ayaText => $composableBuilder(
      column: $table.ayaText, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get searchTextColumn => $composableBuilder(
      column: $table.searchTextColumn,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get soraNameSearch => $composableBuilder(
      column: $table.soraNameSearch,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get partNum => $composableBuilder(
      column: $table.partNum, builder: (column) => ColumnFilters(column));
}

class $$QuranTableTableOrderingComposer
    extends Composer<_$QuranDatabase, $QuranTableTable> {
  $$QuranTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get surahNum => $composableBuilder(
      column: $table.surahNum, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ayaNum => $composableBuilder(
      column: $table.ayaNum, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get pageNum => $composableBuilder(
      column: $table.pageNum, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sorahName => $composableBuilder(
      column: $table.sorahName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sorahNameEn => $composableBuilder(
      column: $table.sorahNameEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ayaText => $composableBuilder(
      column: $table.ayaText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get searchTextColumn => $composableBuilder(
      column: $table.searchTextColumn,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get soraNameSearch => $composableBuilder(
      column: $table.soraNameSearch,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get partNum => $composableBuilder(
      column: $table.partNum, builder: (column) => ColumnOrderings(column));
}

class $$QuranTableTableAnnotationComposer
    extends Composer<_$QuranDatabase, $QuranTableTable> {
  $$QuranTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get surahNum =>
      $composableBuilder(column: $table.surahNum, builder: (column) => column);

  GeneratedColumn<int> get ayaNum =>
      $composableBuilder(column: $table.ayaNum, builder: (column) => column);

  GeneratedColumn<int> get pageNum =>
      $composableBuilder(column: $table.pageNum, builder: (column) => column);

  GeneratedColumn<String> get sorahName =>
      $composableBuilder(column: $table.sorahName, builder: (column) => column);

  GeneratedColumn<String> get sorahNameEn => $composableBuilder(
      column: $table.sorahNameEn, builder: (column) => column);

  GeneratedColumn<String> get ayaText =>
      $composableBuilder(column: $table.ayaText, builder: (column) => column);

  GeneratedColumn<String> get searchTextColumn => $composableBuilder(
      column: $table.searchTextColumn, builder: (column) => column);

  GeneratedColumn<String> get soraNameSearch => $composableBuilder(
      column: $table.soraNameSearch, builder: (column) => column);

  GeneratedColumn<int> get partNum =>
      $composableBuilder(column: $table.partNum, builder: (column) => column);
}

class $$QuranTableTableTableManager extends RootTableManager<
    _$QuranDatabase,
    $QuranTableTable,
    QuranTableData,
    $$QuranTableTableFilterComposer,
    $$QuranTableTableOrderingComposer,
    $$QuranTableTableAnnotationComposer,
    $$QuranTableTableCreateCompanionBuilder,
    $$QuranTableTableUpdateCompanionBuilder,
    (
      QuranTableData,
      BaseReferences<_$QuranDatabase, $QuranTableTable, QuranTableData>
    ),
    QuranTableData,
    PrefetchHooks Function()> {
  $$QuranTableTableTableManager(_$QuranDatabase db, $QuranTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuranTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuranTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuranTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> surahNum = const Value.absent(),
            Value<int> ayaNum = const Value.absent(),
            Value<int?> pageNum = const Value.absent(),
            Value<String> sorahName = const Value.absent(),
            Value<String> sorahNameEn = const Value.absent(),
            Value<String> ayaText = const Value.absent(),
            Value<String> searchTextColumn = const Value.absent(),
            Value<String> soraNameSearch = const Value.absent(),
            Value<int> partNum = const Value.absent(),
          }) =>
              QuranTableCompanion(
            id: id,
            surahNum: surahNum,
            ayaNum: ayaNum,
            pageNum: pageNum,
            sorahName: sorahName,
            sorahNameEn: sorahNameEn,
            ayaText: ayaText,
            searchTextColumn: searchTextColumn,
            soraNameSearch: soraNameSearch,
            partNum: partNum,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int surahNum,
            required int ayaNum,
            Value<int?> pageNum = const Value.absent(),
            required String sorahName,
            required String sorahNameEn,
            required String ayaText,
            required String searchTextColumn,
            required String soraNameSearch,
            required int partNum,
          }) =>
              QuranTableCompanion.insert(
            id: id,
            surahNum: surahNum,
            ayaNum: ayaNum,
            pageNum: pageNum,
            sorahName: sorahName,
            sorahNameEn: sorahNameEn,
            ayaText: ayaText,
            searchTextColumn: searchTextColumn,
            soraNameSearch: soraNameSearch,
            partNum: partNum,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$QuranTableTableProcessedTableManager = ProcessedTableManager<
    _$QuranDatabase,
    $QuranTableTable,
    QuranTableData,
    $$QuranTableTableFilterComposer,
    $$QuranTableTableOrderingComposer,
    $$QuranTableTableAnnotationComposer,
    $$QuranTableTableCreateCompanionBuilder,
    $$QuranTableTableUpdateCompanionBuilder,
    (
      QuranTableData,
      BaseReferences<_$QuranDatabase, $QuranTableTable, QuranTableData>
    ),
    QuranTableData,
    PrefetchHooks Function()>;

class $QuranDatabaseManager {
  final _$QuranDatabase _db;
  $QuranDatabaseManager(this._db);
  $$QuranTableTableTableManager get quranTable =>
      $$QuranTableTableTableManager(_db, _db.quranTable);
}

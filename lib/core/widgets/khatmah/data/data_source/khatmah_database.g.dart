// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'khatmah_database.dart';

// ignore_for_file: type=lint
class $KhatmahsTable extends Khatmahs with TableInfo<$KhatmahsTable, Khatmah> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KhatmahsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _currentPageMeta =
      const VerificationMeta('currentPage');
  @override
  late final GeneratedColumn<int> currentPage = GeneratedColumn<int>(
      'current_page', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _startAyahNumberMeta =
      const VerificationMeta('startAyahNumber');
  @override
  late final GeneratedColumn<int> startAyahNumber = GeneratedColumn<int>(
      'start_ayah_number', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _endAyahNumberMeta =
      const VerificationMeta('endAyahNumber');
  @override
  late final GeneratedColumn<int> endAyahNumber = GeneratedColumn<int>(
      'end_ayah_number', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _daysCountMeta =
      const VerificationMeta('daysCount');
  @override
  late final GeneratedColumn<int> daysCount = GeneratedColumn<int>(
      'days_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(30));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        currentPage,
        startAyahNumber,
        endAyahNumber,
        isCompleted,
        daysCount
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'khatmahs';
  @override
  VerificationContext validateIntegrity(Insertable<Khatmah> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('current_page')) {
      context.handle(
          _currentPageMeta,
          currentPage.isAcceptableOrUnknown(
              data['current_page']!, _currentPageMeta));
    }
    if (data.containsKey('start_ayah_number')) {
      context.handle(
          _startAyahNumberMeta,
          startAyahNumber.isAcceptableOrUnknown(
              data['start_ayah_number']!, _startAyahNumberMeta));
    }
    if (data.containsKey('end_ayah_number')) {
      context.handle(
          _endAyahNumberMeta,
          endAyahNumber.isAcceptableOrUnknown(
              data['end_ayah_number']!, _endAyahNumberMeta));
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    if (data.containsKey('days_count')) {
      context.handle(_daysCountMeta,
          daysCount.isAcceptableOrUnknown(data['days_count']!, _daysCountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Khatmah map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Khatmah(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      currentPage: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_page']),
      startAyahNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}start_ayah_number']),
      endAyahNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}end_ayah_number']),
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
      daysCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}days_count'])!,
    );
  }

  @override
  $KhatmahsTable createAlias(String alias) {
    return $KhatmahsTable(attachedDatabase, alias);
  }
}

class Khatmah extends DataClass implements Insertable<Khatmah> {
  final int id;
  final String? name;
  final int? currentPage;
  final int? startAyahNumber;
  final int? endAyahNumber;
  final bool isCompleted;
  final int daysCount;
  const Khatmah(
      {required this.id,
      this.name,
      this.currentPage,
      this.startAyahNumber,
      this.endAyahNumber,
      required this.isCompleted,
      required this.daysCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || currentPage != null) {
      map['current_page'] = Variable<int>(currentPage);
    }
    if (!nullToAbsent || startAyahNumber != null) {
      map['start_ayah_number'] = Variable<int>(startAyahNumber);
    }
    if (!nullToAbsent || endAyahNumber != null) {
      map['end_ayah_number'] = Variable<int>(endAyahNumber);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    map['days_count'] = Variable<int>(daysCount);
    return map;
  }

  KhatmahsCompanion toCompanion(bool nullToAbsent) {
    return KhatmahsCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      currentPage: currentPage == null && nullToAbsent
          ? const Value.absent()
          : Value(currentPage),
      startAyahNumber: startAyahNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(startAyahNumber),
      endAyahNumber: endAyahNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(endAyahNumber),
      isCompleted: Value(isCompleted),
      daysCount: Value(daysCount),
    );
  }

  factory Khatmah.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Khatmah(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      currentPage: serializer.fromJson<int?>(json['currentPage']),
      startAyahNumber: serializer.fromJson<int?>(json['startAyahNumber']),
      endAyahNumber: serializer.fromJson<int?>(json['endAyahNumber']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      daysCount: serializer.fromJson<int>(json['daysCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String?>(name),
      'currentPage': serializer.toJson<int?>(currentPage),
      'startAyahNumber': serializer.toJson<int?>(startAyahNumber),
      'endAyahNumber': serializer.toJson<int?>(endAyahNumber),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'daysCount': serializer.toJson<int>(daysCount),
    };
  }

  Khatmah copyWith(
          {int? id,
          Value<String?> name = const Value.absent(),
          Value<int?> currentPage = const Value.absent(),
          Value<int?> startAyahNumber = const Value.absent(),
          Value<int?> endAyahNumber = const Value.absent(),
          bool? isCompleted,
          int? daysCount}) =>
      Khatmah(
        id: id ?? this.id,
        name: name.present ? name.value : this.name,
        currentPage: currentPage.present ? currentPage.value : this.currentPage,
        startAyahNumber: startAyahNumber.present
            ? startAyahNumber.value
            : this.startAyahNumber,
        endAyahNumber:
            endAyahNumber.present ? endAyahNumber.value : this.endAyahNumber,
        isCompleted: isCompleted ?? this.isCompleted,
        daysCount: daysCount ?? this.daysCount,
      );
  @override
  String toString() {
    return (StringBuffer('Khatmah(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('currentPage: $currentPage, ')
          ..write('startAyahNumber: $startAyahNumber, ')
          ..write('endAyahNumber: $endAyahNumber, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('daysCount: $daysCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, currentPage, startAyahNumber,
      endAyahNumber, isCompleted, daysCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Khatmah &&
          other.id == this.id &&
          other.name == this.name &&
          other.currentPage == this.currentPage &&
          other.startAyahNumber == this.startAyahNumber &&
          other.endAyahNumber == this.endAyahNumber &&
          other.isCompleted == this.isCompleted &&
          other.daysCount == this.daysCount);
}

class KhatmahsCompanion extends UpdateCompanion<Khatmah> {
  final Value<int> id;
  final Value<String?> name;
  final Value<int?> currentPage;
  final Value<int?> startAyahNumber;
  final Value<int?> endAyahNumber;
  final Value<bool> isCompleted;
  final Value<int> daysCount;
  const KhatmahsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.currentPage = const Value.absent(),
    this.startAyahNumber = const Value.absent(),
    this.endAyahNumber = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.daysCount = const Value.absent(),
  });
  KhatmahsCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.currentPage = const Value.absent(),
    this.startAyahNumber = const Value.absent(),
    this.endAyahNumber = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.daysCount = const Value.absent(),
  });
  static Insertable<Khatmah> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? currentPage,
    Expression<int>? startAyahNumber,
    Expression<int>? endAyahNumber,
    Expression<bool>? isCompleted,
    Expression<int>? daysCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (currentPage != null) 'current_page': currentPage,
      if (startAyahNumber != null) 'start_ayah_number': startAyahNumber,
      if (endAyahNumber != null) 'end_ayah_number': endAyahNumber,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (daysCount != null) 'days_count': daysCount,
    });
  }

  KhatmahsCompanion copyWith(
      {Value<int>? id,
      Value<String?>? name,
      Value<int?>? currentPage,
      Value<int?>? startAyahNumber,
      Value<int?>? endAyahNumber,
      Value<bool>? isCompleted,
      Value<int>? daysCount}) {
    return KhatmahsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      currentPage: currentPage ?? this.currentPage,
      startAyahNumber: startAyahNumber ?? this.startAyahNumber,
      endAyahNumber: endAyahNumber ?? this.endAyahNumber,
      isCompleted: isCompleted ?? this.isCompleted,
      daysCount: daysCount ?? this.daysCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (currentPage.present) {
      map['current_page'] = Variable<int>(currentPage.value);
    }
    if (startAyahNumber.present) {
      map['start_ayah_number'] = Variable<int>(startAyahNumber.value);
    }
    if (endAyahNumber.present) {
      map['end_ayah_number'] = Variable<int>(endAyahNumber.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (daysCount.present) {
      map['days_count'] = Variable<int>(daysCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KhatmahsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('currentPage: $currentPage, ')
          ..write('startAyahNumber: $startAyahNumber, ')
          ..write('endAyahNumber: $endAyahNumber, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('daysCount: $daysCount')
          ..write(')'))
        .toString();
  }
}

abstract class _$KhatmahDatabase extends GeneratedDatabase {
  _$KhatmahDatabase(QueryExecutor e) : super(e);
  _$KhatmahDatabaseManager get managers => _$KhatmahDatabaseManager(this);
  late final $KhatmahsTable khatmahs = $KhatmahsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [khatmahs];
}

typedef $$KhatmahsTableInsertCompanionBuilder = KhatmahsCompanion Function({
  Value<int> id,
  Value<String?> name,
  Value<int?> currentPage,
  Value<int?> startAyahNumber,
  Value<int?> endAyahNumber,
  Value<bool> isCompleted,
  Value<int> daysCount,
});
typedef $$KhatmahsTableUpdateCompanionBuilder = KhatmahsCompanion Function({
  Value<int> id,
  Value<String?> name,
  Value<int?> currentPage,
  Value<int?> startAyahNumber,
  Value<int?> endAyahNumber,
  Value<bool> isCompleted,
  Value<int> daysCount,
});

class $$KhatmahsTableTableManager extends RootTableManager<
    _$KhatmahDatabase,
    $KhatmahsTable,
    Khatmah,
    $$KhatmahsTableFilterComposer,
    $$KhatmahsTableOrderingComposer,
    $$KhatmahsTableProcessedTableManager,
    $$KhatmahsTableInsertCompanionBuilder,
    $$KhatmahsTableUpdateCompanionBuilder> {
  $$KhatmahsTableTableManager(_$KhatmahDatabase db, $KhatmahsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$KhatmahsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$KhatmahsTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$KhatmahsTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<int?> currentPage = const Value.absent(),
            Value<int?> startAyahNumber = const Value.absent(),
            Value<int?> endAyahNumber = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<int> daysCount = const Value.absent(),
          }) =>
              KhatmahsCompanion(
            id: id,
            name: name,
            currentPage: currentPage,
            startAyahNumber: startAyahNumber,
            endAyahNumber: endAyahNumber,
            isCompleted: isCompleted,
            daysCount: daysCount,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<int?> currentPage = const Value.absent(),
            Value<int?> startAyahNumber = const Value.absent(),
            Value<int?> endAyahNumber = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<int> daysCount = const Value.absent(),
          }) =>
              KhatmahsCompanion.insert(
            id: id,
            name: name,
            currentPage: currentPage,
            startAyahNumber: startAyahNumber,
            endAyahNumber: endAyahNumber,
            isCompleted: isCompleted,
            daysCount: daysCount,
          ),
        ));
}

class $$KhatmahsTableProcessedTableManager extends ProcessedTableManager<
    _$KhatmahDatabase,
    $KhatmahsTable,
    Khatmah,
    $$KhatmahsTableFilterComposer,
    $$KhatmahsTableOrderingComposer,
    $$KhatmahsTableProcessedTableManager,
    $$KhatmahsTableInsertCompanionBuilder,
    $$KhatmahsTableUpdateCompanionBuilder> {
  $$KhatmahsTableProcessedTableManager(super.$state);
}

class $$KhatmahsTableFilterComposer
    extends FilterComposer<_$KhatmahDatabase, $KhatmahsTable> {
  $$KhatmahsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get currentPage => $state.composableBuilder(
      column: $state.table.currentPage,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get startAyahNumber => $state.composableBuilder(
      column: $state.table.startAyahNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get endAyahNumber => $state.composableBuilder(
      column: $state.table.endAyahNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isCompleted => $state.composableBuilder(
      column: $state.table.isCompleted,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get daysCount => $state.composableBuilder(
      column: $state.table.daysCount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$KhatmahsTableOrderingComposer
    extends OrderingComposer<_$KhatmahDatabase, $KhatmahsTable> {
  $$KhatmahsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get currentPage => $state.composableBuilder(
      column: $state.table.currentPage,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get startAyahNumber => $state.composableBuilder(
      column: $state.table.startAyahNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get endAyahNumber => $state.composableBuilder(
      column: $state.table.endAyahNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isCompleted => $state.composableBuilder(
      column: $state.table.isCompleted,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get daysCount => $state.composableBuilder(
      column: $state.table.daysCount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class _$KhatmahDatabaseManager {
  final _$KhatmahDatabase _db;
  _$KhatmahDatabaseManager(this._db);
  $$KhatmahsTableTableManager get khatmahs =>
      $$KhatmahsTableTableManager(_db, _db.khatmahs);
}

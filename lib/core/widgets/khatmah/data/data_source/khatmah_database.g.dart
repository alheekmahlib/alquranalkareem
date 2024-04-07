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
  static const VerificationMeta _surahNameMeta =
      const VerificationMeta('surahName');
  @override
  late final GeneratedColumn<String> surahName = GeneratedColumn<String>(
      'surah_name', aliasedName, true,
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
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        surahName,
        currentPage,
        startAyahNumber,
        endAyahNumber,
        isCompleted
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
    if (data.containsKey('surah_name')) {
      context.handle(_surahNameMeta,
          surahName.isAcceptableOrUnknown(data['surah_name']!, _surahNameMeta));
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
      surahName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}surah_name']),
      currentPage: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_page']),
      startAyahNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}start_ayah_number']),
      endAyahNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}end_ayah_number']),
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
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
  final String? surahName;
  final int? currentPage;
  final int? startAyahNumber;
  final int? endAyahNumber;
  final bool isCompleted;
  const Khatmah(
      {required this.id,
      this.name,
      this.surahName,
      this.currentPage,
      this.startAyahNumber,
      this.endAyahNumber,
      required this.isCompleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || surahName != null) {
      map['surah_name'] = Variable<String>(surahName);
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
    return map;
  }

  KhatmahsCompanion toCompanion(bool nullToAbsent) {
    return KhatmahsCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      surahName: surahName == null && nullToAbsent
          ? const Value.absent()
          : Value(surahName),
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
    );
  }

  factory Khatmah.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Khatmah(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      surahName: serializer.fromJson<String?>(json['surahName']),
      currentPage: serializer.fromJson<int?>(json['currentPage']),
      startAyahNumber: serializer.fromJson<int?>(json['startAyahNumber']),
      endAyahNumber: serializer.fromJson<int?>(json['endAyahNumber']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String?>(name),
      'surahName': serializer.toJson<String?>(surahName),
      'currentPage': serializer.toJson<int?>(currentPage),
      'startAyahNumber': serializer.toJson<int?>(startAyahNumber),
      'endAyahNumber': serializer.toJson<int?>(endAyahNumber),
      'isCompleted': serializer.toJson<bool>(isCompleted),
    };
  }

  Khatmah copyWith(
          {int? id,
          Value<String?> name = const Value.absent(),
          Value<String?> surahName = const Value.absent(),
          Value<int?> currentPage = const Value.absent(),
          Value<int?> startAyahNumber = const Value.absent(),
          Value<int?> endAyahNumber = const Value.absent(),
          bool? isCompleted}) =>
      Khatmah(
        id: id ?? this.id,
        name: name.present ? name.value : this.name,
        surahName: surahName.present ? surahName.value : this.surahName,
        currentPage: currentPage.present ? currentPage.value : this.currentPage,
        startAyahNumber: startAyahNumber.present
            ? startAyahNumber.value
            : this.startAyahNumber,
        endAyahNumber:
            endAyahNumber.present ? endAyahNumber.value : this.endAyahNumber,
        isCompleted: isCompleted ?? this.isCompleted,
      );
  @override
  String toString() {
    return (StringBuffer('Khatmah(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('surahName: $surahName, ')
          ..write('currentPage: $currentPage, ')
          ..write('startAyahNumber: $startAyahNumber, ')
          ..write('endAyahNumber: $endAyahNumber, ')
          ..write('isCompleted: $isCompleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, surahName, currentPage,
      startAyahNumber, endAyahNumber, isCompleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Khatmah &&
          other.id == this.id &&
          other.name == this.name &&
          other.surahName == this.surahName &&
          other.currentPage == this.currentPage &&
          other.startAyahNumber == this.startAyahNumber &&
          other.endAyahNumber == this.endAyahNumber &&
          other.isCompleted == this.isCompleted);
}

class KhatmahsCompanion extends UpdateCompanion<Khatmah> {
  final Value<int> id;
  final Value<String?> name;
  final Value<String?> surahName;
  final Value<int?> currentPage;
  final Value<int?> startAyahNumber;
  final Value<int?> endAyahNumber;
  final Value<bool> isCompleted;
  const KhatmahsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.surahName = const Value.absent(),
    this.currentPage = const Value.absent(),
    this.startAyahNumber = const Value.absent(),
    this.endAyahNumber = const Value.absent(),
    this.isCompleted = const Value.absent(),
  });
  KhatmahsCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.surahName = const Value.absent(),
    this.currentPage = const Value.absent(),
    this.startAyahNumber = const Value.absent(),
    this.endAyahNumber = const Value.absent(),
    this.isCompleted = const Value.absent(),
  });
  static Insertable<Khatmah> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? surahName,
    Expression<int>? currentPage,
    Expression<int>? startAyahNumber,
    Expression<int>? endAyahNumber,
    Expression<bool>? isCompleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (surahName != null) 'surah_name': surahName,
      if (currentPage != null) 'current_page': currentPage,
      if (startAyahNumber != null) 'start_ayah_number': startAyahNumber,
      if (endAyahNumber != null) 'end_ayah_number': endAyahNumber,
      if (isCompleted != null) 'is_completed': isCompleted,
    });
  }

  KhatmahsCompanion copyWith(
      {Value<int>? id,
      Value<String?>? name,
      Value<String?>? surahName,
      Value<int?>? currentPage,
      Value<int?>? startAyahNumber,
      Value<int?>? endAyahNumber,
      Value<bool>? isCompleted}) {
    return KhatmahsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      surahName: surahName ?? this.surahName,
      currentPage: currentPage ?? this.currentPage,
      startAyahNumber: startAyahNumber ?? this.startAyahNumber,
      endAyahNumber: endAyahNumber ?? this.endAyahNumber,
      isCompleted: isCompleted ?? this.isCompleted,
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
    if (surahName.present) {
      map['surah_name'] = Variable<String>(surahName.value);
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KhatmahsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('surahName: $surahName, ')
          ..write('currentPage: $currentPage, ')
          ..write('startAyahNumber: $startAyahNumber, ')
          ..write('endAyahNumber: $endAyahNumber, ')
          ..write('isCompleted: $isCompleted')
          ..write(')'))
        .toString();
  }
}

abstract class _$KhatmahDatabase extends GeneratedDatabase {
  _$KhatmahDatabase(QueryExecutor e) : super(e);
  late final $KhatmahsTable khatmahs = $KhatmahsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [khatmahs];
}

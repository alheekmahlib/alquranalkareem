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
  static const VerificationMeta _isTahzibSalafMeta =
      const VerificationMeta('isTahzibSalaf');
  @override
  late final GeneratedColumn<bool> isTahzibSalaf = GeneratedColumn<bool>(
      'is_tahzib_salaf', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_tahzib_salaf" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
      'color', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        currentPage,
        startAyahNumber,
        endAyahNumber,
        isCompleted,
        daysCount,
        isTahzibSalaf,
        color
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
    if (data.containsKey('is_tahzib_salaf')) {
      context.handle(
          _isTahzibSalafMeta,
          isTahzibSalaf.isAcceptableOrUnknown(
              data['is_tahzib_salaf']!, _isTahzibSalafMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
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
      isTahzibSalaf: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_tahzib_salaf'])!,
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color']),
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
  final bool isTahzibSalaf;
  final int? color;
  const Khatmah(
      {required this.id,
      this.name,
      this.currentPage,
      this.startAyahNumber,
      this.endAyahNumber,
      required this.isCompleted,
      required this.daysCount,
      required this.isTahzibSalaf,
      this.color});
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
    map['is_tahzib_salaf'] = Variable<bool>(isTahzibSalaf);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<int>(color);
    }
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
      isTahzibSalaf: Value(isTahzibSalaf),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
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
      isTahzibSalaf: serializer.fromJson<bool>(json['isTahzibSalaf']),
      color: serializer.fromJson<int?>(json['color']),
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
      'isTahzibSalaf': serializer.toJson<bool>(isTahzibSalaf),
      'color': serializer.toJson<int?>(color),
    };
  }

  Khatmah copyWith(
          {int? id,
          Value<String?> name = const Value.absent(),
          Value<int?> currentPage = const Value.absent(),
          Value<int?> startAyahNumber = const Value.absent(),
          Value<int?> endAyahNumber = const Value.absent(),
          bool? isCompleted,
          int? daysCount,
          bool? isTahzibSalaf,
          Value<int?> color = const Value.absent()}) =>
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
        isTahzibSalaf: isTahzibSalaf ?? this.isTahzibSalaf,
        color: color.present ? color.value : this.color,
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
          ..write('daysCount: $daysCount, ')
          ..write('isTahzibSalaf: $isTahzibSalaf, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, currentPage, startAyahNumber,
      endAyahNumber, isCompleted, daysCount, isTahzibSalaf, color);
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
          other.daysCount == this.daysCount &&
          other.isTahzibSalaf == this.isTahzibSalaf &&
          other.color == this.color);
}

class KhatmahsCompanion extends UpdateCompanion<Khatmah> {
  final Value<int> id;
  final Value<String?> name;
  final Value<int?> currentPage;
  final Value<int?> startAyahNumber;
  final Value<int?> endAyahNumber;
  final Value<bool> isCompleted;
  final Value<int> daysCount;
  final Value<bool> isTahzibSalaf;
  final Value<int?> color;
  const KhatmahsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.currentPage = const Value.absent(),
    this.startAyahNumber = const Value.absent(),
    this.endAyahNumber = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.daysCount = const Value.absent(),
    this.isTahzibSalaf = const Value.absent(),
    this.color = const Value.absent(),
  });
  KhatmahsCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.currentPage = const Value.absent(),
    this.startAyahNumber = const Value.absent(),
    this.endAyahNumber = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.daysCount = const Value.absent(),
    this.isTahzibSalaf = const Value.absent(),
    this.color = const Value.absent(),
  });
  static Insertable<Khatmah> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? currentPage,
    Expression<int>? startAyahNumber,
    Expression<int>? endAyahNumber,
    Expression<bool>? isCompleted,
    Expression<int>? daysCount,
    Expression<bool>? isTahzibSalaf,
    Expression<int>? color,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (currentPage != null) 'current_page': currentPage,
      if (startAyahNumber != null) 'start_ayah_number': startAyahNumber,
      if (endAyahNumber != null) 'end_ayah_number': endAyahNumber,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (daysCount != null) 'days_count': daysCount,
      if (isTahzibSalaf != null) 'is_tahzib_salaf': isTahzibSalaf,
      if (color != null) 'color': color,
    });
  }

  KhatmahsCompanion copyWith(
      {Value<int>? id,
      Value<String?>? name,
      Value<int?>? currentPage,
      Value<int?>? startAyahNumber,
      Value<int?>? endAyahNumber,
      Value<bool>? isCompleted,
      Value<int>? daysCount,
      Value<bool>? isTahzibSalaf,
      Value<int?>? color}) {
    return KhatmahsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      currentPage: currentPage ?? this.currentPage,
      startAyahNumber: startAyahNumber ?? this.startAyahNumber,
      endAyahNumber: endAyahNumber ?? this.endAyahNumber,
      isCompleted: isCompleted ?? this.isCompleted,
      daysCount: daysCount ?? this.daysCount,
      isTahzibSalaf: isTahzibSalaf ?? this.isTahzibSalaf,
      color: color ?? this.color,
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
    if (isTahzibSalaf.present) {
      map['is_tahzib_salaf'] = Variable<bool>(isTahzibSalaf.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
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
          ..write('daysCount: $daysCount, ')
          ..write('isTahzibSalaf: $isTahzibSalaf, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }
}

class $KhatmahDaysTable extends KhatmahDays
    with TableInfo<$KhatmahDaysTable, KhatmahDay> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KhatmahDaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _khatmahIdMeta =
      const VerificationMeta('khatmahId');
  @override
  late final GeneratedColumn<int> khatmahId = GeneratedColumn<int>(
      'khatmah_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES khatmahs(id) ON DELETE CASCADE NOT NULL');
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<int> day = GeneratedColumn<int>(
      'day', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
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
  @override
  List<GeneratedColumn> get $columns => [id, khatmahId, day, isCompleted];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'khatmah_days';
  @override
  VerificationContext validateIntegrity(Insertable<KhatmahDay> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('khatmah_id')) {
      context.handle(_khatmahIdMeta,
          khatmahId.isAcceptableOrUnknown(data['khatmah_id']!, _khatmahIdMeta));
    } else if (isInserting) {
      context.missing(_khatmahIdMeta);
    }
    if (data.containsKey('day')) {
      context.handle(
          _dayMeta, day.isAcceptableOrUnknown(data['day']!, _dayMeta));
    } else if (isInserting) {
      context.missing(_dayMeta);
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
  KhatmahDay map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KhatmahDay(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      khatmahId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}khatmah_id'])!,
      day: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}day'])!,
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
    );
  }

  @override
  $KhatmahDaysTable createAlias(String alias) {
    return $KhatmahDaysTable(attachedDatabase, alias);
  }
}

class KhatmahDay extends DataClass implements Insertable<KhatmahDay> {
  final int id;
  final int khatmahId;
  final int day;
  final bool isCompleted;
  const KhatmahDay(
      {required this.id,
      required this.khatmahId,
      required this.day,
      required this.isCompleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['khatmah_id'] = Variable<int>(khatmahId);
    map['day'] = Variable<int>(day);
    map['is_completed'] = Variable<bool>(isCompleted);
    return map;
  }

  KhatmahDaysCompanion toCompanion(bool nullToAbsent) {
    return KhatmahDaysCompanion(
      id: Value(id),
      khatmahId: Value(khatmahId),
      day: Value(day),
      isCompleted: Value(isCompleted),
    );
  }

  factory KhatmahDay.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KhatmahDay(
      id: serializer.fromJson<int>(json['id']),
      khatmahId: serializer.fromJson<int>(json['khatmahId']),
      day: serializer.fromJson<int>(json['day']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'khatmahId': serializer.toJson<int>(khatmahId),
      'day': serializer.toJson<int>(day),
      'isCompleted': serializer.toJson<bool>(isCompleted),
    };
  }

  KhatmahDay copyWith({int? id, int? khatmahId, int? day, bool? isCompleted}) =>
      KhatmahDay(
        id: id ?? this.id,
        khatmahId: khatmahId ?? this.khatmahId,
        day: day ?? this.day,
        isCompleted: isCompleted ?? this.isCompleted,
      );
  @override
  String toString() {
    return (StringBuffer('KhatmahDay(')
          ..write('id: $id, ')
          ..write('khatmahId: $khatmahId, ')
          ..write('day: $day, ')
          ..write('isCompleted: $isCompleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, khatmahId, day, isCompleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KhatmahDay &&
          other.id == this.id &&
          other.khatmahId == this.khatmahId &&
          other.day == this.day &&
          other.isCompleted == this.isCompleted);
}

class KhatmahDaysCompanion extends UpdateCompanion<KhatmahDay> {
  final Value<int> id;
  final Value<int> khatmahId;
  final Value<int> day;
  final Value<bool> isCompleted;
  const KhatmahDaysCompanion({
    this.id = const Value.absent(),
    this.khatmahId = const Value.absent(),
    this.day = const Value.absent(),
    this.isCompleted = const Value.absent(),
  });
  KhatmahDaysCompanion.insert({
    this.id = const Value.absent(),
    required int khatmahId,
    required int day,
    this.isCompleted = const Value.absent(),
  })  : khatmahId = Value(khatmahId),
        day = Value(day);
  static Insertable<KhatmahDay> custom({
    Expression<int>? id,
    Expression<int>? khatmahId,
    Expression<int>? day,
    Expression<bool>? isCompleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (khatmahId != null) 'khatmah_id': khatmahId,
      if (day != null) 'day': day,
      if (isCompleted != null) 'is_completed': isCompleted,
    });
  }

  KhatmahDaysCompanion copyWith(
      {Value<int>? id,
      Value<int>? khatmahId,
      Value<int>? day,
      Value<bool>? isCompleted}) {
    return KhatmahDaysCompanion(
      id: id ?? this.id,
      khatmahId: khatmahId ?? this.khatmahId,
      day: day ?? this.day,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (khatmahId.present) {
      map['khatmah_id'] = Variable<int>(khatmahId.value);
    }
    if (day.present) {
      map['day'] = Variable<int>(day.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KhatmahDaysCompanion(')
          ..write('id: $id, ')
          ..write('khatmahId: $khatmahId, ')
          ..write('day: $day, ')
          ..write('isCompleted: $isCompleted')
          ..write(')'))
        .toString();
  }
}

abstract class _$KhatmahDatabase extends GeneratedDatabase {
  _$KhatmahDatabase(QueryExecutor e) : super(e);
  _$KhatmahDatabaseManager get managers => _$KhatmahDatabaseManager(this);
  late final $KhatmahsTable khatmahs = $KhatmahsTable(this);
  late final $KhatmahDaysTable khatmahDays = $KhatmahDaysTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [khatmahs, khatmahDays];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('khatmahs',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('khatmah_days', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$KhatmahsTableInsertCompanionBuilder = KhatmahsCompanion Function({
  Value<int> id,
  Value<String?> name,
  Value<int?> currentPage,
  Value<int?> startAyahNumber,
  Value<int?> endAyahNumber,
  Value<bool> isCompleted,
  Value<int> daysCount,
  Value<bool> isTahzibSalaf,
  Value<int?> color,
});
typedef $$KhatmahsTableUpdateCompanionBuilder = KhatmahsCompanion Function({
  Value<int> id,
  Value<String?> name,
  Value<int?> currentPage,
  Value<int?> startAyahNumber,
  Value<int?> endAyahNumber,
  Value<bool> isCompleted,
  Value<int> daysCount,
  Value<bool> isTahzibSalaf,
  Value<int?> color,
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
            Value<bool> isTahzibSalaf = const Value.absent(),
            Value<int?> color = const Value.absent(),
          }) =>
              KhatmahsCompanion(
            id: id,
            name: name,
            currentPage: currentPage,
            startAyahNumber: startAyahNumber,
            endAyahNumber: endAyahNumber,
            isCompleted: isCompleted,
            daysCount: daysCount,
            isTahzibSalaf: isTahzibSalaf,
            color: color,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<int?> currentPage = const Value.absent(),
            Value<int?> startAyahNumber = const Value.absent(),
            Value<int?> endAyahNumber = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<int> daysCount = const Value.absent(),
            Value<bool> isTahzibSalaf = const Value.absent(),
            Value<int?> color = const Value.absent(),
          }) =>
              KhatmahsCompanion.insert(
            id: id,
            name: name,
            currentPage: currentPage,
            startAyahNumber: startAyahNumber,
            endAyahNumber: endAyahNumber,
            isCompleted: isCompleted,
            daysCount: daysCount,
            isTahzibSalaf: isTahzibSalaf,
            color: color,
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

  ColumnFilters<bool> get isTahzibSalaf => $state.composableBuilder(
      column: $state.table.isTahzibSalaf,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get color => $state.composableBuilder(
      column: $state.table.color,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter khatmahDaysRefs(
      ComposableFilter Function($$KhatmahDaysTableFilterComposer f) f) {
    final $$KhatmahDaysTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.khatmahDays,
        getReferencedColumn: (t) => t.khatmahId,
        builder: (joinBuilder, parentComposers) =>
            $$KhatmahDaysTableFilterComposer(ComposerState($state.db,
                $state.db.khatmahDays, joinBuilder, parentComposers)));
    return f(composer);
  }
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

  ColumnOrderings<bool> get isTahzibSalaf => $state.composableBuilder(
      column: $state.table.isTahzibSalaf,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get color => $state.composableBuilder(
      column: $state.table.color,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$KhatmahDaysTableInsertCompanionBuilder = KhatmahDaysCompanion
    Function({
  Value<int> id,
  required int khatmahId,
  required int day,
  Value<bool> isCompleted,
});
typedef $$KhatmahDaysTableUpdateCompanionBuilder = KhatmahDaysCompanion
    Function({
  Value<int> id,
  Value<int> khatmahId,
  Value<int> day,
  Value<bool> isCompleted,
});

class $$KhatmahDaysTableTableManager extends RootTableManager<
    _$KhatmahDatabase,
    $KhatmahDaysTable,
    KhatmahDay,
    $$KhatmahDaysTableFilterComposer,
    $$KhatmahDaysTableOrderingComposer,
    $$KhatmahDaysTableProcessedTableManager,
    $$KhatmahDaysTableInsertCompanionBuilder,
    $$KhatmahDaysTableUpdateCompanionBuilder> {
  $$KhatmahDaysTableTableManager(_$KhatmahDatabase db, $KhatmahDaysTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$KhatmahDaysTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$KhatmahDaysTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$KhatmahDaysTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<int> khatmahId = const Value.absent(),
            Value<int> day = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
          }) =>
              KhatmahDaysCompanion(
            id: id,
            khatmahId: khatmahId,
            day: day,
            isCompleted: isCompleted,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required int khatmahId,
            required int day,
            Value<bool> isCompleted = const Value.absent(),
          }) =>
              KhatmahDaysCompanion.insert(
            id: id,
            khatmahId: khatmahId,
            day: day,
            isCompleted: isCompleted,
          ),
        ));
}

class $$KhatmahDaysTableProcessedTableManager extends ProcessedTableManager<
    _$KhatmahDatabase,
    $KhatmahDaysTable,
    KhatmahDay,
    $$KhatmahDaysTableFilterComposer,
    $$KhatmahDaysTableOrderingComposer,
    $$KhatmahDaysTableProcessedTableManager,
    $$KhatmahDaysTableInsertCompanionBuilder,
    $$KhatmahDaysTableUpdateCompanionBuilder> {
  $$KhatmahDaysTableProcessedTableManager(super.$state);
}

class $$KhatmahDaysTableFilterComposer
    extends FilterComposer<_$KhatmahDatabase, $KhatmahDaysTable> {
  $$KhatmahDaysTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get day => $state.composableBuilder(
      column: $state.table.day,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isCompleted => $state.composableBuilder(
      column: $state.table.isCompleted,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$KhatmahsTableFilterComposer get khatmahId {
    final $$KhatmahsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.khatmahId,
        referencedTable: $state.db.khatmahs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$KhatmahsTableFilterComposer(ComposerState(
                $state.db, $state.db.khatmahs, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$KhatmahDaysTableOrderingComposer
    extends OrderingComposer<_$KhatmahDatabase, $KhatmahDaysTable> {
  $$KhatmahDaysTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get day => $state.composableBuilder(
      column: $state.table.day,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isCompleted => $state.composableBuilder(
      column: $state.table.isCompleted,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$KhatmahsTableOrderingComposer get khatmahId {
    final $$KhatmahsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.khatmahId,
        referencedTable: $state.db.khatmahs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$KhatmahsTableOrderingComposer(ComposerState(
                $state.db, $state.db.khatmahs, joinBuilder, parentComposers)));
    return composer;
  }
}

class _$KhatmahDatabaseManager {
  final _$KhatmahDatabase _db;
  _$KhatmahDatabaseManager(this._db);
  $$KhatmahsTableTableManager get khatmahs =>
      $$KhatmahsTableTableManager(_db, _db.khatmahs);
  $$KhatmahDaysTableTableManager get khatmahDays =>
      $$KhatmahDaysTableTableManager(_db, _db.khatmahDays);
}

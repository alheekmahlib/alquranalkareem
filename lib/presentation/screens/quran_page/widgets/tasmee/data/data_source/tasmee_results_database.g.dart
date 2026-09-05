// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasmee_results_database.dart';

// ignore_for_file: type=lint
class $TasmeeResultsTable extends TasmeeResults
    with TableInfo<$TasmeeResultsTable, TasmeeResult> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasmeeResultsTable(this.attachedDatabase, [this._alias]);
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
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('tasmee'),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<int> completedAt = GeneratedColumn<int>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startSuraMeta = const VerificationMeta(
    'startSura',
  );
  @override
  late final GeneratedColumn<int> startSura = GeneratedColumn<int>(
    'start_sura',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startAyaMeta = const VerificationMeta(
    'startAya',
  );
  @override
  late final GeneratedColumn<int> startAya = GeneratedColumn<int>(
    'start_aya',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endSuraMeta = const VerificationMeta(
    'endSura',
  );
  @override
  late final GeneratedColumn<int> endSura = GeneratedColumn<int>(
    'end_sura',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endAyaMeta = const VerificationMeta('endAya');
  @override
  late final GeneratedColumn<int> endAya = GeneratedColumn<int>(
    'end_aya',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalWordsMeta = const VerificationMeta(
    'totalWords',
  );
  @override
  late final GeneratedColumn<int> totalWords = GeneratedColumn<int>(
    'total_words',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _correctWordsMeta = const VerificationMeta(
    'correctWords',
  );
  @override
  late final GeneratedColumn<int> correctWords = GeneratedColumn<int>(
    'correct_words',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _tajweedErrorsMeta = const VerificationMeta(
    'tajweedErrors',
  );
  @override
  late final GeneratedColumn<int> tajweedErrors = GeneratedColumn<int>(
    'tajweed_errors',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _normalErrorsMeta = const VerificationMeta(
    'normalErrors',
  );
  @override
  late final GeneratedColumn<int> normalErrors = GeneratedColumn<int>(
    'normal_errors',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _tashkeelErrorsMeta = const VerificationMeta(
    'tashkeelErrors',
  );
  @override
  late final GeneratedColumn<int> tashkeelErrors = GeneratedColumn<int>(
    'tashkeel_errors',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isFullyCorrectMeta = const VerificationMeta(
    'isFullyCorrect',
  );
  @override
  late final GeneratedColumn<bool> isFullyCorrect = GeneratedColumn<bool>(
    'is_fully_correct',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_fully_correct" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _errorsJsonMeta = const VerificationMeta(
    'errorsJson',
  );
  @override
  late final GeneratedColumn<String> errorsJson = GeneratedColumn<String>(
    'errors_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    pageNumber,
    mode,
    completedAt,
    startSura,
    startAya,
    endSura,
    endAya,
    totalWords,
    correctWords,
    tajweedErrors,
    normalErrors,
    tashkeelErrors,
    isFullyCorrect,
    errorsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasmee_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<TasmeeResult> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('page_number')) {
      context.handle(
        _pageNumberMeta,
        pageNumber.isAcceptableOrUnknown(data['page_number']!, _pageNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_pageNumberMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    if (data.containsKey('start_sura')) {
      context.handle(
        _startSuraMeta,
        startSura.isAcceptableOrUnknown(data['start_sura']!, _startSuraMeta),
      );
    } else if (isInserting) {
      context.missing(_startSuraMeta);
    }
    if (data.containsKey('start_aya')) {
      context.handle(
        _startAyaMeta,
        startAya.isAcceptableOrUnknown(data['start_aya']!, _startAyaMeta),
      );
    } else if (isInserting) {
      context.missing(_startAyaMeta);
    }
    if (data.containsKey('end_sura')) {
      context.handle(
        _endSuraMeta,
        endSura.isAcceptableOrUnknown(data['end_sura']!, _endSuraMeta),
      );
    } else if (isInserting) {
      context.missing(_endSuraMeta);
    }
    if (data.containsKey('end_aya')) {
      context.handle(
        _endAyaMeta,
        endAya.isAcceptableOrUnknown(data['end_aya']!, _endAyaMeta),
      );
    } else if (isInserting) {
      context.missing(_endAyaMeta);
    }
    if (data.containsKey('total_words')) {
      context.handle(
        _totalWordsMeta,
        totalWords.isAcceptableOrUnknown(data['total_words']!, _totalWordsMeta),
      );
    }
    if (data.containsKey('correct_words')) {
      context.handle(
        _correctWordsMeta,
        correctWords.isAcceptableOrUnknown(
          data['correct_words']!,
          _correctWordsMeta,
        ),
      );
    }
    if (data.containsKey('tajweed_errors')) {
      context.handle(
        _tajweedErrorsMeta,
        tajweedErrors.isAcceptableOrUnknown(
          data['tajweed_errors']!,
          _tajweedErrorsMeta,
        ),
      );
    }
    if (data.containsKey('normal_errors')) {
      context.handle(
        _normalErrorsMeta,
        normalErrors.isAcceptableOrUnknown(
          data['normal_errors']!,
          _normalErrorsMeta,
        ),
      );
    }
    if (data.containsKey('tashkeel_errors')) {
      context.handle(
        _tashkeelErrorsMeta,
        tashkeelErrors.isAcceptableOrUnknown(
          data['tashkeel_errors']!,
          _tashkeelErrorsMeta,
        ),
      );
    }
    if (data.containsKey('is_fully_correct')) {
      context.handle(
        _isFullyCorrectMeta,
        isFullyCorrect.isAcceptableOrUnknown(
          data['is_fully_correct']!,
          _isFullyCorrectMeta,
        ),
      );
    }
    if (data.containsKey('errors_json')) {
      context.handle(
        _errorsJsonMeta,
        errorsJson.isAcceptableOrUnknown(data['errors_json']!, _errorsJsonMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TasmeeResult map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TasmeeResult(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      pageNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_number'],
      )!,
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mode'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_at'],
      )!,
      startSura: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_sura'],
      )!,
      startAya: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_aya'],
      )!,
      endSura: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_sura'],
      )!,
      endAya: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_aya'],
      )!,
      totalWords: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_words'],
      )!,
      correctWords: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_words'],
      )!,
      tajweedErrors: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tajweed_errors'],
      )!,
      normalErrors: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}normal_errors'],
      )!,
      tashkeelErrors: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tashkeel_errors'],
      )!,
      isFullyCorrect: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_fully_correct'],
      )!,
      errorsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}errors_json'],
      )!,
    );
  }

  @override
  $TasmeeResultsTable createAlias(String alias) {
    return $TasmeeResultsTable(attachedDatabase, alias);
  }
}

class TasmeeResult extends DataClass implements Insertable<TasmeeResult> {
  final int id;
  final int pageNumber;
  final String mode;
  final int completedAt;
  final int startSura;
  final int startAya;
  final int endSura;
  final int endAya;
  final int totalWords;
  final int correctWords;
  final int tajweedErrors;
  final int normalErrors;
  final int tashkeelErrors;
  final bool isFullyCorrect;
  final String errorsJson;
  const TasmeeResult({
    required this.id,
    required this.pageNumber,
    required this.mode,
    required this.completedAt,
    required this.startSura,
    required this.startAya,
    required this.endSura,
    required this.endAya,
    required this.totalWords,
    required this.correctWords,
    required this.tajweedErrors,
    required this.normalErrors,
    required this.tashkeelErrors,
    required this.isFullyCorrect,
    required this.errorsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['page_number'] = Variable<int>(pageNumber);
    map['mode'] = Variable<String>(mode);
    map['completed_at'] = Variable<int>(completedAt);
    map['start_sura'] = Variable<int>(startSura);
    map['start_aya'] = Variable<int>(startAya);
    map['end_sura'] = Variable<int>(endSura);
    map['end_aya'] = Variable<int>(endAya);
    map['total_words'] = Variable<int>(totalWords);
    map['correct_words'] = Variable<int>(correctWords);
    map['tajweed_errors'] = Variable<int>(tajweedErrors);
    map['normal_errors'] = Variable<int>(normalErrors);
    map['tashkeel_errors'] = Variable<int>(tashkeelErrors);
    map['is_fully_correct'] = Variable<bool>(isFullyCorrect);
    map['errors_json'] = Variable<String>(errorsJson);
    return map;
  }

  TasmeeResultsCompanion toCompanion(bool nullToAbsent) {
    return TasmeeResultsCompanion(
      id: Value(id),
      pageNumber: Value(pageNumber),
      mode: Value(mode),
      completedAt: Value(completedAt),
      startSura: Value(startSura),
      startAya: Value(startAya),
      endSura: Value(endSura),
      endAya: Value(endAya),
      totalWords: Value(totalWords),
      correctWords: Value(correctWords),
      tajweedErrors: Value(tajweedErrors),
      normalErrors: Value(normalErrors),
      tashkeelErrors: Value(tashkeelErrors),
      isFullyCorrect: Value(isFullyCorrect),
      errorsJson: Value(errorsJson),
    );
  }

  factory TasmeeResult.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TasmeeResult(
      id: serializer.fromJson<int>(json['id']),
      pageNumber: serializer.fromJson<int>(json['pageNumber']),
      mode: serializer.fromJson<String>(json['mode']),
      completedAt: serializer.fromJson<int>(json['completedAt']),
      startSura: serializer.fromJson<int>(json['startSura']),
      startAya: serializer.fromJson<int>(json['startAya']),
      endSura: serializer.fromJson<int>(json['endSura']),
      endAya: serializer.fromJson<int>(json['endAya']),
      totalWords: serializer.fromJson<int>(json['totalWords']),
      correctWords: serializer.fromJson<int>(json['correctWords']),
      tajweedErrors: serializer.fromJson<int>(json['tajweedErrors']),
      normalErrors: serializer.fromJson<int>(json['normalErrors']),
      tashkeelErrors: serializer.fromJson<int>(json['tashkeelErrors']),
      isFullyCorrect: serializer.fromJson<bool>(json['isFullyCorrect']),
      errorsJson: serializer.fromJson<String>(json['errorsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pageNumber': serializer.toJson<int>(pageNumber),
      'mode': serializer.toJson<String>(mode),
      'completedAt': serializer.toJson<int>(completedAt),
      'startSura': serializer.toJson<int>(startSura),
      'startAya': serializer.toJson<int>(startAya),
      'endSura': serializer.toJson<int>(endSura),
      'endAya': serializer.toJson<int>(endAya),
      'totalWords': serializer.toJson<int>(totalWords),
      'correctWords': serializer.toJson<int>(correctWords),
      'tajweedErrors': serializer.toJson<int>(tajweedErrors),
      'normalErrors': serializer.toJson<int>(normalErrors),
      'tashkeelErrors': serializer.toJson<int>(tashkeelErrors),
      'isFullyCorrect': serializer.toJson<bool>(isFullyCorrect),
      'errorsJson': serializer.toJson<String>(errorsJson),
    };
  }

  TasmeeResult copyWith({
    int? id,
    int? pageNumber,
    String? mode,
    int? completedAt,
    int? startSura,
    int? startAya,
    int? endSura,
    int? endAya,
    int? totalWords,
    int? correctWords,
    int? tajweedErrors,
    int? normalErrors,
    int? tashkeelErrors,
    bool? isFullyCorrect,
    String? errorsJson,
  }) => TasmeeResult(
    id: id ?? this.id,
    pageNumber: pageNumber ?? this.pageNumber,
    mode: mode ?? this.mode,
    completedAt: completedAt ?? this.completedAt,
    startSura: startSura ?? this.startSura,
    startAya: startAya ?? this.startAya,
    endSura: endSura ?? this.endSura,
    endAya: endAya ?? this.endAya,
    totalWords: totalWords ?? this.totalWords,
    correctWords: correctWords ?? this.correctWords,
    tajweedErrors: tajweedErrors ?? this.tajweedErrors,
    normalErrors: normalErrors ?? this.normalErrors,
    tashkeelErrors: tashkeelErrors ?? this.tashkeelErrors,
    isFullyCorrect: isFullyCorrect ?? this.isFullyCorrect,
    errorsJson: errorsJson ?? this.errorsJson,
  );
  TasmeeResult copyWithCompanion(TasmeeResultsCompanion data) {
    return TasmeeResult(
      id: data.id.present ? data.id.value : this.id,
      pageNumber: data.pageNumber.present
          ? data.pageNumber.value
          : this.pageNumber,
      mode: data.mode.present ? data.mode.value : this.mode,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      startSura: data.startSura.present ? data.startSura.value : this.startSura,
      startAya: data.startAya.present ? data.startAya.value : this.startAya,
      endSura: data.endSura.present ? data.endSura.value : this.endSura,
      endAya: data.endAya.present ? data.endAya.value : this.endAya,
      totalWords: data.totalWords.present
          ? data.totalWords.value
          : this.totalWords,
      correctWords: data.correctWords.present
          ? data.correctWords.value
          : this.correctWords,
      tajweedErrors: data.tajweedErrors.present
          ? data.tajweedErrors.value
          : this.tajweedErrors,
      normalErrors: data.normalErrors.present
          ? data.normalErrors.value
          : this.normalErrors,
      tashkeelErrors: data.tashkeelErrors.present
          ? data.tashkeelErrors.value
          : this.tashkeelErrors,
      isFullyCorrect: data.isFullyCorrect.present
          ? data.isFullyCorrect.value
          : this.isFullyCorrect,
      errorsJson: data.errorsJson.present
          ? data.errorsJson.value
          : this.errorsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TasmeeResult(')
          ..write('id: $id, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('mode: $mode, ')
          ..write('completedAt: $completedAt, ')
          ..write('startSura: $startSura, ')
          ..write('startAya: $startAya, ')
          ..write('endSura: $endSura, ')
          ..write('endAya: $endAya, ')
          ..write('totalWords: $totalWords, ')
          ..write('correctWords: $correctWords, ')
          ..write('tajweedErrors: $tajweedErrors, ')
          ..write('normalErrors: $normalErrors, ')
          ..write('tashkeelErrors: $tashkeelErrors, ')
          ..write('isFullyCorrect: $isFullyCorrect, ')
          ..write('errorsJson: $errorsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    pageNumber,
    mode,
    completedAt,
    startSura,
    startAya,
    endSura,
    endAya,
    totalWords,
    correctWords,
    tajweedErrors,
    normalErrors,
    tashkeelErrors,
    isFullyCorrect,
    errorsJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TasmeeResult &&
          other.id == this.id &&
          other.pageNumber == this.pageNumber &&
          other.mode == this.mode &&
          other.completedAt == this.completedAt &&
          other.startSura == this.startSura &&
          other.startAya == this.startAya &&
          other.endSura == this.endSura &&
          other.endAya == this.endAya &&
          other.totalWords == this.totalWords &&
          other.correctWords == this.correctWords &&
          other.tajweedErrors == this.tajweedErrors &&
          other.normalErrors == this.normalErrors &&
          other.tashkeelErrors == this.tashkeelErrors &&
          other.isFullyCorrect == this.isFullyCorrect &&
          other.errorsJson == this.errorsJson);
}

class TasmeeResultsCompanion extends UpdateCompanion<TasmeeResult> {
  final Value<int> id;
  final Value<int> pageNumber;
  final Value<String> mode;
  final Value<int> completedAt;
  final Value<int> startSura;
  final Value<int> startAya;
  final Value<int> endSura;
  final Value<int> endAya;
  final Value<int> totalWords;
  final Value<int> correctWords;
  final Value<int> tajweedErrors;
  final Value<int> normalErrors;
  final Value<int> tashkeelErrors;
  final Value<bool> isFullyCorrect;
  final Value<String> errorsJson;
  const TasmeeResultsCompanion({
    this.id = const Value.absent(),
    this.pageNumber = const Value.absent(),
    this.mode = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.startSura = const Value.absent(),
    this.startAya = const Value.absent(),
    this.endSura = const Value.absent(),
    this.endAya = const Value.absent(),
    this.totalWords = const Value.absent(),
    this.correctWords = const Value.absent(),
    this.tajweedErrors = const Value.absent(),
    this.normalErrors = const Value.absent(),
    this.tashkeelErrors = const Value.absent(),
    this.isFullyCorrect = const Value.absent(),
    this.errorsJson = const Value.absent(),
  });
  TasmeeResultsCompanion.insert({
    this.id = const Value.absent(),
    required int pageNumber,
    this.mode = const Value.absent(),
    required int completedAt,
    required int startSura,
    required int startAya,
    required int endSura,
    required int endAya,
    this.totalWords = const Value.absent(),
    this.correctWords = const Value.absent(),
    this.tajweedErrors = const Value.absent(),
    this.normalErrors = const Value.absent(),
    this.tashkeelErrors = const Value.absent(),
    this.isFullyCorrect = const Value.absent(),
    this.errorsJson = const Value.absent(),
  }) : pageNumber = Value(pageNumber),
       completedAt = Value(completedAt),
       startSura = Value(startSura),
       startAya = Value(startAya),
       endSura = Value(endSura),
       endAya = Value(endAya);
  static Insertable<TasmeeResult> custom({
    Expression<int>? id,
    Expression<int>? pageNumber,
    Expression<String>? mode,
    Expression<int>? completedAt,
    Expression<int>? startSura,
    Expression<int>? startAya,
    Expression<int>? endSura,
    Expression<int>? endAya,
    Expression<int>? totalWords,
    Expression<int>? correctWords,
    Expression<int>? tajweedErrors,
    Expression<int>? normalErrors,
    Expression<int>? tashkeelErrors,
    Expression<bool>? isFullyCorrect,
    Expression<String>? errorsJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pageNumber != null) 'page_number': pageNumber,
      if (mode != null) 'mode': mode,
      if (completedAt != null) 'completed_at': completedAt,
      if (startSura != null) 'start_sura': startSura,
      if (startAya != null) 'start_aya': startAya,
      if (endSura != null) 'end_sura': endSura,
      if (endAya != null) 'end_aya': endAya,
      if (totalWords != null) 'total_words': totalWords,
      if (correctWords != null) 'correct_words': correctWords,
      if (tajweedErrors != null) 'tajweed_errors': tajweedErrors,
      if (normalErrors != null) 'normal_errors': normalErrors,
      if (tashkeelErrors != null) 'tashkeel_errors': tashkeelErrors,
      if (isFullyCorrect != null) 'is_fully_correct': isFullyCorrect,
      if (errorsJson != null) 'errors_json': errorsJson,
    });
  }

  TasmeeResultsCompanion copyWith({
    Value<int>? id,
    Value<int>? pageNumber,
    Value<String>? mode,
    Value<int>? completedAt,
    Value<int>? startSura,
    Value<int>? startAya,
    Value<int>? endSura,
    Value<int>? endAya,
    Value<int>? totalWords,
    Value<int>? correctWords,
    Value<int>? tajweedErrors,
    Value<int>? normalErrors,
    Value<int>? tashkeelErrors,
    Value<bool>? isFullyCorrect,
    Value<String>? errorsJson,
  }) {
    return TasmeeResultsCompanion(
      id: id ?? this.id,
      pageNumber: pageNumber ?? this.pageNumber,
      mode: mode ?? this.mode,
      completedAt: completedAt ?? this.completedAt,
      startSura: startSura ?? this.startSura,
      startAya: startAya ?? this.startAya,
      endSura: endSura ?? this.endSura,
      endAya: endAya ?? this.endAya,
      totalWords: totalWords ?? this.totalWords,
      correctWords: correctWords ?? this.correctWords,
      tajweedErrors: tajweedErrors ?? this.tajweedErrors,
      normalErrors: normalErrors ?? this.normalErrors,
      tashkeelErrors: tashkeelErrors ?? this.tashkeelErrors,
      isFullyCorrect: isFullyCorrect ?? this.isFullyCorrect,
      errorsJson: errorsJson ?? this.errorsJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pageNumber.present) {
      map['page_number'] = Variable<int>(pageNumber.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<int>(completedAt.value);
    }
    if (startSura.present) {
      map['start_sura'] = Variable<int>(startSura.value);
    }
    if (startAya.present) {
      map['start_aya'] = Variable<int>(startAya.value);
    }
    if (endSura.present) {
      map['end_sura'] = Variable<int>(endSura.value);
    }
    if (endAya.present) {
      map['end_aya'] = Variable<int>(endAya.value);
    }
    if (totalWords.present) {
      map['total_words'] = Variable<int>(totalWords.value);
    }
    if (correctWords.present) {
      map['correct_words'] = Variable<int>(correctWords.value);
    }
    if (tajweedErrors.present) {
      map['tajweed_errors'] = Variable<int>(tajweedErrors.value);
    }
    if (normalErrors.present) {
      map['normal_errors'] = Variable<int>(normalErrors.value);
    }
    if (tashkeelErrors.present) {
      map['tashkeel_errors'] = Variable<int>(tashkeelErrors.value);
    }
    if (isFullyCorrect.present) {
      map['is_fully_correct'] = Variable<bool>(isFullyCorrect.value);
    }
    if (errorsJson.present) {
      map['errors_json'] = Variable<String>(errorsJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasmeeResultsCompanion(')
          ..write('id: $id, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('mode: $mode, ')
          ..write('completedAt: $completedAt, ')
          ..write('startSura: $startSura, ')
          ..write('startAya: $startAya, ')
          ..write('endSura: $endSura, ')
          ..write('endAya: $endAya, ')
          ..write('totalWords: $totalWords, ')
          ..write('correctWords: $correctWords, ')
          ..write('tajweedErrors: $tajweedErrors, ')
          ..write('normalErrors: $normalErrors, ')
          ..write('tashkeelErrors: $tashkeelErrors, ')
          ..write('isFullyCorrect: $isFullyCorrect, ')
          ..write('errorsJson: $errorsJson')
          ..write(')'))
        .toString();
  }
}

abstract class _$TasmeeResultsDatabase extends GeneratedDatabase {
  _$TasmeeResultsDatabase(QueryExecutor e) : super(e);
  $TasmeeResultsDatabaseManager get managers =>
      $TasmeeResultsDatabaseManager(this);
  late final $TasmeeResultsTable tasmeeResults = $TasmeeResultsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [tasmeeResults];
}

typedef $$TasmeeResultsTableCreateCompanionBuilder =
    TasmeeResultsCompanion Function({
      Value<int> id,
      required int pageNumber,
      Value<String> mode,
      required int completedAt,
      required int startSura,
      required int startAya,
      required int endSura,
      required int endAya,
      Value<int> totalWords,
      Value<int> correctWords,
      Value<int> tajweedErrors,
      Value<int> normalErrors,
      Value<int> tashkeelErrors,
      Value<bool> isFullyCorrect,
      Value<String> errorsJson,
    });
typedef $$TasmeeResultsTableUpdateCompanionBuilder =
    TasmeeResultsCompanion Function({
      Value<int> id,
      Value<int> pageNumber,
      Value<String> mode,
      Value<int> completedAt,
      Value<int> startSura,
      Value<int> startAya,
      Value<int> endSura,
      Value<int> endAya,
      Value<int> totalWords,
      Value<int> correctWords,
      Value<int> tajweedErrors,
      Value<int> normalErrors,
      Value<int> tashkeelErrors,
      Value<bool> isFullyCorrect,
      Value<String> errorsJson,
    });

class $$TasmeeResultsTableFilterComposer
    extends Composer<_$TasmeeResultsDatabase, $TasmeeResultsTable> {
  $$TasmeeResultsTableFilterComposer({
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

  ColumnFilters<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startSura => $composableBuilder(
    column: $table.startSura,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startAya => $composableBuilder(
    column: $table.startAya,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endSura => $composableBuilder(
    column: $table.endSura,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endAya => $composableBuilder(
    column: $table.endAya,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalWords => $composableBuilder(
    column: $table.totalWords,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctWords => $composableBuilder(
    column: $table.correctWords,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tajweedErrors => $composableBuilder(
    column: $table.tajweedErrors,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get normalErrors => $composableBuilder(
    column: $table.normalErrors,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tashkeelErrors => $composableBuilder(
    column: $table.tashkeelErrors,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFullyCorrect => $composableBuilder(
    column: $table.isFullyCorrect,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorsJson => $composableBuilder(
    column: $table.errorsJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TasmeeResultsTableOrderingComposer
    extends Composer<_$TasmeeResultsDatabase, $TasmeeResultsTable> {
  $$TasmeeResultsTableOrderingComposer({
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

  ColumnOrderings<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startSura => $composableBuilder(
    column: $table.startSura,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startAya => $composableBuilder(
    column: $table.startAya,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endSura => $composableBuilder(
    column: $table.endSura,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endAya => $composableBuilder(
    column: $table.endAya,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalWords => $composableBuilder(
    column: $table.totalWords,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctWords => $composableBuilder(
    column: $table.correctWords,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tajweedErrors => $composableBuilder(
    column: $table.tajweedErrors,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get normalErrors => $composableBuilder(
    column: $table.normalErrors,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tashkeelErrors => $composableBuilder(
    column: $table.tashkeelErrors,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFullyCorrect => $composableBuilder(
    column: $table.isFullyCorrect,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorsJson => $composableBuilder(
    column: $table.errorsJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TasmeeResultsTableAnnotationComposer
    extends Composer<_$TasmeeResultsDatabase, $TasmeeResultsTable> {
  $$TasmeeResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<int> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startSura =>
      $composableBuilder(column: $table.startSura, builder: (column) => column);

  GeneratedColumn<int> get startAya =>
      $composableBuilder(column: $table.startAya, builder: (column) => column);

  GeneratedColumn<int> get endSura =>
      $composableBuilder(column: $table.endSura, builder: (column) => column);

  GeneratedColumn<int> get endAya =>
      $composableBuilder(column: $table.endAya, builder: (column) => column);

  GeneratedColumn<int> get totalWords => $composableBuilder(
    column: $table.totalWords,
    builder: (column) => column,
  );

  GeneratedColumn<int> get correctWords => $composableBuilder(
    column: $table.correctWords,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tajweedErrors => $composableBuilder(
    column: $table.tajweedErrors,
    builder: (column) => column,
  );

  GeneratedColumn<int> get normalErrors => $composableBuilder(
    column: $table.normalErrors,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tashkeelErrors => $composableBuilder(
    column: $table.tashkeelErrors,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFullyCorrect => $composableBuilder(
    column: $table.isFullyCorrect,
    builder: (column) => column,
  );

  GeneratedColumn<String> get errorsJson => $composableBuilder(
    column: $table.errorsJson,
    builder: (column) => column,
  );
}

class $$TasmeeResultsTableTableManager
    extends
        RootTableManager<
          _$TasmeeResultsDatabase,
          $TasmeeResultsTable,
          TasmeeResult,
          $$TasmeeResultsTableFilterComposer,
          $$TasmeeResultsTableOrderingComposer,
          $$TasmeeResultsTableAnnotationComposer,
          $$TasmeeResultsTableCreateCompanionBuilder,
          $$TasmeeResultsTableUpdateCompanionBuilder,
          (
            TasmeeResult,
            BaseReferences<
              _$TasmeeResultsDatabase,
              $TasmeeResultsTable,
              TasmeeResult
            >,
          ),
          TasmeeResult,
          PrefetchHooks Function()
        > {
  $$TasmeeResultsTableTableManager(
    _$TasmeeResultsDatabase db,
    $TasmeeResultsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasmeeResultsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasmeeResultsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasmeeResultsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> pageNumber = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<int> completedAt = const Value.absent(),
                Value<int> startSura = const Value.absent(),
                Value<int> startAya = const Value.absent(),
                Value<int> endSura = const Value.absent(),
                Value<int> endAya = const Value.absent(),
                Value<int> totalWords = const Value.absent(),
                Value<int> correctWords = const Value.absent(),
                Value<int> tajweedErrors = const Value.absent(),
                Value<int> normalErrors = const Value.absent(),
                Value<int> tashkeelErrors = const Value.absent(),
                Value<bool> isFullyCorrect = const Value.absent(),
                Value<String> errorsJson = const Value.absent(),
              }) => TasmeeResultsCompanion(
                id: id,
                pageNumber: pageNumber,
                mode: mode,
                completedAt: completedAt,
                startSura: startSura,
                startAya: startAya,
                endSura: endSura,
                endAya: endAya,
                totalWords: totalWords,
                correctWords: correctWords,
                tajweedErrors: tajweedErrors,
                normalErrors: normalErrors,
                tashkeelErrors: tashkeelErrors,
                isFullyCorrect: isFullyCorrect,
                errorsJson: errorsJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int pageNumber,
                Value<String> mode = const Value.absent(),
                required int completedAt,
                required int startSura,
                required int startAya,
                required int endSura,
                required int endAya,
                Value<int> totalWords = const Value.absent(),
                Value<int> correctWords = const Value.absent(),
                Value<int> tajweedErrors = const Value.absent(),
                Value<int> normalErrors = const Value.absent(),
                Value<int> tashkeelErrors = const Value.absent(),
                Value<bool> isFullyCorrect = const Value.absent(),
                Value<String> errorsJson = const Value.absent(),
              }) => TasmeeResultsCompanion.insert(
                id: id,
                pageNumber: pageNumber,
                mode: mode,
                completedAt: completedAt,
                startSura: startSura,
                startAya: startAya,
                endSura: endSura,
                endAya: endAya,
                totalWords: totalWords,
                correctWords: correctWords,
                tajweedErrors: tajweedErrors,
                normalErrors: normalErrors,
                tashkeelErrors: tashkeelErrors,
                isFullyCorrect: isFullyCorrect,
                errorsJson: errorsJson,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TasmeeResultsTableProcessedTableManager =
    ProcessedTableManager<
      _$TasmeeResultsDatabase,
      $TasmeeResultsTable,
      TasmeeResult,
      $$TasmeeResultsTableFilterComposer,
      $$TasmeeResultsTableOrderingComposer,
      $$TasmeeResultsTableAnnotationComposer,
      $$TasmeeResultsTableCreateCompanionBuilder,
      $$TasmeeResultsTableUpdateCompanionBuilder,
      (
        TasmeeResult,
        BaseReferences<
          _$TasmeeResultsDatabase,
          $TasmeeResultsTable,
          TasmeeResult
        >,
      ),
      TasmeeResult,
      PrefetchHooks Function()
    >;

class $TasmeeResultsDatabaseManager {
  final _$TasmeeResultsDatabase _db;
  $TasmeeResultsDatabaseManager(this._db);
  $$TasmeeResultsTableTableManager get tasmeeResults =>
      $$TasmeeResultsTableTableManager(_db, _db.tasmeeResults);
}

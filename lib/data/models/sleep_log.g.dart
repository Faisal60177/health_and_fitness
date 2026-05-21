// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sleep_log.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSleepLogCollection on Isar {
  IsarCollection<SleepLog> get sleepLogs => this.collection();
}

const SleepLogSchema = CollectionSchema(
  name: r'SleepLog',
  id: 7895731279694127521,
  properties: {
    r'bedTime': PropertySchema(
      id: 0,
      name: r'bedTime',
      type: IsarType.dateTime,
    ),
    r'date': PropertySchema(
      id: 1,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'durationFormatted': PropertySchema(
      id: 2,
      name: r'durationFormatted',
      type: IsarType.string,
    ),
    r'durationHours': PropertySchema(
      id: 3,
      name: r'durationHours',
      type: IsarType.double,
    ),
    r'notes': PropertySchema(
      id: 4,
      name: r'notes',
      type: IsarType.string,
    ),
    r'qualityLabel': PropertySchema(
      id: 5,
      name: r'qualityLabel',
      type: IsarType.string,
    ),
    r'qualityRating': PropertySchema(
      id: 6,
      name: r'qualityRating',
      type: IsarType.long,
    ),
    r'uid': PropertySchema(
      id: 7,
      name: r'uid',
      type: IsarType.string,
    ),
    r'wakeTime': PropertySchema(
      id: 8,
      name: r'wakeTime',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _sleepLogEstimateSize,
  serialize: _sleepLogSerialize,
  deserialize: _sleepLogDeserialize,
  deserializeProp: _sleepLogDeserializeProp,
  idName: r'id',
  indexes: {
    r'uid': IndexSchema(
      id: 8193695471701937315,
      name: r'uid',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'uid',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _sleepLogGetId,
  getLinks: _sleepLogGetLinks,
  attach: _sleepLogAttach,
  version: '3.1.0+1',
);

int _sleepLogEstimateSize(
  SleepLog object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.durationFormatted.length * 3;
  bytesCount += 3 + object.notes.length * 3;
  bytesCount += 3 + object.qualityLabel.length * 3;
  bytesCount += 3 + object.uid.length * 3;
  return bytesCount;
}

void _sleepLogSerialize(
  SleepLog object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.bedTime);
  writer.writeDateTime(offsets[1], object.date);
  writer.writeString(offsets[2], object.durationFormatted);
  writer.writeDouble(offsets[3], object.durationHours);
  writer.writeString(offsets[4], object.notes);
  writer.writeString(offsets[5], object.qualityLabel);
  writer.writeLong(offsets[6], object.qualityRating);
  writer.writeString(offsets[7], object.uid);
  writer.writeDateTime(offsets[8], object.wakeTime);
}

SleepLog _sleepLogDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SleepLog();
  object.bedTime = reader.readDateTime(offsets[0]);
  object.date = reader.readDateTime(offsets[1]);
  object.id = id;
  object.notes = reader.readString(offsets[4]);
  object.qualityRating = reader.readLong(offsets[6]);
  object.uid = reader.readString(offsets[7]);
  object.wakeTime = reader.readDateTime(offsets[8]);
  return object;
}

P _sleepLogDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _sleepLogGetId(SleepLog object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _sleepLogGetLinks(SleepLog object) {
  return [];
}

void _sleepLogAttach(IsarCollection<dynamic> col, Id id, SleepLog object) {
  object.id = id;
}

extension SleepLogQueryWhereSort on QueryBuilder<SleepLog, SleepLog, QWhere> {
  QueryBuilder<SleepLog, SleepLog, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SleepLogQueryWhere on QueryBuilder<SleepLog, SleepLog, QWhereClause> {
  QueryBuilder<SleepLog, SleepLog, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterWhereClause> uidEqualTo(String uid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uid',
        value: [uid],
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterWhereClause> uidNotEqualTo(
      String uid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uid',
              lower: [],
              upper: [uid],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uid',
              lower: [uid],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uid',
              lower: [uid],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uid',
              lower: [],
              upper: [uid],
              includeUpper: false,
            ));
      }
    });
  }
}

extension SleepLogQueryFilter
    on QueryBuilder<SleepLog, SleepLog, QFilterCondition> {
  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> bedTimeEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> bedTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> bedTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> bedTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bedTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition>
      durationFormattedEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationFormatted',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition>
      durationFormattedGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationFormatted',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition>
      durationFormattedLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationFormatted',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition>
      durationFormattedBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationFormatted',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition>
      durationFormattedStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'durationFormatted',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition>
      durationFormattedEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'durationFormatted',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition>
      durationFormattedContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'durationFormatted',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition>
      durationFormattedMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'durationFormatted',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition>
      durationFormattedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationFormatted',
        value: '',
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition>
      durationFormattedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'durationFormatted',
        value: '',
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> durationHoursEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationHours',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition>
      durationHoursGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationHours',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> durationHoursLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationHours',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> durationHoursBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationHours',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> notesEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> notesGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> notesLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> notesBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> notesContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> notesMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> qualityLabelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'qualityLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition>
      qualityLabelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'qualityLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> qualityLabelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'qualityLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> qualityLabelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'qualityLabel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition>
      qualityLabelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'qualityLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> qualityLabelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'qualityLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> qualityLabelContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'qualityLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> qualityLabelMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'qualityLabel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition>
      qualityLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'qualityLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition>
      qualityLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'qualityLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> qualityRatingEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'qualityRating',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition>
      qualityRatingGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'qualityRating',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> qualityRatingLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'qualityRating',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> qualityRatingBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'qualityRating',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> uidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> uidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> uidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> uidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> uidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> uidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> uidContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> uidMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> uidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uid',
        value: '',
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> uidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uid',
        value: '',
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> wakeTimeEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wakeTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> wakeTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wakeTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> wakeTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wakeTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> wakeTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wakeTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SleepLogQueryObject
    on QueryBuilder<SleepLog, SleepLog, QFilterCondition> {}

extension SleepLogQueryLinks
    on QueryBuilder<SleepLog, SleepLog, QFilterCondition> {}

extension SleepLogQuerySortBy on QueryBuilder<SleepLog, SleepLog, QSortBy> {
  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> sortByBedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bedTime', Sort.asc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> sortByBedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bedTime', Sort.desc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> sortByDurationFormatted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationFormatted', Sort.asc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> sortByDurationFormattedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationFormatted', Sort.desc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> sortByDurationHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationHours', Sort.asc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> sortByDurationHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationHours', Sort.desc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> sortByQualityLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qualityLabel', Sort.asc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> sortByQualityLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qualityLabel', Sort.desc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> sortByQualityRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qualityRating', Sort.asc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> sortByQualityRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qualityRating', Sort.desc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> sortByUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.asc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> sortByUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.desc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> sortByWakeTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakeTime', Sort.asc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> sortByWakeTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakeTime', Sort.desc);
    });
  }
}

extension SleepLogQuerySortThenBy
    on QueryBuilder<SleepLog, SleepLog, QSortThenBy> {
  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> thenByBedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bedTime', Sort.asc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> thenByBedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bedTime', Sort.desc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> thenByDurationFormatted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationFormatted', Sort.asc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> thenByDurationFormattedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationFormatted', Sort.desc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> thenByDurationHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationHours', Sort.asc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> thenByDurationHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationHours', Sort.desc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> thenByQualityLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qualityLabel', Sort.asc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> thenByQualityLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qualityLabel', Sort.desc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> thenByQualityRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qualityRating', Sort.asc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> thenByQualityRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qualityRating', Sort.desc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> thenByUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.asc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> thenByUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.desc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> thenByWakeTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakeTime', Sort.asc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> thenByWakeTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakeTime', Sort.desc);
    });
  }
}

extension SleepLogQueryWhereDistinct
    on QueryBuilder<SleepLog, SleepLog, QDistinct> {
  QueryBuilder<SleepLog, SleepLog, QDistinct> distinctByBedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bedTime');
    });
  }

  QueryBuilder<SleepLog, SleepLog, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<SleepLog, SleepLog, QDistinct> distinctByDurationFormatted(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationFormatted',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QDistinct> distinctByDurationHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationHours');
    });
  }

  QueryBuilder<SleepLog, SleepLog, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QDistinct> distinctByQualityLabel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'qualityLabel', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QDistinct> distinctByQualityRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'qualityRating');
    });
  }

  QueryBuilder<SleepLog, SleepLog, QDistinct> distinctByUid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QDistinct> distinctByWakeTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wakeTime');
    });
  }
}

extension SleepLogQueryProperty
    on QueryBuilder<SleepLog, SleepLog, QQueryProperty> {
  QueryBuilder<SleepLog, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SleepLog, DateTime, QQueryOperations> bedTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bedTime');
    });
  }

  QueryBuilder<SleepLog, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<SleepLog, String, QQueryOperations> durationFormattedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationFormatted');
    });
  }

  QueryBuilder<SleepLog, double, QQueryOperations> durationHoursProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationHours');
    });
  }

  QueryBuilder<SleepLog, String, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<SleepLog, String, QQueryOperations> qualityLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'qualityLabel');
    });
  }

  QueryBuilder<SleepLog, int, QQueryOperations> qualityRatingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'qualityRating');
    });
  }

  QueryBuilder<SleepLog, String, QQueryOperations> uidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uid');
    });
  }

  QueryBuilder<SleepLog, DateTime, QQueryOperations> wakeTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wakeTime');
    });
  }
}

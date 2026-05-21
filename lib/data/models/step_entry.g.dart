// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step_entry.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStepEntryCollection on Isar {
  IsarCollection<StepEntry> get stepEntrys => this.collection();
}

const StepEntrySchema = CollectionSchema(
  name: r'StepEntry',
  id: -5666541274760091030,
  properties: {
    r'briskPercent': PropertySchema(
      id: 0,
      name: r'briskPercent',
      type: IsarType.double,
    ),
    r'briskSteps': PropertySchema(
      id: 1,
      name: r'briskSteps',
      type: IsarType.long,
    ),
    r'caloriesBurned': PropertySchema(
      id: 2,
      name: r'caloriesBurned',
      type: IsarType.double,
    ),
    r'dailyGoal': PropertySchema(
      id: 3,
      name: r'dailyGoal',
      type: IsarType.long,
    ),
    r'date': PropertySchema(
      id: 4,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'distanceKm': PropertySchema(
      id: 5,
      name: r'distanceKm',
      type: IsarType.double,
    ),
    r'goalReached': PropertySchema(
      id: 6,
      name: r'goalReached',
      type: IsarType.bool,
    ),
    r'progressPercent': PropertySchema(
      id: 7,
      name: r'progressPercent',
      type: IsarType.double,
    ),
    r'slowPercent': PropertySchema(
      id: 8,
      name: r'slowPercent',
      type: IsarType.double,
    ),
    r'slowSteps': PropertySchema(
      id: 9,
      name: r'slowSteps',
      type: IsarType.long,
    ),
    r'stepCount': PropertySchema(
      id: 10,
      name: r'stepCount',
      type: IsarType.long,
    ),
    r'strideMeters': PropertySchema(
      id: 11,
      name: r'strideMeters',
      type: IsarType.double,
    ),
    r'uid': PropertySchema(
      id: 12,
      name: r'uid',
      type: IsarType.string,
    )
  },
  estimateSize: _stepEntryEstimateSize,
  serialize: _stepEntrySerialize,
  deserialize: _stepEntryDeserialize,
  deserializeProp: _stepEntryDeserializeProp,
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
  getId: _stepEntryGetId,
  getLinks: _stepEntryGetLinks,
  attach: _stepEntryAttach,
  version: '3.1.0+1',
);

int _stepEntryEstimateSize(
  StepEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.uid.length * 3;
  return bytesCount;
}

void _stepEntrySerialize(
  StepEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.briskPercent);
  writer.writeLong(offsets[1], object.briskSteps);
  writer.writeDouble(offsets[2], object.caloriesBurned);
  writer.writeLong(offsets[3], object.dailyGoal);
  writer.writeDateTime(offsets[4], object.date);
  writer.writeDouble(offsets[5], object.distanceKm);
  writer.writeBool(offsets[6], object.goalReached);
  writer.writeDouble(offsets[7], object.progressPercent);
  writer.writeDouble(offsets[8], object.slowPercent);
  writer.writeLong(offsets[9], object.slowSteps);
  writer.writeLong(offsets[10], object.stepCount);
  writer.writeDouble(offsets[11], object.strideMeters);
  writer.writeString(offsets[12], object.uid);
}

StepEntry _stepEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StepEntry();
  object.briskSteps = reader.readLong(offsets[1]);
  object.dailyGoal = reader.readLong(offsets[3]);
  object.date = reader.readDateTime(offsets[4]);
  object.id = id;
  object.slowSteps = reader.readLong(offsets[9]);
  object.stepCount = reader.readLong(offsets[10]);
  object.strideMeters = reader.readDouble(offsets[11]);
  object.uid = reader.readString(offsets[12]);
  return object;
}

P _stepEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readDouble(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _stepEntryGetId(StepEntry object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _stepEntryGetLinks(StepEntry object) {
  return [];
}

void _stepEntryAttach(IsarCollection<dynamic> col, Id id, StepEntry object) {
  object.id = id;
}

extension StepEntryQueryWhereSort
    on QueryBuilder<StepEntry, StepEntry, QWhere> {
  QueryBuilder<StepEntry, StepEntry, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension StepEntryQueryWhere
    on QueryBuilder<StepEntry, StepEntry, QWhereClause> {
  QueryBuilder<StepEntry, StepEntry, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<StepEntry, StepEntry, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterWhereClause> idBetween(
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

  QueryBuilder<StepEntry, StepEntry, QAfterWhereClause> uidEqualTo(String uid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uid',
        value: [uid],
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterWhereClause> uidNotEqualTo(
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

extension StepEntryQueryFilter
    on QueryBuilder<StepEntry, StepEntry, QFilterCondition> {
  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> briskPercentEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'briskPercent',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition>
      briskPercentGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'briskPercent',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition>
      briskPercentLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'briskPercent',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> briskPercentBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'briskPercent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> briskStepsEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'briskSteps',
        value: value,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition>
      briskStepsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'briskSteps',
        value: value,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> briskStepsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'briskSteps',
        value: value,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> briskStepsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'briskSteps',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition>
      caloriesBurnedEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'caloriesBurned',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition>
      caloriesBurnedGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'caloriesBurned',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition>
      caloriesBurnedLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'caloriesBurned',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition>
      caloriesBurnedBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'caloriesBurned',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> dailyGoalEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailyGoal',
        value: value,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition>
      dailyGoalGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dailyGoal',
        value: value,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> dailyGoalLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dailyGoal',
        value: value,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> dailyGoalBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dailyGoal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> dateGreaterThan(
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

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> dateLessThan(
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

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> dateBetween(
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

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> distanceKmEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'distanceKm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition>
      distanceKmGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'distanceKm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> distanceKmLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'distanceKm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> distanceKmBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'distanceKm',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> goalReachedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'goalReached',
        value: value,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> idBetween(
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

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition>
      progressPercentEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'progressPercent',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition>
      progressPercentGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'progressPercent',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition>
      progressPercentLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'progressPercent',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition>
      progressPercentBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'progressPercent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> slowPercentEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slowPercent',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition>
      slowPercentGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'slowPercent',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> slowPercentLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'slowPercent',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> slowPercentBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'slowPercent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> slowStepsEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slowSteps',
        value: value,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition>
      slowStepsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'slowSteps',
        value: value,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> slowStepsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'slowSteps',
        value: value,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> slowStepsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'slowSteps',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> stepCountEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stepCount',
        value: value,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition>
      stepCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stepCount',
        value: value,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> stepCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stepCount',
        value: value,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> stepCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stepCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> strideMetersEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'strideMeters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition>
      strideMetersGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'strideMeters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition>
      strideMetersLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'strideMeters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> strideMetersBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'strideMeters',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> uidEqualTo(
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

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> uidGreaterThan(
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

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> uidLessThan(
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

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> uidBetween(
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

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> uidStartsWith(
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

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> uidEndsWith(
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

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> uidContains(
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

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> uidMatches(
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

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> uidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uid',
        value: '',
      ));
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterFilterCondition> uidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uid',
        value: '',
      ));
    });
  }
}

extension StepEntryQueryObject
    on QueryBuilder<StepEntry, StepEntry, QFilterCondition> {}

extension StepEntryQueryLinks
    on QueryBuilder<StepEntry, StepEntry, QFilterCondition> {}

extension StepEntryQuerySortBy on QueryBuilder<StepEntry, StepEntry, QSortBy> {
  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> sortByBriskPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'briskPercent', Sort.asc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> sortByBriskPercentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'briskPercent', Sort.desc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> sortByBriskSteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'briskSteps', Sort.asc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> sortByBriskStepsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'briskSteps', Sort.desc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> sortByCaloriesBurned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'caloriesBurned', Sort.asc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> sortByCaloriesBurnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'caloriesBurned', Sort.desc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> sortByDailyGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyGoal', Sort.asc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> sortByDailyGoalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyGoal', Sort.desc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> sortByDistanceKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distanceKm', Sort.asc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> sortByDistanceKmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distanceKm', Sort.desc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> sortByGoalReached() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalReached', Sort.asc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> sortByGoalReachedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalReached', Sort.desc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> sortByProgressPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressPercent', Sort.asc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> sortByProgressPercentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressPercent', Sort.desc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> sortBySlowPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slowPercent', Sort.asc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> sortBySlowPercentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slowPercent', Sort.desc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> sortBySlowSteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slowSteps', Sort.asc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> sortBySlowStepsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slowSteps', Sort.desc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> sortByStepCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stepCount', Sort.asc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> sortByStepCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stepCount', Sort.desc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> sortByStrideMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'strideMeters', Sort.asc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> sortByStrideMetersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'strideMeters', Sort.desc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> sortByUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.asc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> sortByUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.desc);
    });
  }
}

extension StepEntryQuerySortThenBy
    on QueryBuilder<StepEntry, StepEntry, QSortThenBy> {
  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> thenByBriskPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'briskPercent', Sort.asc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> thenByBriskPercentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'briskPercent', Sort.desc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> thenByBriskSteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'briskSteps', Sort.asc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> thenByBriskStepsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'briskSteps', Sort.desc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> thenByCaloriesBurned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'caloriesBurned', Sort.asc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> thenByCaloriesBurnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'caloriesBurned', Sort.desc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> thenByDailyGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyGoal', Sort.asc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> thenByDailyGoalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyGoal', Sort.desc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> thenByDistanceKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distanceKm', Sort.asc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> thenByDistanceKmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distanceKm', Sort.desc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> thenByGoalReached() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalReached', Sort.asc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> thenByGoalReachedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalReached', Sort.desc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> thenByProgressPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressPercent', Sort.asc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> thenByProgressPercentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressPercent', Sort.desc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> thenBySlowPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slowPercent', Sort.asc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> thenBySlowPercentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slowPercent', Sort.desc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> thenBySlowSteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slowSteps', Sort.asc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> thenBySlowStepsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slowSteps', Sort.desc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> thenByStepCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stepCount', Sort.asc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> thenByStepCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stepCount', Sort.desc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> thenByStrideMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'strideMeters', Sort.asc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> thenByStrideMetersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'strideMeters', Sort.desc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> thenByUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.asc);
    });
  }

  QueryBuilder<StepEntry, StepEntry, QAfterSortBy> thenByUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.desc);
    });
  }
}

extension StepEntryQueryWhereDistinct
    on QueryBuilder<StepEntry, StepEntry, QDistinct> {
  QueryBuilder<StepEntry, StepEntry, QDistinct> distinctByBriskPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'briskPercent');
    });
  }

  QueryBuilder<StepEntry, StepEntry, QDistinct> distinctByBriskSteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'briskSteps');
    });
  }

  QueryBuilder<StepEntry, StepEntry, QDistinct> distinctByCaloriesBurned() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'caloriesBurned');
    });
  }

  QueryBuilder<StepEntry, StepEntry, QDistinct> distinctByDailyGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailyGoal');
    });
  }

  QueryBuilder<StepEntry, StepEntry, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<StepEntry, StepEntry, QDistinct> distinctByDistanceKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'distanceKm');
    });
  }

  QueryBuilder<StepEntry, StepEntry, QDistinct> distinctByGoalReached() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'goalReached');
    });
  }

  QueryBuilder<StepEntry, StepEntry, QDistinct> distinctByProgressPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'progressPercent');
    });
  }

  QueryBuilder<StepEntry, StepEntry, QDistinct> distinctBySlowPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'slowPercent');
    });
  }

  QueryBuilder<StepEntry, StepEntry, QDistinct> distinctBySlowSteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'slowSteps');
    });
  }

  QueryBuilder<StepEntry, StepEntry, QDistinct> distinctByStepCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stepCount');
    });
  }

  QueryBuilder<StepEntry, StepEntry, QDistinct> distinctByStrideMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'strideMeters');
    });
  }

  QueryBuilder<StepEntry, StepEntry, QDistinct> distinctByUid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uid', caseSensitive: caseSensitive);
    });
  }
}

extension StepEntryQueryProperty
    on QueryBuilder<StepEntry, StepEntry, QQueryProperty> {
  QueryBuilder<StepEntry, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<StepEntry, double, QQueryOperations> briskPercentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'briskPercent');
    });
  }

  QueryBuilder<StepEntry, int, QQueryOperations> briskStepsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'briskSteps');
    });
  }

  QueryBuilder<StepEntry, double, QQueryOperations> caloriesBurnedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'caloriesBurned');
    });
  }

  QueryBuilder<StepEntry, int, QQueryOperations> dailyGoalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailyGoal');
    });
  }

  QueryBuilder<StepEntry, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<StepEntry, double, QQueryOperations> distanceKmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'distanceKm');
    });
  }

  QueryBuilder<StepEntry, bool, QQueryOperations> goalReachedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'goalReached');
    });
  }

  QueryBuilder<StepEntry, double, QQueryOperations> progressPercentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'progressPercent');
    });
  }

  QueryBuilder<StepEntry, double, QQueryOperations> slowPercentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'slowPercent');
    });
  }

  QueryBuilder<StepEntry, int, QQueryOperations> slowStepsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'slowSteps');
    });
  }

  QueryBuilder<StepEntry, int, QQueryOperations> stepCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stepCount');
    });
  }

  QueryBuilder<StepEntry, double, QQueryOperations> strideMetersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'strideMeters');
    });
  }

  QueryBuilder<StepEntry, String, QQueryOperations> uidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uid');
    });
  }
}

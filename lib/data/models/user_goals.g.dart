// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_goals.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserGoalsCollection on Isar {
  IsarCollection<UserGoals> get userGoals => this.collection();
}

const UserGoalsSchema = CollectionSchema(
  name: r'UserGoals',
  id: 7313399927691600726,
  properties: {
    r'dailyCalorieTarget': PropertySchema(
      id: 0,
      name: r'dailyCalorieTarget',
      type: IsarType.long,
    ),
    r'dailyStepGoal': PropertySchema(
      id: 1,
      name: r'dailyStepGoal',
      type: IsarType.long,
    ),
    r'dailyWaterMl': PropertySchema(
      id: 2,
      name: r'dailyWaterMl',
      type: IsarType.long,
    ),
    r'strideLengthM': PropertySchema(
      id: 3,
      name: r'strideLengthM',
      type: IsarType.double,
    ),
    r'targetWeightKg': PropertySchema(
      id: 4,
      name: r'targetWeightKg',
      type: IsarType.double,
    ),
    r'uid': PropertySchema(
      id: 5,
      name: r'uid',
      type: IsarType.string,
    ),
    r'weeklyRunDays': PropertySchema(
      id: 6,
      name: r'weeklyRunDays',
      type: IsarType.long,
    ),
    r'weeklyRunningKm': PropertySchema(
      id: 7,
      name: r'weeklyRunningKm',
      type: IsarType.long,
    )
  },
  estimateSize: _userGoalsEstimateSize,
  serialize: _userGoalsSerialize,
  deserialize: _userGoalsDeserialize,
  deserializeProp: _userGoalsDeserializeProp,
  idName: r'id',
  indexes: {
    r'uid': IndexSchema(
      id: 8193695471701937315,
      name: r'uid',
      unique: true,
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
  getId: _userGoalsGetId,
  getLinks: _userGoalsGetLinks,
  attach: _userGoalsAttach,
  version: '3.1.0+1',
);

int _userGoalsEstimateSize(
  UserGoals object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.uid.length * 3;
  return bytesCount;
}

void _userGoalsSerialize(
  UserGoals object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.dailyCalorieTarget);
  writer.writeLong(offsets[1], object.dailyStepGoal);
  writer.writeLong(offsets[2], object.dailyWaterMl);
  writer.writeDouble(offsets[3], object.strideLengthM);
  writer.writeDouble(offsets[4], object.targetWeightKg);
  writer.writeString(offsets[5], object.uid);
  writer.writeLong(offsets[6], object.weeklyRunDays);
  writer.writeLong(offsets[7], object.weeklyRunningKm);
}

UserGoals _userGoalsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserGoals();
  object.dailyCalorieTarget = reader.readLong(offsets[0]);
  object.dailyStepGoal = reader.readLong(offsets[1]);
  object.dailyWaterMl = reader.readLong(offsets[2]);
  object.id = id;
  object.strideLengthM = reader.readDouble(offsets[3]);
  object.targetWeightKg = reader.readDouble(offsets[4]);
  object.uid = reader.readString(offsets[5]);
  object.weeklyRunDays = reader.readLong(offsets[6]);
  object.weeklyRunningKm = reader.readLong(offsets[7]);
  return object;
}

P _userGoalsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userGoalsGetId(UserGoals object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userGoalsGetLinks(UserGoals object) {
  return [];
}

void _userGoalsAttach(IsarCollection<dynamic> col, Id id, UserGoals object) {
  object.id = id;
}

extension UserGoalsByIndex on IsarCollection<UserGoals> {
  Future<UserGoals?> getByUid(String uid) {
    return getByIndex(r'uid', [uid]);
  }

  UserGoals? getByUidSync(String uid) {
    return getByIndexSync(r'uid', [uid]);
  }

  Future<bool> deleteByUid(String uid) {
    return deleteByIndex(r'uid', [uid]);
  }

  bool deleteByUidSync(String uid) {
    return deleteByIndexSync(r'uid', [uid]);
  }

  Future<List<UserGoals?>> getAllByUid(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return getAllByIndex(r'uid', values);
  }

  List<UserGoals?> getAllByUidSync(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'uid', values);
  }

  Future<int> deleteAllByUid(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'uid', values);
  }

  int deleteAllByUidSync(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'uid', values);
  }

  Future<Id> putByUid(UserGoals object) {
    return putByIndex(r'uid', object);
  }

  Id putByUidSync(UserGoals object, {bool saveLinks = true}) {
    return putByIndexSync(r'uid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUid(List<UserGoals> objects) {
    return putAllByIndex(r'uid', objects);
  }

  List<Id> putAllByUidSync(List<UserGoals> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'uid', objects, saveLinks: saveLinks);
  }
}

extension UserGoalsQueryWhereSort
    on QueryBuilder<UserGoals, UserGoals, QWhere> {
  QueryBuilder<UserGoals, UserGoals, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserGoalsQueryWhere
    on QueryBuilder<UserGoals, UserGoals, QWhereClause> {
  QueryBuilder<UserGoals, UserGoals, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<UserGoals, UserGoals, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterWhereClause> idBetween(
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

  QueryBuilder<UserGoals, UserGoals, QAfterWhereClause> uidEqualTo(String uid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uid',
        value: [uid],
      ));
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterWhereClause> uidNotEqualTo(
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

extension UserGoalsQueryFilter
    on QueryBuilder<UserGoals, UserGoals, QFilterCondition> {
  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition>
      dailyCalorieTargetEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailyCalorieTarget',
        value: value,
      ));
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition>
      dailyCalorieTargetGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dailyCalorieTarget',
        value: value,
      ));
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition>
      dailyCalorieTargetLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dailyCalorieTarget',
        value: value,
      ));
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition>
      dailyCalorieTargetBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dailyCalorieTarget',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition>
      dailyStepGoalEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailyStepGoal',
        value: value,
      ));
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition>
      dailyStepGoalGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dailyStepGoal',
        value: value,
      ));
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition>
      dailyStepGoalLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dailyStepGoal',
        value: value,
      ));
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition>
      dailyStepGoalBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dailyStepGoal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition> dailyWaterMlEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailyWaterMl',
        value: value,
      ));
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition>
      dailyWaterMlGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dailyWaterMl',
        value: value,
      ));
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition>
      dailyWaterMlLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dailyWaterMl',
        value: value,
      ));
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition> dailyWaterMlBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dailyWaterMl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition> idBetween(
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

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition>
      strideLengthMEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'strideLengthM',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition>
      strideLengthMGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'strideLengthM',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition>
      strideLengthMLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'strideLengthM',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition>
      strideLengthMBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'strideLengthM',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition>
      targetWeightKgEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetWeightKg',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition>
      targetWeightKgGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetWeightKg',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition>
      targetWeightKgLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetWeightKg',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition>
      targetWeightKgBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetWeightKg',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition> uidEqualTo(
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

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition> uidGreaterThan(
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

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition> uidLessThan(
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

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition> uidBetween(
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

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition> uidStartsWith(
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

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition> uidEndsWith(
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

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition> uidContains(
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

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition> uidMatches(
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

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition> uidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uid',
        value: '',
      ));
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition> uidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uid',
        value: '',
      ));
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition>
      weeklyRunDaysEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weeklyRunDays',
        value: value,
      ));
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition>
      weeklyRunDaysGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weeklyRunDays',
        value: value,
      ));
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition>
      weeklyRunDaysLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weeklyRunDays',
        value: value,
      ));
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition>
      weeklyRunDaysBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weeklyRunDays',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition>
      weeklyRunningKmEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weeklyRunningKm',
        value: value,
      ));
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition>
      weeklyRunningKmGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weeklyRunningKm',
        value: value,
      ));
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition>
      weeklyRunningKmLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weeklyRunningKm',
        value: value,
      ));
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterFilterCondition>
      weeklyRunningKmBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weeklyRunningKm',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension UserGoalsQueryObject
    on QueryBuilder<UserGoals, UserGoals, QFilterCondition> {}

extension UserGoalsQueryLinks
    on QueryBuilder<UserGoals, UserGoals, QFilterCondition> {}

extension UserGoalsQuerySortBy on QueryBuilder<UserGoals, UserGoals, QSortBy> {
  QueryBuilder<UserGoals, UserGoals, QAfterSortBy> sortByDailyCalorieTarget() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyCalorieTarget', Sort.asc);
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterSortBy>
      sortByDailyCalorieTargetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyCalorieTarget', Sort.desc);
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterSortBy> sortByDailyStepGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyStepGoal', Sort.asc);
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterSortBy> sortByDailyStepGoalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyStepGoal', Sort.desc);
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterSortBy> sortByDailyWaterMl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyWaterMl', Sort.asc);
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterSortBy> sortByDailyWaterMlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyWaterMl', Sort.desc);
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterSortBy> sortByStrideLengthM() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'strideLengthM', Sort.asc);
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterSortBy> sortByStrideLengthMDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'strideLengthM', Sort.desc);
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterSortBy> sortByTargetWeightKg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetWeightKg', Sort.asc);
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterSortBy> sortByTargetWeightKgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetWeightKg', Sort.desc);
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterSortBy> sortByUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.asc);
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterSortBy> sortByUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.desc);
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterSortBy> sortByWeeklyRunDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyRunDays', Sort.asc);
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterSortBy> sortByWeeklyRunDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyRunDays', Sort.desc);
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterSortBy> sortByWeeklyRunningKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyRunningKm', Sort.asc);
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterSortBy> sortByWeeklyRunningKmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyRunningKm', Sort.desc);
    });
  }
}

extension UserGoalsQuerySortThenBy
    on QueryBuilder<UserGoals, UserGoals, QSortThenBy> {
  QueryBuilder<UserGoals, UserGoals, QAfterSortBy> thenByDailyCalorieTarget() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyCalorieTarget', Sort.asc);
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterSortBy>
      thenByDailyCalorieTargetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyCalorieTarget', Sort.desc);
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterSortBy> thenByDailyStepGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyStepGoal', Sort.asc);
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterSortBy> thenByDailyStepGoalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyStepGoal', Sort.desc);
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterSortBy> thenByDailyWaterMl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyWaterMl', Sort.asc);
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterSortBy> thenByDailyWaterMlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyWaterMl', Sort.desc);
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterSortBy> thenByStrideLengthM() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'strideLengthM', Sort.asc);
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterSortBy> thenByStrideLengthMDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'strideLengthM', Sort.desc);
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterSortBy> thenByTargetWeightKg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetWeightKg', Sort.asc);
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterSortBy> thenByTargetWeightKgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetWeightKg', Sort.desc);
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterSortBy> thenByUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.asc);
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterSortBy> thenByUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.desc);
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterSortBy> thenByWeeklyRunDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyRunDays', Sort.asc);
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterSortBy> thenByWeeklyRunDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyRunDays', Sort.desc);
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterSortBy> thenByWeeklyRunningKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyRunningKm', Sort.asc);
    });
  }

  QueryBuilder<UserGoals, UserGoals, QAfterSortBy> thenByWeeklyRunningKmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyRunningKm', Sort.desc);
    });
  }
}

extension UserGoalsQueryWhereDistinct
    on QueryBuilder<UserGoals, UserGoals, QDistinct> {
  QueryBuilder<UserGoals, UserGoals, QDistinct> distinctByDailyCalorieTarget() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailyCalorieTarget');
    });
  }

  QueryBuilder<UserGoals, UserGoals, QDistinct> distinctByDailyStepGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailyStepGoal');
    });
  }

  QueryBuilder<UserGoals, UserGoals, QDistinct> distinctByDailyWaterMl() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailyWaterMl');
    });
  }

  QueryBuilder<UserGoals, UserGoals, QDistinct> distinctByStrideLengthM() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'strideLengthM');
    });
  }

  QueryBuilder<UserGoals, UserGoals, QDistinct> distinctByTargetWeightKg() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetWeightKg');
    });
  }

  QueryBuilder<UserGoals, UserGoals, QDistinct> distinctByUid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserGoals, UserGoals, QDistinct> distinctByWeeklyRunDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weeklyRunDays');
    });
  }

  QueryBuilder<UserGoals, UserGoals, QDistinct> distinctByWeeklyRunningKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weeklyRunningKm');
    });
  }
}

extension UserGoalsQueryProperty
    on QueryBuilder<UserGoals, UserGoals, QQueryProperty> {
  QueryBuilder<UserGoals, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserGoals, int, QQueryOperations> dailyCalorieTargetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailyCalorieTarget');
    });
  }

  QueryBuilder<UserGoals, int, QQueryOperations> dailyStepGoalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailyStepGoal');
    });
  }

  QueryBuilder<UserGoals, int, QQueryOperations> dailyWaterMlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailyWaterMl');
    });
  }

  QueryBuilder<UserGoals, double, QQueryOperations> strideLengthMProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'strideLengthM');
    });
  }

  QueryBuilder<UserGoals, double, QQueryOperations> targetWeightKgProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetWeightKg');
    });
  }

  QueryBuilder<UserGoals, String, QQueryOperations> uidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uid');
    });
  }

  QueryBuilder<UserGoals, int, QQueryOperations> weeklyRunDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weeklyRunDays');
    });
  }

  QueryBuilder<UserGoals, int, QQueryOperations> weeklyRunningKmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weeklyRunningKm');
    });
  }
}

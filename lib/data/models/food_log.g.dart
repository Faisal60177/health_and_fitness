// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_log.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFoodLogCollection on Isar {
  IsarCollection<FoodLog> get foodLogs => this.collection();
}

const FoodLogSchema = CollectionSchema(
  name: r'FoodLog',
  id: -1012088423414645589,
  properties: {
    r'calories': PropertySchema(
      id: 0,
      name: r'calories',
      type: IsarType.double,
    ),
    r'carbCalories': PropertySchema(
      id: 1,
      name: r'carbCalories',
      type: IsarType.double,
    ),
    r'carbsG': PropertySchema(
      id: 2,
      name: r'carbsG',
      type: IsarType.double,
    ),
    r'date': PropertySchema(
      id: 3,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'fatCalories': PropertySchema(
      id: 4,
      name: r'fatCalories',
      type: IsarType.double,
    ),
    r'fatG': PropertySchema(
      id: 5,
      name: r'fatG',
      type: IsarType.double,
    ),
    r'foodName': PropertySchema(
      id: 6,
      name: r'foodName',
      type: IsarType.string,
    ),
    r'mealType': PropertySchema(
      id: 7,
      name: r'mealType',
      type: IsarType.byte,
      enumMap: _FoodLogmealTypeEnumValueMap,
    ),
    r'proteinCalories': PropertySchema(
      id: 8,
      name: r'proteinCalories',
      type: IsarType.double,
    ),
    r'proteinG': PropertySchema(
      id: 9,
      name: r'proteinG',
      type: IsarType.double,
    ),
    r'servingSize': PropertySchema(
      id: 10,
      name: r'servingSize',
      type: IsarType.double,
    ),
    r'uid': PropertySchema(
      id: 11,
      name: r'uid',
      type: IsarType.string,
    )
  },
  estimateSize: _foodLogEstimateSize,
  serialize: _foodLogSerialize,
  deserialize: _foodLogDeserialize,
  deserializeProp: _foodLogDeserializeProp,
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
  getId: _foodLogGetId,
  getLinks: _foodLogGetLinks,
  attach: _foodLogAttach,
  version: '3.1.0+1',
);

int _foodLogEstimateSize(
  FoodLog object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.foodName.length * 3;
  bytesCount += 3 + object.uid.length * 3;
  return bytesCount;
}

void _foodLogSerialize(
  FoodLog object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.calories);
  writer.writeDouble(offsets[1], object.carbCalories);
  writer.writeDouble(offsets[2], object.carbsG);
  writer.writeDateTime(offsets[3], object.date);
  writer.writeDouble(offsets[4], object.fatCalories);
  writer.writeDouble(offsets[5], object.fatG);
  writer.writeString(offsets[6], object.foodName);
  writer.writeByte(offsets[7], object.mealType.index);
  writer.writeDouble(offsets[8], object.proteinCalories);
  writer.writeDouble(offsets[9], object.proteinG);
  writer.writeDouble(offsets[10], object.servingSize);
  writer.writeString(offsets[11], object.uid);
}

FoodLog _foodLogDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FoodLog();
  object.calories = reader.readDouble(offsets[0]);
  object.carbsG = reader.readDouble(offsets[2]);
  object.date = reader.readDateTime(offsets[3]);
  object.fatG = reader.readDouble(offsets[5]);
  object.foodName = reader.readString(offsets[6]);
  object.id = id;
  object.mealType =
      _FoodLogmealTypeValueEnumMap[reader.readByteOrNull(offsets[7])] ??
          MealType.breakfast;
  object.proteinG = reader.readDouble(offsets[9]);
  object.servingSize = reader.readDouble(offsets[10]);
  object.uid = reader.readString(offsets[11]);
  return object;
}

P _foodLogDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (_FoodLogmealTypeValueEnumMap[reader.readByteOrNull(offset)] ??
          MealType.breakfast) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    case 10:
      return (reader.readDouble(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _FoodLogmealTypeEnumValueMap = {
  'breakfast': 0,
  'lunch': 1,
  'dinner': 2,
  'snack': 3,
};
const _FoodLogmealTypeValueEnumMap = {
  0: MealType.breakfast,
  1: MealType.lunch,
  2: MealType.dinner,
  3: MealType.snack,
};

Id _foodLogGetId(FoodLog object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _foodLogGetLinks(FoodLog object) {
  return [];
}

void _foodLogAttach(IsarCollection<dynamic> col, Id id, FoodLog object) {
  object.id = id;
}

extension FoodLogQueryWhereSort on QueryBuilder<FoodLog, FoodLog, QWhere> {
  QueryBuilder<FoodLog, FoodLog, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FoodLogQueryWhere on QueryBuilder<FoodLog, FoodLog, QWhereClause> {
  QueryBuilder<FoodLog, FoodLog, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<FoodLog, FoodLog, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterWhereClause> idBetween(
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

  QueryBuilder<FoodLog, FoodLog, QAfterWhereClause> uidEqualTo(String uid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uid',
        value: [uid],
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterWhereClause> uidNotEqualTo(String uid) {
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

extension FoodLogQueryFilter
    on QueryBuilder<FoodLog, FoodLog, QFilterCondition> {
  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> caloriesEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'calories',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> caloriesGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'calories',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> caloriesLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'calories',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> caloriesBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'calories',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> carbCaloriesEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'carbCalories',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> carbCaloriesGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'carbCalories',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> carbCaloriesLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'carbCalories',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> carbCaloriesBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'carbCalories',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> carbsGEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'carbsG',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> carbsGGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'carbsG',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> carbsGLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'carbsG',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> carbsGBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'carbsG',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> dateGreaterThan(
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

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> dateLessThan(
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

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> dateBetween(
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

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> fatCaloriesEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fatCalories',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> fatCaloriesGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fatCalories',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> fatCaloriesLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fatCalories',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> fatCaloriesBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fatCalories',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> fatGEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fatG',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> fatGGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fatG',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> fatGLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fatG',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> fatGBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fatG',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> foodNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'foodName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> foodNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'foodName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> foodNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'foodName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> foodNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'foodName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> foodNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'foodName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> foodNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'foodName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> foodNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'foodName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> foodNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'foodName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> foodNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'foodName',
        value: '',
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> foodNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'foodName',
        value: '',
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> idBetween(
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

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> mealTypeEqualTo(
      MealType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mealType',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> mealTypeGreaterThan(
    MealType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mealType',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> mealTypeLessThan(
    MealType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mealType',
        value: value,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> mealTypeBetween(
    MealType lower,
    MealType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mealType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> proteinCaloriesEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'proteinCalories',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition>
      proteinCaloriesGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'proteinCalories',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> proteinCaloriesLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'proteinCalories',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> proteinCaloriesBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'proteinCalories',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> proteinGEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'proteinG',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> proteinGGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'proteinG',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> proteinGLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'proteinG',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> proteinGBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'proteinG',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> servingSizeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'servingSize',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> servingSizeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'servingSize',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> servingSizeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'servingSize',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> servingSizeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'servingSize',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> uidEqualTo(
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

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> uidGreaterThan(
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

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> uidLessThan(
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

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> uidBetween(
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

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> uidStartsWith(
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

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> uidEndsWith(
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

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> uidContains(
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

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> uidMatches(
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

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> uidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uid',
        value: '',
      ));
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterFilterCondition> uidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uid',
        value: '',
      ));
    });
  }
}

extension FoodLogQueryObject
    on QueryBuilder<FoodLog, FoodLog, QFilterCondition> {}

extension FoodLogQueryLinks
    on QueryBuilder<FoodLog, FoodLog, QFilterCondition> {}

extension FoodLogQuerySortBy on QueryBuilder<FoodLog, FoodLog, QSortBy> {
  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByCaloriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByCarbCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbCalories', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByCarbCaloriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbCalories', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByCarbsG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbsG', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByCarbsGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbsG', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByFatCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatCalories', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByFatCaloriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatCalories', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByFatG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatG', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByFatGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatG', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByFoodName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foodName', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByFoodNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foodName', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByMealType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mealType', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByMealTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mealType', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByProteinCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinCalories', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByProteinCaloriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinCalories', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByProteinG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinG', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByProteinGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinG', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByServingSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'servingSize', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByServingSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'servingSize', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> sortByUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.desc);
    });
  }
}

extension FoodLogQuerySortThenBy
    on QueryBuilder<FoodLog, FoodLog, QSortThenBy> {
  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByCaloriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByCarbCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbCalories', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByCarbCaloriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbCalories', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByCarbsG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbsG', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByCarbsGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbsG', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByFatCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatCalories', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByFatCaloriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatCalories', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByFatG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatG', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByFatGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatG', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByFoodName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foodName', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByFoodNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foodName', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByMealType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mealType', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByMealTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mealType', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByProteinCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinCalories', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByProteinCaloriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinCalories', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByProteinG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinG', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByProteinGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinG', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByServingSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'servingSize', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByServingSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'servingSize', Sort.desc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.asc);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QAfterSortBy> thenByUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.desc);
    });
  }
}

extension FoodLogQueryWhereDistinct
    on QueryBuilder<FoodLog, FoodLog, QDistinct> {
  QueryBuilder<FoodLog, FoodLog, QDistinct> distinctByCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'calories');
    });
  }

  QueryBuilder<FoodLog, FoodLog, QDistinct> distinctByCarbCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'carbCalories');
    });
  }

  QueryBuilder<FoodLog, FoodLog, QDistinct> distinctByCarbsG() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'carbsG');
    });
  }

  QueryBuilder<FoodLog, FoodLog, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<FoodLog, FoodLog, QDistinct> distinctByFatCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fatCalories');
    });
  }

  QueryBuilder<FoodLog, FoodLog, QDistinct> distinctByFatG() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fatG');
    });
  }

  QueryBuilder<FoodLog, FoodLog, QDistinct> distinctByFoodName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'foodName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FoodLog, FoodLog, QDistinct> distinctByMealType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mealType');
    });
  }

  QueryBuilder<FoodLog, FoodLog, QDistinct> distinctByProteinCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'proteinCalories');
    });
  }

  QueryBuilder<FoodLog, FoodLog, QDistinct> distinctByProteinG() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'proteinG');
    });
  }

  QueryBuilder<FoodLog, FoodLog, QDistinct> distinctByServingSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'servingSize');
    });
  }

  QueryBuilder<FoodLog, FoodLog, QDistinct> distinctByUid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uid', caseSensitive: caseSensitive);
    });
  }
}

extension FoodLogQueryProperty
    on QueryBuilder<FoodLog, FoodLog, QQueryProperty> {
  QueryBuilder<FoodLog, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FoodLog, double, QQueryOperations> caloriesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'calories');
    });
  }

  QueryBuilder<FoodLog, double, QQueryOperations> carbCaloriesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'carbCalories');
    });
  }

  QueryBuilder<FoodLog, double, QQueryOperations> carbsGProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'carbsG');
    });
  }

  QueryBuilder<FoodLog, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<FoodLog, double, QQueryOperations> fatCaloriesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fatCalories');
    });
  }

  QueryBuilder<FoodLog, double, QQueryOperations> fatGProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fatG');
    });
  }

  QueryBuilder<FoodLog, String, QQueryOperations> foodNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'foodName');
    });
  }

  QueryBuilder<FoodLog, MealType, QQueryOperations> mealTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mealType');
    });
  }

  QueryBuilder<FoodLog, double, QQueryOperations> proteinCaloriesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'proteinCalories');
    });
  }

  QueryBuilder<FoodLog, double, QQueryOperations> proteinGProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'proteinG');
    });
  }

  QueryBuilder<FoodLog, double, QQueryOperations> servingSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'servingSize');
    });
  }

  QueryBuilder<FoodLog, String, QQueryOperations> uidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uid');
    });
  }
}

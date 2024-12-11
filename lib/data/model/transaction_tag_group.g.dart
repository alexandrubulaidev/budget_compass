// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_tag_group.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTransactionTagGroupCollection on Isar {
  IsarCollection<TransactionTagGroup> get transactionTagGroups =>
      this.collection();
}

const TransactionTagGroupSchema = CollectionSchema(
  name: r'TransactionTagGroup',
  id: 2635344760033352507,
  properties: {
    r'children': PropertySchema(
      id: 0,
      name: r'children',
      type: IsarType.stringList,
    ),
    r'parent': PropertySchema(
      id: 1,
      name: r'parent',
      type: IsarType.string,
    )
  },
  estimateSize: _transactionTagGroupEstimateSize,
  serialize: _transactionTagGroupSerialize,
  deserialize: _transactionTagGroupDeserialize,
  deserializeProp: _transactionTagGroupDeserializeProp,
  idName: r'id',
  indexes: {
    r'parent': IndexSchema(
      id: 8742773298275793466,
      name: r'parent',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'parent',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _transactionTagGroupGetId,
  getLinks: _transactionTagGroupGetLinks,
  attach: _transactionTagGroupAttach,
  version: '3.1.0+1',
);

int _transactionTagGroupEstimateSize(
  TransactionTagGroup object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.children.length * 3;
  {
    for (var i = 0; i < object.children.length; i++) {
      final value = object.children[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.parent.length * 3;
  return bytesCount;
}

void _transactionTagGroupSerialize(
  TransactionTagGroup object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.children);
  writer.writeString(offsets[1], object.parent);
}

TransactionTagGroup _transactionTagGroupDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TransactionTagGroup(
    children: reader.readStringList(offsets[0]) ?? [],
    id: id,
    parent: reader.readString(offsets[1]),
  );
  return object;
}

P _transactionTagGroupDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringList(offset) ?? []) as P;
    case 1:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _transactionTagGroupGetId(TransactionTagGroup object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _transactionTagGroupGetLinks(
    TransactionTagGroup object) {
  return [];
}

void _transactionTagGroupAttach(
    IsarCollection<dynamic> col, Id id, TransactionTagGroup object) {}

extension TransactionTagGroupByIndex on IsarCollection<TransactionTagGroup> {
  Future<TransactionTagGroup?> getByParent(String parent) {
    return getByIndex(r'parent', [parent]);
  }

  TransactionTagGroup? getByParentSync(String parent) {
    return getByIndexSync(r'parent', [parent]);
  }

  Future<bool> deleteByParent(String parent) {
    return deleteByIndex(r'parent', [parent]);
  }

  bool deleteByParentSync(String parent) {
    return deleteByIndexSync(r'parent', [parent]);
  }

  Future<List<TransactionTagGroup?>> getAllByParent(List<String> parentValues) {
    final values = parentValues.map((e) => [e]).toList();
    return getAllByIndex(r'parent', values);
  }

  List<TransactionTagGroup?> getAllByParentSync(List<String> parentValues) {
    final values = parentValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'parent', values);
  }

  Future<int> deleteAllByParent(List<String> parentValues) {
    final values = parentValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'parent', values);
  }

  int deleteAllByParentSync(List<String> parentValues) {
    final values = parentValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'parent', values);
  }

  Future<Id> putByParent(TransactionTagGroup object) {
    return putByIndex(r'parent', object);
  }

  Id putByParentSync(TransactionTagGroup object, {bool saveLinks = true}) {
    return putByIndexSync(r'parent', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByParent(List<TransactionTagGroup> objects) {
    return putAllByIndex(r'parent', objects);
  }

  List<Id> putAllByParentSync(List<TransactionTagGroup> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'parent', objects, saveLinks: saveLinks);
  }
}

extension TransactionTagGroupQueryWhereSort
    on QueryBuilder<TransactionTagGroup, TransactionTagGroup, QWhere> {
  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TransactionTagGroupQueryWhere
    on QueryBuilder<TransactionTagGroup, TransactionTagGroup, QWhereClause> {
  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterWhereClause>
      parentEqualTo(String parent) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'parent',
        value: [parent],
      ));
    });
  }

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterWhereClause>
      parentNotEqualTo(String parent) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'parent',
              lower: [],
              upper: [parent],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'parent',
              lower: [parent],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'parent',
              lower: [parent],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'parent',
              lower: [],
              upper: [parent],
              includeUpper: false,
            ));
      }
    });
  }
}

extension TransactionTagGroupQueryFilter on QueryBuilder<TransactionTagGroup,
    TransactionTagGroup, QFilterCondition> {
  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterFilterCondition>
      childrenElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'children',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterFilterCondition>
      childrenElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'children',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterFilterCondition>
      childrenElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'children',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterFilterCondition>
      childrenElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'children',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterFilterCondition>
      childrenElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'children',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterFilterCondition>
      childrenElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'children',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterFilterCondition>
      childrenElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'children',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterFilterCondition>
      childrenElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'children',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterFilterCondition>
      childrenElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'children',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterFilterCondition>
      childrenElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'children',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterFilterCondition>
      childrenLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'children',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterFilterCondition>
      childrenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'children',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterFilterCondition>
      childrenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'children',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterFilterCondition>
      childrenLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'children',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterFilterCondition>
      childrenLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'children',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterFilterCondition>
      childrenLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'children',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterFilterCondition>
      parentEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterFilterCondition>
      parentGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'parent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterFilterCondition>
      parentLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'parent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterFilterCondition>
      parentBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'parent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterFilterCondition>
      parentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'parent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterFilterCondition>
      parentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'parent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterFilterCondition>
      parentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'parent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterFilterCondition>
      parentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'parent',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterFilterCondition>
      parentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parent',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterFilterCondition>
      parentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'parent',
        value: '',
      ));
    });
  }
}

extension TransactionTagGroupQueryObject on QueryBuilder<TransactionTagGroup,
    TransactionTagGroup, QFilterCondition> {}

extension TransactionTagGroupQueryLinks on QueryBuilder<TransactionTagGroup,
    TransactionTagGroup, QFilterCondition> {}

extension TransactionTagGroupQuerySortBy
    on QueryBuilder<TransactionTagGroup, TransactionTagGroup, QSortBy> {
  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterSortBy>
      sortByParent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parent', Sort.asc);
    });
  }

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterSortBy>
      sortByParentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parent', Sort.desc);
    });
  }
}

extension TransactionTagGroupQuerySortThenBy
    on QueryBuilder<TransactionTagGroup, TransactionTagGroup, QSortThenBy> {
  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterSortBy>
      thenByParent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parent', Sort.asc);
    });
  }

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QAfterSortBy>
      thenByParentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parent', Sort.desc);
    });
  }
}

extension TransactionTagGroupQueryWhereDistinct
    on QueryBuilder<TransactionTagGroup, TransactionTagGroup, QDistinct> {
  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QDistinct>
      distinctByChildren() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'children');
    });
  }

  QueryBuilder<TransactionTagGroup, TransactionTagGroup, QDistinct>
      distinctByParent({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'parent', caseSensitive: caseSensitive);
    });
  }
}

extension TransactionTagGroupQueryProperty
    on QueryBuilder<TransactionTagGroup, TransactionTagGroup, QQueryProperty> {
  QueryBuilder<TransactionTagGroup, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TransactionTagGroup, List<String>, QQueryOperations>
      childrenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'children');
    });
  }

  QueryBuilder<TransactionTagGroup, String, QQueryOperations> parentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'parent');
    });
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fav_item.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFavouriteCollection on Isar {
  IsarCollection<Favourite> get favourites => this.collection();
}

const FavouriteSchema = CollectionSchema(
  name: r'Favourite',
  id: 2882997178178307874,
  properties: {
    r'podcastJson': PropertySchema(
      id: 0,
      name: r'podcastJson',
      type: IsarType.string,
    )
  },
  estimateSize: _favouriteEstimateSize,
  serialize: _favouriteSerialize,
  deserialize: _favouriteDeserialize,
  deserializeProp: _favouriteDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _favouriteGetId,
  getLinks: _favouriteGetLinks,
  attach: _favouriteAttach,
  version: '3.1.0+1',
);

int _favouriteEstimateSize(
  Favourite object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.podcastJson.length * 3;
  return bytesCount;
}

void _favouriteSerialize(
  Favourite object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.podcastJson);
}

Favourite _favouriteDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Favourite(
    id: id,
  );
  object.podcastJson = reader.readString(offsets[0]);
  return object;
}

P _favouriteDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _favouriteGetId(Favourite object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _favouriteGetLinks(Favourite object) {
  return [];
}

void _favouriteAttach(IsarCollection<dynamic> col, Id id, Favourite object) {
  object.id = id;
}

extension FavouriteQueryWhereSort
    on QueryBuilder<Favourite, Favourite, QWhere> {
  QueryBuilder<Favourite, Favourite, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FavouriteQueryWhere
    on QueryBuilder<Favourite, Favourite, QWhereClause> {
  QueryBuilder<Favourite, Favourite, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Favourite, Favourite, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterWhereClause> idBetween(
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
}

extension FavouriteQueryFilter
    on QueryBuilder<Favourite, Favourite, QFilterCondition> {
  QueryBuilder<Favourite, Favourite, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition> podcastJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'podcastJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition>
      podcastJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'podcastJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition> podcastJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'podcastJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition> podcastJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'podcastJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition>
      podcastJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'podcastJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition> podcastJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'podcastJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition> podcastJsonContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'podcastJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition> podcastJsonMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'podcastJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition>
      podcastJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'podcastJson',
        value: '',
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition>
      podcastJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'podcastJson',
        value: '',
      ));
    });
  }
}

extension FavouriteQueryObject
    on QueryBuilder<Favourite, Favourite, QFilterCondition> {}

extension FavouriteQueryLinks
    on QueryBuilder<Favourite, Favourite, QFilterCondition> {}

extension FavouriteQuerySortBy on QueryBuilder<Favourite, Favourite, QSortBy> {
  QueryBuilder<Favourite, Favourite, QAfterSortBy> sortByPodcastJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'podcastJson', Sort.asc);
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterSortBy> sortByPodcastJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'podcastJson', Sort.desc);
    });
  }
}

extension FavouriteQuerySortThenBy
    on QueryBuilder<Favourite, Favourite, QSortThenBy> {
  QueryBuilder<Favourite, Favourite, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterSortBy> thenByPodcastJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'podcastJson', Sort.asc);
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterSortBy> thenByPodcastJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'podcastJson', Sort.desc);
    });
  }
}

extension FavouriteQueryWhereDistinct
    on QueryBuilder<Favourite, Favourite, QDistinct> {
  QueryBuilder<Favourite, Favourite, QDistinct> distinctByPodcastJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'podcastJson', caseSensitive: caseSensitive);
    });
  }
}

extension FavouriteQueryProperty
    on QueryBuilder<Favourite, Favourite, QQueryProperty> {
  QueryBuilder<Favourite, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Favourite, String, QQueryOperations> podcastJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'podcastJson');
    });
  }
}

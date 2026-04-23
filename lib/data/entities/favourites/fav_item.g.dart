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
    r'contentLength': PropertySchema(
      id: 0,
      name: r'contentLength',
      type: IsarType.long,
    ),
    r'eTag': PropertySchema(
      id: 1,
      name: r'eTag',
      type: IsarType.string,
    ),
    r'lastModified': PropertySchema(
      id: 2,
      name: r'lastModified',
      type: IsarType.string,
    ),
    r'podcastJson': PropertySchema(
      id: 3,
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
  {
    final value = object.eTag;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.lastModified;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.podcastJson.length * 3;
  return bytesCount;
}

void _favouriteSerialize(
  Favourite object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.contentLength);
  writer.writeString(offsets[1], object.eTag);
  writer.writeString(offsets[2], object.lastModified);
  writer.writeString(offsets[3], object.podcastJson);
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
  object.contentLength = reader.readLongOrNull(offsets[0]);
  object.eTag = reader.readStringOrNull(offsets[1]);
  object.lastModified = reader.readStringOrNull(offsets[2]);
  object.podcastJson = reader.readString(offsets[3]);
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
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
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
  QueryBuilder<Favourite, Favourite, QAfterFilterCondition>
      contentLengthIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'contentLength',
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition>
      contentLengthIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'contentLength',
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition>
      contentLengthEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contentLength',
        value: value,
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition>
      contentLengthGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'contentLength',
        value: value,
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition>
      contentLengthLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'contentLength',
        value: value,
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition>
      contentLengthBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'contentLength',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition> eTagIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'eTag',
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition> eTagIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'eTag',
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition> eTagEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eTag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition> eTagGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'eTag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition> eTagLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'eTag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition> eTagBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'eTag',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition> eTagStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'eTag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition> eTagEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'eTag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition> eTagContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'eTag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition> eTagMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'eTag',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition> eTagIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eTag',
        value: '',
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition> eTagIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'eTag',
        value: '',
      ));
    });
  }

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

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition>
      lastModifiedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastModified',
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition>
      lastModifiedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastModified',
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition> lastModifiedEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastModified',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition>
      lastModifiedGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastModified',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition>
      lastModifiedLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastModified',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition> lastModifiedBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastModified',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition>
      lastModifiedStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastModified',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition>
      lastModifiedEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastModified',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition>
      lastModifiedContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastModified',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition> lastModifiedMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastModified',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition>
      lastModifiedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastModified',
        value: '',
      ));
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterFilterCondition>
      lastModifiedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastModified',
        value: '',
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
  QueryBuilder<Favourite, Favourite, QAfterSortBy> sortByContentLength() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentLength', Sort.asc);
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterSortBy> sortByContentLengthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentLength', Sort.desc);
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterSortBy> sortByETag() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eTag', Sort.asc);
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterSortBy> sortByETagDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eTag', Sort.desc);
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterSortBy> sortByLastModified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastModified', Sort.asc);
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterSortBy> sortByLastModifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastModified', Sort.desc);
    });
  }

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
  QueryBuilder<Favourite, Favourite, QAfterSortBy> thenByContentLength() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentLength', Sort.asc);
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterSortBy> thenByContentLengthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentLength', Sort.desc);
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterSortBy> thenByETag() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eTag', Sort.asc);
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterSortBy> thenByETagDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eTag', Sort.desc);
    });
  }

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

  QueryBuilder<Favourite, Favourite, QAfterSortBy> thenByLastModified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastModified', Sort.asc);
    });
  }

  QueryBuilder<Favourite, Favourite, QAfterSortBy> thenByLastModifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastModified', Sort.desc);
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
  QueryBuilder<Favourite, Favourite, QDistinct> distinctByContentLength() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contentLength');
    });
  }

  QueryBuilder<Favourite, Favourite, QDistinct> distinctByETag(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eTag', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Favourite, Favourite, QDistinct> distinctByLastModified(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastModified', caseSensitive: caseSensitive);
    });
  }

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

  QueryBuilder<Favourite, int?, QQueryOperations> contentLengthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contentLength');
    });
  }

  QueryBuilder<Favourite, String?, QQueryOperations> eTagProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eTag');
    });
  }

  QueryBuilder<Favourite, String?, QQueryOperations> lastModifiedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastModified');
    });
  }

  QueryBuilder<Favourite, String, QQueryOperations> podcastJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'podcastJson');
    });
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_track.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSaveTrackCollection on Isar {
  IsarCollection<SaveTrack> get saveTracks => this.collection();
}

const SaveTrackSchema = CollectionSchema(
  name: r'SaveTrack',
  id: -3731165250737059919,
  properties: {
    r'finished': PropertySchema(
      id: 0,
      name: r'finished',
      type: IsarType.bool,
    ),
    r'podcastUrl': PropertySchema(
      id: 1,
      name: r'podcastUrl',
      type: IsarType.string,
    ),
    r'position': PropertySchema(
      id: 2,
      name: r'position',
      type: IsarType.long,
    ),
    r'url': PropertySchema(
      id: 3,
      name: r'url',
      type: IsarType.string,
    )
  },
  estimateSize: _saveTrackEstimateSize,
  serialize: _saveTrackSerialize,
  deserialize: _saveTrackDeserialize,
  deserializeProp: _saveTrackDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _saveTrackGetId,
  getLinks: _saveTrackGetLinks,
  attach: _saveTrackAttach,
  version: '3.1.0+1',
);

int _saveTrackEstimateSize(
  SaveTrack object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.podcastUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.url;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _saveTrackSerialize(
  SaveTrack object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.finished);
  writer.writeString(offsets[1], object.podcastUrl);
  writer.writeLong(offsets[2], object.position);
  writer.writeString(offsets[3], object.url);
}

SaveTrack _saveTrackDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SaveTrack(
    finished: reader.readBoolOrNull(offsets[0]),
    id: id,
    podcastUrl: reader.readStringOrNull(offsets[1]),
    position: reader.readLongOrNull(offsets[2]),
    url: reader.readStringOrNull(offsets[3]),
  );
  return object;
}

P _saveTrackDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _saveTrackGetId(SaveTrack object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _saveTrackGetLinks(SaveTrack object) {
  return [];
}

void _saveTrackAttach(IsarCollection<dynamic> col, Id id, SaveTrack object) {
  object.id = id;
}

extension SaveTrackQueryWhereSort
    on QueryBuilder<SaveTrack, SaveTrack, QWhere> {
  QueryBuilder<SaveTrack, SaveTrack, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SaveTrackQueryWhere
    on QueryBuilder<SaveTrack, SaveTrack, QWhereClause> {
  QueryBuilder<SaveTrack, SaveTrack, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<SaveTrack, SaveTrack, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterWhereClause> idBetween(
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

extension SaveTrackQueryFilter
    on QueryBuilder<SaveTrack, SaveTrack, QFilterCondition> {
  QueryBuilder<SaveTrack, SaveTrack, QAfterFilterCondition> finishedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'finished',
      ));
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterFilterCondition>
      finishedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'finished',
      ));
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterFilterCondition> finishedEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'finished',
        value: value,
      ));
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<SaveTrack, SaveTrack, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<SaveTrack, SaveTrack, QAfterFilterCondition> idBetween(
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

  QueryBuilder<SaveTrack, SaveTrack, QAfterFilterCondition> podcastUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'podcastUrl',
      ));
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterFilterCondition>
      podcastUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'podcastUrl',
      ));
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterFilterCondition> podcastUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'podcastUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterFilterCondition>
      podcastUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'podcastUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterFilterCondition> podcastUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'podcastUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterFilterCondition> podcastUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'podcastUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterFilterCondition>
      podcastUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'podcastUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterFilterCondition> podcastUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'podcastUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterFilterCondition> podcastUrlContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'podcastUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterFilterCondition> podcastUrlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'podcastUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterFilterCondition>
      podcastUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'podcastUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterFilterCondition>
      podcastUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'podcastUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterFilterCondition> positionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'position',
      ));
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterFilterCondition>
      positionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'position',
      ));
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterFilterCondition> positionEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'position',
        value: value,
      ));
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterFilterCondition> positionGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'position',
        value: value,
      ));
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterFilterCondition> positionLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'position',
        value: value,
      ));
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterFilterCondition> positionBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'position',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterFilterCondition> urlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'url',
      ));
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterFilterCondition> urlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'url',
      ));
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterFilterCondition> urlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterFilterCondition> urlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterFilterCondition> urlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterFilterCondition> urlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'url',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterFilterCondition> urlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterFilterCondition> urlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterFilterCondition> urlContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterFilterCondition> urlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'url',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterFilterCondition> urlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'url',
        value: '',
      ));
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterFilterCondition> urlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'url',
        value: '',
      ));
    });
  }
}

extension SaveTrackQueryObject
    on QueryBuilder<SaveTrack, SaveTrack, QFilterCondition> {}

extension SaveTrackQueryLinks
    on QueryBuilder<SaveTrack, SaveTrack, QFilterCondition> {}

extension SaveTrackQuerySortBy on QueryBuilder<SaveTrack, SaveTrack, QSortBy> {
  QueryBuilder<SaveTrack, SaveTrack, QAfterSortBy> sortByFinished() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finished', Sort.asc);
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterSortBy> sortByFinishedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finished', Sort.desc);
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterSortBy> sortByPodcastUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'podcastUrl', Sort.asc);
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterSortBy> sortByPodcastUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'podcastUrl', Sort.desc);
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterSortBy> sortByPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.asc);
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterSortBy> sortByPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.desc);
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterSortBy> sortByUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.asc);
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterSortBy> sortByUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.desc);
    });
  }
}

extension SaveTrackQuerySortThenBy
    on QueryBuilder<SaveTrack, SaveTrack, QSortThenBy> {
  QueryBuilder<SaveTrack, SaveTrack, QAfterSortBy> thenByFinished() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finished', Sort.asc);
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterSortBy> thenByFinishedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finished', Sort.desc);
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterSortBy> thenByPodcastUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'podcastUrl', Sort.asc);
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterSortBy> thenByPodcastUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'podcastUrl', Sort.desc);
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterSortBy> thenByPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.asc);
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterSortBy> thenByPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.desc);
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterSortBy> thenByUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.asc);
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QAfterSortBy> thenByUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.desc);
    });
  }
}

extension SaveTrackQueryWhereDistinct
    on QueryBuilder<SaveTrack, SaveTrack, QDistinct> {
  QueryBuilder<SaveTrack, SaveTrack, QDistinct> distinctByFinished() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'finished');
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QDistinct> distinctByPodcastUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'podcastUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QDistinct> distinctByPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'position');
    });
  }

  QueryBuilder<SaveTrack, SaveTrack, QDistinct> distinctByUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'url', caseSensitive: caseSensitive);
    });
  }
}

extension SaveTrackQueryProperty
    on QueryBuilder<SaveTrack, SaveTrack, QQueryProperty> {
  QueryBuilder<SaveTrack, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SaveTrack, bool?, QQueryOperations> finishedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'finished');
    });
  }

  QueryBuilder<SaveTrack, String?, QQueryOperations> podcastUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'podcastUrl');
    });
  }

  QueryBuilder<SaveTrack, int?, QQueryOperations> positionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'position');
    });
  }

  QueryBuilder<SaveTrack, String?, QQueryOperations> urlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'url');
    });
  }
}

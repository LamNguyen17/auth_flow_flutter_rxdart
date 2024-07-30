// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieDetailResponse _$MovieDetailResponseFromJson(Map<String, dynamic> json) =>
    MovieDetailResponse(
      adult: json['adult'] as bool?,
      backdropPath: json['backdrop_path'] as String?,
      belongsToCollection: json['belongs_to_collection'] == null
          ? null
          : BelongsToCollectionResponse.fromJson(
              json['belongs_to_collection'] as Map<String, dynamic>),
      budget: (json['budget'] as num?)?.toInt(),
      genres: (json['genres'] as List<dynamic>?)
          ?.map((e) => GenreResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      homepage: json['homepage'] as String?,
      id: (json['id'] as num?)?.toInt(),
      imdbId: json['imdb_id'] as String?,
      originalLanguage: json['original_language'] as String?,
      originalTitle: json['original_title'] as String?,
      overview: json['overview'] as String?,
      popularity: (json['popularity'] as num?)?.toDouble(),
      posterPath: json['poster_path'] as String?,
      productionCompanies: (json['production_companies'] as List<dynamic>?)
          ?.map((e) =>
              ProductionCompanyResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      productionCountries: (json['production_countries'] as List<dynamic>?)
          ?.map((e) =>
              ProductionCountryResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      releaseDate: json['release_date'] as String?,
      revenue: (json['revenue'] as num?)?.toInt(),
      runtime: (json['runtime'] as num?)?.toInt(),
      status: json['status'] as String?,
      tagline: json['tagline'] as String?,
      title: json['title'] as String?,
      video: json['video'] as bool?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      voteCount: (json['vote_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MovieDetailResponseToJson(
        MovieDetailResponse instance) =>
    <String, dynamic>{
      'adult': instance.adult,
      'backdrop_path': instance.backdropPath,
      'belongs_to_collection': instance.belongsToCollection?.toJson(),
      'budget': instance.budget,
      'genres': instance.genres?.map((e) => e.toJson()).toList(),
      'homepage': instance.homepage,
      'id': instance.id,
      'imdb_id': instance.imdbId,
      'original_language': instance.originalLanguage,
      'original_title': instance.originalTitle,
      'overview': instance.overview,
      'popularity': instance.popularity,
      'poster_path': instance.posterPath,
      'production_companies':
          instance.productionCompanies?.map((e) => e.toJson()).toList(),
      'production_countries':
          instance.productionCountries?.map((e) => e.toJson()).toList(),
      'release_date': instance.releaseDate,
      'revenue': instance.revenue,
      'runtime': instance.runtime,
      'status': instance.status,
      'tagline': instance.tagline,
      'title': instance.title,
      'video': instance.video,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
    };

BelongsToCollectionResponse _$BelongsToCollectionResponseFromJson(
        Map<String, dynamic> json) =>
    BelongsToCollectionResponse(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
    );

Map<String, dynamic> _$BelongsToCollectionResponseToJson(
        BelongsToCollectionResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'poster_path': instance.posterPath,
      'backdrop_path': instance.backdropPath,
    };

GenreResponse _$GenreResponseFromJson(Map<String, dynamic> json) =>
    GenreResponse(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$GenreResponseToJson(GenreResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

ProductionCompanyResponse _$ProductionCompanyResponseFromJson(
        Map<String, dynamic> json) =>
    ProductionCompanyResponse(
      id: (json['id'] as num?)?.toInt(),
      logoPath: json['logo_path'] as String?,
      name: json['name'] as String?,
      originCountry: json['origin_country'] as String?,
    );

Map<String, dynamic> _$ProductionCompanyResponseToJson(
        ProductionCompanyResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'logo_path': instance.logoPath,
      'name': instance.name,
      'origin_country': instance.originCountry,
    };

ProductionCountryResponse _$ProductionCountryResponseFromJson(
        Map<String, dynamic> json) =>
    ProductionCountryResponse(
      iso31661: json['iso31661'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$ProductionCountryResponseToJson(
        ProductionCountryResponse instance) =>
    <String, dynamic>{
      'iso31661': instance.iso31661,
      'name': instance.name,
    };

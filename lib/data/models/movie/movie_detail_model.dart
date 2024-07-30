import 'package:auth_flow_flutter_rxdart/domain/entities/movie/movie_detail.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie_detail_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MovieDetailResponse {
  final bool? adult;
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
  @JsonKey(name: 'belongs_to_collection')
  final BelongsToCollectionResponse? belongsToCollection;
  final int? budget;
  final List<GenreResponse>? genres;
  final String? homepage;
  final int? id;
  @JsonKey(name: 'imdb_id')
  final String? imdbId;
  @JsonKey(name: 'original_language')
  final String? originalLanguage;
  @JsonKey(name: 'original_title')
  final String? originalTitle;
  final String? overview;
  final double? popularity;
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  @JsonKey(name: 'production_companies')
  final List<ProductionCompanyResponse>? productionCompanies;
  @JsonKey(name: 'production_countries')
  final List<ProductionCountryResponse>? productionCountries;
  @JsonKey(name: 'release_date')
  final String? releaseDate;
  final int? revenue;
  final int? runtime;
  final String? status;
  final String? tagline;
  final String? title;
  final bool? video;
  @JsonKey(name: 'vote_average')
  final double? voteAverage;
  @JsonKey(name: 'vote_count')
  final int? voteCount;

  MovieDetailResponse({
    this.adult,
    this.backdropPath,
    this.belongsToCollection,
    this.budget,
    this.genres,
    this.homepage,
    this.id,
    this.imdbId,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.productionCompanies,
    this.productionCountries,
    this.releaseDate,
    this.revenue,
    this.runtime,
    this.status,
    this.tagline,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
  });

  factory MovieDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MovieDetailResponseToJson(this);

  MovieDetail toEntity() {
    return MovieDetail(
      adult: adult,
      backdropPath: backdropPath,
      belongsToCollection: belongsToCollection?.toEntity(),
      budget: budget,
      genres: genres?.map((x) => x.toEntity()).toList(),
      homepage: homepage,
      id: id,
      imdbId: imdbId,
      originalLanguage: originalLanguage,
      originalTitle: originalTitle,
      overview: overview,
      popularity: popularity,
      posterPath: posterPath,
      productionCompanies:
          productionCompanies?.map((x) => x.toEntity()).toList(),
      productionCountries:
          productionCountries?.map((x) => x.toEntity()).toList(),
      releaseDate: releaseDate,
      revenue: revenue,
      runtime: runtime,
      status: status,
      tagline: tagline,
      title: title,
      video: video,
      voteAverage: voteAverage,
      voteCount: voteCount,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class BelongsToCollectionResponse {
  final int? id;
  final String? name;
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;

  BelongsToCollectionResponse({
    this.id,
    this.name,
    this.posterPath,
    this.backdropPath,
  });

  factory BelongsToCollectionResponse.fromJson(Map<String, dynamic> json) =>
      _$BelongsToCollectionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BelongsToCollectionResponseToJson(this);

  BelongsToCollection toEntity() {
    return BelongsToCollection(
      id: id,
      name: name,
      posterPath: posterPath,
      backdropPath: backdropPath,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class GenreResponse {
  final int? id;
  final String? name;

  GenreResponse({
    this.id,
    this.name,
  });

  factory GenreResponse.fromJson(Map<String, dynamic> json) =>
      _$GenreResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GenreResponseToJson(this);

  Genre toEntity() {
    return Genre(
      id: id,
      name: name,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ProductionCompanyResponse {
  final int? id;
  @JsonKey(name: 'logo_path')
  final String? logoPath;
  final String? name;
  @JsonKey(name: 'origin_country')
  final String? originCountry;

  ProductionCompanyResponse({
    this.id,
    this.logoPath,
    this.name,
    this.originCountry,
  });

  factory ProductionCompanyResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductionCompanyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductionCompanyResponseToJson(this);

  ProductionCompany toEntity() {
    return ProductionCompany(
      id: id,
      logoPath: logoPath,
      name: name,
      originCountry: originCountry,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ProductionCountryResponse {
  final String? iso31661;
  final String? name;

  ProductionCountryResponse({
    this.iso31661,
    this.name,
  });

  factory ProductionCountryResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductionCountryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductionCountryResponseToJson(this);

  ProductionCountry toEntity() {
    return ProductionCountry(
      iso31661: iso31661,
      name: name,
    );
  }
}

import 'package:auth_flow_flutter_rxdart/domain/entities/movie/movie_list.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie_list_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MovieListResponse {
  final int? page;
  final List<MovieItemResponse>? results;
  @JsonKey(name: 'total_pages')
  final int? totalPages;
  @JsonKey(name: 'total_results')
  final int? totalResults;

  MovieListResponse(
      {this.page, this.results, this.totalPages, this.totalResults});

  factory MovieListResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MovieListResponseToJson(this);

  MovieList toEntity() {
    return MovieList(
        page: page,
        results: results?.map((x) => x.toEntity()).toList(),
        totalPages: totalPages,
        totalResults: totalResults);
  }
}

@JsonSerializable(explicitToJson: true)
class MovieItemResponse {
  final String? status;
  final int? revenue;
  final bool? adult;
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
  @JsonKey(name: 'genre_ids')
  final List<int>? genreIds;
  final int? budget;
  final List<GenreResponse>? genres;
  final int id;
  @JsonKey(name: 'original_language')
  final String? originalLanguage;
  @JsonKey(name: 'original_title')
  final String? originalTitle;
  final String? overview;
  final double? popularity;
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  @JsonKey(name: 'release_date')
  final String? releaseDate;
  final String? title;
  final bool? video;
  @JsonKey(name: 'vote_average')
  final double? voteAverage;
  @JsonKey(name: 'vote_count')
  final int? voteCount;

  MovieItemResponse(
      {this.status,
      this.revenue,
      this.adult,
      this.backdropPath,
      this.genreIds,
      required this.id,
      this.budget,
      this.genres,
      this.originalLanguage,
      this.originalTitle,
      this.overview,
      this.popularity,
      this.posterPath,
      this.releaseDate,
      this.title,
      this.video,
      this.voteAverage,
      this.voteCount});

  factory MovieItemResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MovieItemResponseToJson(this);

  MovieItem toEntity() {
    return MovieItem(
        genres: genres?.map((x) => x.toEntity()).toList(),
        budget: budget,
        status: status,
        revenue: revenue,
        adult: adult,
        backdropPath: backdropPath,
        genreIds: genreIds,
        id: id,
        originalLanguage: originalLanguage,
        originalTitle: originalTitle,
        overview: overview,
        popularity: popularity,
        posterPath: posterPath,
        releaseDate: releaseDate,
        title: title,
        video: video,
        voteAverage: voteAverage,
        voteCount: voteCount);
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

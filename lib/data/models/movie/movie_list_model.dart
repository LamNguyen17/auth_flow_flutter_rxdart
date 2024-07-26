import 'package:auth_flow_flutter_rxdart/domain/entities/movie/movie_list.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie_list_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MovieListResponse {
  final int? page;
  final List<ResultItemResponse>? results;
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
class ResultItemResponse {
  final bool? adult;
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
  @JsonKey(name: 'genre_ids')
  final List<int>? genreIds;
  final int? id;
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

  ResultItemResponse(
      {this.adult,
      this.backdropPath,
      this.genreIds,
      this.id,
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

  factory ResultItemResponse.fromJson(Map<String, dynamic> json) =>
      _$ResultItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ResultItemResponseToJson(this);

  ResultItem toEntity() {
    return ResultItem(
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
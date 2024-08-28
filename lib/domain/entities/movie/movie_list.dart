import 'package:equatable/equatable.dart';

class MovieList extends Equatable {
  int? page;
  List<MovieItem>? results;
  int? totalPages;
  int? totalResults;

  MovieList({
    this.page,
    this.results,
    this.totalPages,
    this.totalResults,
  });

  @override
  List<Object?> get props => [page, results, totalPages, totalResults];
}

class MovieItem extends Equatable {
  bool? adult;
  String? backdropPath;
  List<int>? genreIds;
  int? budget;
  List<Genre>? genres;
  int id;
  String? originalLanguage;
  String? originalTitle;
  String? overview;
  double? popularity;
  String? posterPath;
  String? releaseDate;
  String? title;
  bool? video;
  double? voteAverage;
  int? voteCount;
  String? status;
  int? revenue;

  MovieItem({
    this.status,
    this.revenue,
    this.adult,
    this.backdropPath,
    this.genreIds,
    this.budget,
    this.genres,
    required this.id,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
  });

  @override
  List<Object?> get props => [
        status,
        revenue,
        adult,
        backdropPath,
        genreIds,
        budget,
        genres,
        id,
        originalLanguage,
        originalTitle,
        overview,
        popularity,
        posterPath,
        releaseDate,
        title,
        video,
        voteAverage,
        voteCount,
      ];
}

class Genre extends Equatable {
  int? id;
  String? name;

  Genre({
    this.id,
    this.name,
  });

  @override
  List<Object?> get props => [id, name];
}

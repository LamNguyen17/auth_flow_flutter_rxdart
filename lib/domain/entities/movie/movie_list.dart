import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class MovieList extends Equatable {
  final int? page;
  final List<MovieItem>? results;
  final int? totalPages;
  final int? totalResults;

  const MovieList({
    this.page,
    this.results,
    this.totalPages,
    this.totalResults,
  });

  @override
  List<Object?> get props => [page, results, totalPages, totalResults];
}

@immutable
class MovieItem extends Equatable {
  final bool? adult;
  final String? backdropPath;
  final List<int>? genreIds;
  final int? budget;
  final List<Genre>? genres;
  final int id;
  final String? originalLanguage;
  final String? originalTitle;
  final String? overview;
  final double? popularity;
  final String? posterPath;
  final String? releaseDate;
  final String? title;
  final bool? video;
  final double? voteAverage;
  final int? voteCount;
  final String? status;
  final int? revenue;
  final String? docId;

  const MovieItem({
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
    this.docId,
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
        docId,
      ];
}

@immutable
class Genre extends Equatable {
  final int? id;
  final String? name;

  const Genre({
    this.id,
    this.name,
  });

  @override
  List<Object?> get props => [id, name];
}

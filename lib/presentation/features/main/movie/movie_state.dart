import 'package:auth_flow_flutter_rxdart/domain/entities/movie/movie_list.dart';
import 'package:equatable/equatable.dart';

abstract class MovieStatus extends Equatable {
  const MovieStatus();

  @override
  List<Object> get props => [];
}

class MovieInitial extends MovieStatus {
  const MovieInitial();
}

class MovieLoading extends MovieStatus {
  const MovieLoading();
}

class GenreMovieListSuccess extends MovieStatus {
  final dynamic data;

  const GenreMovieListSuccess(this.data);

  @override
  List<Object> get props => [data];
}

class GenreMovieListError extends MovieStatus {
  final String message;

  const GenreMovieListError(this.message);

  @override
  List<Object> get props => [message];
}

class MovieListSuccess extends MovieStatus {
  final MovieList? data;
  final String type;

  const MovieListSuccess(this.data, this.type);

  @override
  List<Object> get props => [type];
}

class MovieListError extends MovieStatus {
  final String message;

  const MovieListError(this.message);

  @override
  List<Object> get props => [message];
}

class MovieDetailSuccess extends MovieStatus {
  final dynamic data;

  const MovieDetailSuccess(this.data);

  @override
  List<Object> get props => [data];
}

class MovieDetailError extends MovieStatus {
  final String message;

  const MovieDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class MovieKeywordSuccess extends MovieStatus {
  final dynamic data;

  const MovieKeywordSuccess(this.data);

  @override
  List<Object> get props => [data];
}

class MovieKeywordError extends MovieStatus {
  final String message;

  const MovieKeywordError(this.message);

  @override
  List<Object> get props => [message];
}

class MovieSimilarSuccess extends MovieStatus {
  final MovieList data;

  const MovieSimilarSuccess(this.data);

  @override
  List<Object> get props => [data];
}

class MovieSimilarError extends MovieStatus {
  final String message;

  const MovieSimilarError(this.message);

  @override
  List<Object> get props => [message];
}

class MovieRecommendationSuccess extends MovieStatus {
  final MovieList data;

  const MovieRecommendationSuccess(this.data);

  @override
  List<Object> get props => [data];
}

class MovieRecommendationError extends MovieStatus {
  final String message;

  const MovieRecommendationError(this.message);

  @override
  List<Object> get props => [message];
}

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
  final dynamic data;
  const MovieListSuccess(this.data);

  @override
  List<Object> get props => [data];
}

class MovieListError extends MovieStatus {
  final String message;

  const MovieListError(this.message);

  @override
  List<Object> get props => [message];
}

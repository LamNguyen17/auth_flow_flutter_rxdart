import 'package:dartz/dartz.dart';

import 'package:auth_flow_flutter_rxdart/common/extensions/failure.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/movie/request/request_movie_list.dart';
import 'package:auth_flow_flutter_rxdart/domain/entities/movie/movie_detail.dart';
import 'package:auth_flow_flutter_rxdart/domain/entities/movie/movie_list.dart';
import 'package:auth_flow_flutter_rxdart/domain/entities/movie/genre_movie_list.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<GenreMovieList>>> getGenreMovieList(String type);
  Future<Either<Failure, MovieDetail>> getMovieDetails(int id);
  Stream<Either<Failure, MovieList>> getMovieList(RequestMovieList request);
}
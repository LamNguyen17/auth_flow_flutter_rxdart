import 'package:dartz/dartz.dart';

import 'package:auth_flow_flutter_rxdart/domain/entities/movie/genre_movie_list.dart';
import 'package:auth_flow_flutter_rxdart/domain/repositories/movie_repository.dart';
import 'package:auth_flow_flutter_rxdart/common/extensions/failure.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/base_usecase.dart';

class GetGenreMovieListUseCase implements BaseUseCase<List<GenreMovieList>, String> {
  final MovieRepository repository;
  GetGenreMovieListUseCase(this.repository);

  @override
  Future<Either<Failure, List<GenreMovieList>>> execute(String type) {
    return repository.genreMovieList(type);
  }
}

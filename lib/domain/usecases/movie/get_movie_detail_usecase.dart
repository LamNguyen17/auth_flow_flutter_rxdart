import 'package:dartz/dartz.dart';

import 'package:auth_flow_flutter_rxdart/domain/entities/movie/movie_list.dart';
import 'package:auth_flow_flutter_rxdart/common/extensions/failure.dart';
import 'package:auth_flow_flutter_rxdart/domain/repositories/movie_repository.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/base_usecase.dart';

class GetMovieDetailUseCase implements BaseUseCase<MovieItem, int> {
  final MovieRepository repository;

  GetMovieDetailUseCase(this.repository);

  @override
  Future<Either<Failure, MovieItem>> execute(int id) {
    return repository.getMovieDetails(id);
  }
}

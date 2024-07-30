import 'package:dartz/dartz.dart';

import 'package:auth_flow_flutter_rxdart/domain/entities/movie/movie_detail.dart';
import 'package:auth_flow_flutter_rxdart/common/extensions/failure.dart';
import 'package:auth_flow_flutter_rxdart/domain/repositories/movie_repository.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/base_usecase.dart';

class GetMovieDetailUseCase implements BaseUseCase<MovieDetail, int> {
  final MovieRepository repository;

  GetMovieDetailUseCase(this.repository);

  @override
  Future<Either<Failure, MovieDetail>> execute(int id) {
    return repository.getMovieDetails(id);
  }
}

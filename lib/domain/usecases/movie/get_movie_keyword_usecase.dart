import 'package:dartz/dartz.dart';

import 'package:auth_flow_flutter_rxdart/common/extensions/failure.dart';
import 'package:auth_flow_flutter_rxdart/domain/entities/movie/movie_keyword.dart';
import 'package:auth_flow_flutter_rxdart/domain/repositories/movie_repository.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/base_usecase.dart';

class GetMovieKeywordUseCase implements BaseUseCase<MovieKeyword, int> {
  final MovieRepository repository;
  GetMovieKeywordUseCase(this.repository);

  @override
  Future<Either<Failure, MovieKeyword>> execute(int id) {
    return repository.getMovieKeywords(id);
  }
}
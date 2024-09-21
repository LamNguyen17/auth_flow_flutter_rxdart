import 'package:dartz/dartz.dart';

import 'package:auth_flow_flutter_rxdart/common/extensions/failure.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/movie/request/request_movie_list.dart';
import 'package:auth_flow_flutter_rxdart/domain/entities/movie/movie_list.dart';
import 'package:auth_flow_flutter_rxdart/domain/repositories/movie_repository.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/base_usecase.dart';

class GetMovieListUseCase implements StreamBaseUseCase<MovieList, RequestMovieList> {
  final MovieRepository repository;
  GetMovieListUseCase(this.repository);

  @override
  Stream<Either<Failure, MovieList>> execute(RequestMovieList request) {
    return repository.getMovieList(request);
  }
}

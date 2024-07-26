import 'package:auth_flow_flutter_rxdart/domain/usecases/movie/request/request_movie_list.dart';
import 'package:dartz/dartz.dart';

import 'package:auth_flow_flutter_rxdart/data/datasources/movie_remote_data_source.dart';
import 'package:auth_flow_flutter_rxdart/common/extensions/failure.dart';
import 'package:auth_flow_flutter_rxdart/common/services/network_service.dart';
import 'package:auth_flow_flutter_rxdart/domain/entities/movie/genre_movie_list.dart';
import 'package:auth_flow_flutter_rxdart/domain/entities/movie/movie_list.dart';
import 'package:auth_flow_flutter_rxdart/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final NetworkService _networkService;
  final MovieRemoteDataSource _remoteDataSource;

  MovieRepositoryImpl(this._remoteDataSource, this._networkService);

  @override
  Stream<Either<Failure, GenreMovieList>> genreMovieList(String type) async* {
    final isConnected = await _networkService.isConnected;
    if (isConnected) {
      try {
        await for (final response in _remoteDataSource.genreMovieList(type)) {
          yield Right(response.toEntity());
        }
      } on Exception catch (e) {
        yield Left(ServerFailure(e.toString() ?? 'Lỗi hệ thống'));
      }
    } else {
      yield const Left(ConnectionFailure('Lỗi kết nối mạng'));
    }
  }

  @override
  Stream<Either<Failure, MovieList>> getMovieList(RequestMovieList request) async* {
    final isConnected = await _networkService.isConnected;
    if (isConnected) {
      try {
        await for (final response in _remoteDataSource.getMovieList(request)) {
          yield Right(response.toEntity());
        }
      } on Exception catch (e) {
        yield Left(ServerFailure(e.toString() ?? 'Lỗi hệ thống'));
      }
    } else {
      yield const Left(ConnectionFailure('Lỗi kết nối mạng'));
    }
  }
}

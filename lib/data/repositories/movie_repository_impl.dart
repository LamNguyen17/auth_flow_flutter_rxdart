import 'package:dartz/dartz.dart';

import 'package:auth_flow_flutter_rxdart/common/extensions/failure.dart';
import 'package:auth_flow_flutter_rxdart/common/services/network_service.dart';
import 'package:auth_flow_flutter_rxdart/data/datasources/movie_remote_data_source.dart';
import 'package:auth_flow_flutter_rxdart/domain/entities/movie/movie_keyword.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/movie/request/request_movie_list.dart';
import 'package:auth_flow_flutter_rxdart/domain/entities/movie/genre_movie_list.dart';
import 'package:auth_flow_flutter_rxdart/domain/entities/movie/movie_list.dart';
import 'package:auth_flow_flutter_rxdart/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final NetworkService _networkService;
  final MovieRemoteDataSource _remoteDataSource;

  MovieRepositoryImpl(this._remoteDataSource, this._networkService);

  @override
  Future<Either<Failure, List<GenreMovieList>>> getGenreMovieList(String type) async {
    final isConnected = await _networkService.isConnected;
    if (isConnected) {
      try {
        final response = await _remoteDataSource.getGenreMovieList(type);
        return Right(response.map((e) => e.toEntity()).toList());
      } on Exception catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(ConnectionFailure('Lỗi kết nối mạng'));
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
        yield Left(ServerFailure(e.toString()));
      }
    } else {
      yield const Left(ConnectionFailure('Lỗi kết nối mạng'));
    }
  }

  @override
  Future<Either<Failure, MovieItem>> getMovieDetails(int id) async {
    final isConnected = await _networkService.isConnected;
    if (isConnected) {
      try {
        final response = await _remoteDataSource.getMovieDetail(id);
        return Right(response.toEntity());
      } on Exception catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(ConnectionFailure('Lỗi kết nối mạng'));
    }
  }

  @override
  Future<Either<Failure, MovieKeyword>> getMovieKeywords(int id) async {
    final isConnected = await _networkService.isConnected;
    if (isConnected) {
      try {
        final response = await _remoteDataSource.getMovieKeywords(id);
        return Right(response.toEntity());
      } on Exception catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(ConnectionFailure('Lỗi kết nối mạng'));
    }
  }

  @override
  Future<Either<Failure, MovieList>> getMovieRecommendation(int id) async {
    final isConnected = await _networkService.isConnected;
    if (isConnected) {
      try {
        final response = await _remoteDataSource.getMovieRecommendation(id);
        return Right(response.toEntity());
      } on Exception catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(ConnectionFailure('Lỗi kết nối mạng'));
    }
  }

  @override
  Future<Either<Failure, MovieList>> getMovieSimilar(int id) async {
    final isConnected = await _networkService.isConnected;
    if (isConnected) {
      try {
        final response = await _remoteDataSource.getMovieSimilar(id);
        return Right(response.toEntity());
      } on Exception catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(ConnectionFailure('Lỗi kết nối mạng'));
    }
  }
}

import 'package:auth_flow_flutter_rxdart/domain/usecases/favourite/add_favourite_use_case.dart';
import 'package:dartz/dartz.dart';

import 'package:auth_flow_flutter_rxdart/common/extensions/failure.dart';
import 'package:auth_flow_flutter_rxdart/common/services/network_service.dart';
import 'package:auth_flow_flutter_rxdart/data/datasources/favourite_remote_data_source.dart';
import 'package:auth_flow_flutter_rxdart/domain/repositories/favourite_repository.dart';

class FavouriteRepositoryImpl implements FavouriteRepository {
  final NetworkService _networkService;
  final FavouriteRemoteDataSource _remoteDataSource;

  FavouriteRepositoryImpl(this._remoteDataSource, this._networkService);

  @override
  Future<Either<Failure, dynamic>> addFavourite(ReqAddFavouriteCommand req) async {
    var isConnected = await _networkService.isConnected;
    if (isConnected) {
      try {
        var response = await _remoteDataSource.addFavourite(req);
        return Right(response);
      } on Exception catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(ConnectionFailure('Lỗi kết nối mạng'));
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> getFavouriteList() async {
    var isConnected = await _networkService.isConnected;
    if (isConnected) {
      try {
        var response = await _remoteDataSource.getFavouriteList();
        return Right(response);
      } on Exception catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(ConnectionFailure('Lỗi kết nối mạng'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> removeFavourite(String id) async {
    var isConnected = await _networkService.isConnected;
    if (isConnected) {
      try {
        var response = await _remoteDataSource.removeFavourite(id);
        return Right(response);
      } on Exception catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(ConnectionFailure('Lỗi kết nối mạng'));
    }
  }
}
import 'package:auth_flow_flutter_rxdart/data/datasources/auth_remote_data_source.dart';
import 'package:dartz/dartz.dart';

import 'package:auth_flow_flutter_rxdart/common/extensions/failure.dart';
import 'package:auth_flow_flutter_rxdart/common/services/network_service.dart';
import 'package:auth_flow_flutter_rxdart/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final NetworkService _networkService;
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource, this._networkService);

  @override
  Future<Either<Failure, dynamic>> signInWithGoogle() async {
    var isConnected = await _networkService.isConnected;
    if (isConnected) {
      try {
        var response = await _remoteDataSource.signInWithGoogle();
        print('signInWithGoogle: $response');
        return Right(response);
      } on Exception catch (e) {
        return Left(ServerFailure(e.toString() ?? 'Lỗi hệ thống'));
      }
    } else {
      return const Left(ConnectionFailure('Lỗi kết nối mạng'));
    }
  }
}
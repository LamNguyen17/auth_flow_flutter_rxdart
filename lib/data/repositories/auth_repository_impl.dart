import 'package:auth_flow_flutter_rxdart/common/mapping/auth_error_mapping.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:auth_flow_flutter_rxdart/common/extensions/failure.dart';
import 'package:auth_flow_flutter_rxdart/common/services/network_service.dart';
import 'package:auth_flow_flutter_rxdart/data/datasources/auth_remote_data_source.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/sign_in_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/entities/auth/customer.dart';
import 'package:auth_flow_flutter_rxdart/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final NetworkService _networkService;
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource, this._networkService);

  @override
  Future<Either<Failure, Customer>> signInWithGoogle() async {
    var isConnected = await _networkService.isConnected;
    if (isConnected) {
      try {
        var response = await _remoteDataSource.signInWithGoogle();
        print('signInWithGoogle: ${response.toEntity()}');
        return Right(response.toEntity());
      } on FirebaseAuthException catch (e) {
        return Left(ServerFailure(authErrorMapping[e.code].toString()));
      } on Exception catch (e) {
        return Left(ServerFailure(e.toString() ?? 'Lỗi hệ thống'));
      }
    } else {
      return const Left(ConnectionFailure('Lỗi kết nối mạng'));
    }
  }

  @override
  Future<Either<Failure, Customer>> signIn(ReqLoginCommand params) async {
    var isConnected = await _networkService.isConnected;
    if (isConnected) {
      try {
        var response = await _remoteDataSource.signIn(params);
        print('signIn: ${response.toEntity()}');
        return Right(response.toEntity());
      } on FirebaseAuthException catch (e) {
        return Left(ServerFailure(authErrorMapping[e.code].toString()));
      } on Exception catch (e) {
        return Left(ServerFailure(e.toString() ?? 'Lỗi hệ thống'));
      }
    } else {
      return const Left(ConnectionFailure('Lỗi kết nối mạng'));
    }
  }
}
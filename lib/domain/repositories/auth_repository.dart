import 'package:dartz/dartz.dart';

import 'package:auth_flow_flutter_rxdart/common/extensions/failure.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/sign_in_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/entities/auth/customer.dart';

abstract class AuthRepository {
  Future<Either<Failure, Customer>> signInWithGoogle();
  Future<Either<Failure, Customer>> signInWithFacebook();
  Future<Either<Failure, Customer>> signIn(ReqLoginCommand params);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, Customer>> getProfile();
}
import 'package:dartz/dartz.dart';
import 'package:auth_flow_flutter_rxdart/common/extensions/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, dynamic>> signInWithGoogle();
}
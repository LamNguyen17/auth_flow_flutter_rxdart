import 'package:dartz/dartz.dart';

import 'package:auth_flow_flutter_rxdart/common/extensions/failure.dart';
import 'package:auth_flow_flutter_rxdart/domain/entities/auth/customer.dart';
import 'package:auth_flow_flutter_rxdart/domain/repositories/auth_repository.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/base_usecase.dart';

class SignInWithAppleUseCase implements BaseUseCase<Customer, NoParams> {
  final AuthRepository repository;
  SignInWithAppleUseCase(this.repository);

  @override
  Future<Either<Failure, Customer>> execute(NoParams params) async {
    return await repository.signInWithApple();
  }
}
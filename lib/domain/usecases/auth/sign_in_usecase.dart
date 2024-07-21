import 'package:dartz/dartz.dart';

import 'package:auth_flow_flutter_rxdart/common/extensions/failure.dart';
import 'package:auth_flow_flutter_rxdart/domain/entities/auth/customer.dart';
import 'package:auth_flow_flutter_rxdart/domain/repositories/auth_repository.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/base_usecase.dart';
import 'package:equatable/equatable.dart';

class SignInUseCase implements BaseUseCase<Customer, ReqLoginCommand> {
  final AuthRepository repository;
  SignInUseCase(this.repository);

  @override
  Future<Either<Failure, Customer>> execute(ReqLoginCommand params) async {
    return await repository.signIn(params);
  }
}

class ReqLoginCommand extends Equatable {
  final String email;
  final String password;

  const ReqLoginCommand(this.email, this.password);

  @override
  List<Object> get props => [email, password];

  @override
  String toString() {
    return 'ReqLoginCommand{data: $email - $password}';
  }
}
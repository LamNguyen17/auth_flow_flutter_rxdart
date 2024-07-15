import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:auth_flow_flutter_rxdart/common/extensions/failure.dart';
import 'package:auth_flow_flutter_rxdart/domain/entities/auth/customer.dart';
import 'package:auth_flow_flutter_rxdart/domain/repositories/auth_repository.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/base_usecase.dart';

class RegisterUseCase implements BaseUseCase<Customer, ReqRegisterCommand> {
  final AuthRepository repository;
  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, Customer>> execute(ReqRegisterCommand params) async {
    return await repository.register(params);
  }
}

class ReqRegisterCommand extends Equatable {
  final String email;
  final String password;

  const ReqRegisterCommand(this.email, this.password);

  @override
  List<Object> get props => [email, password];

  @override
  String toString() {
    return 'ReqRegisterCommand{data: $email - $password}';
  }
}
import 'package:dartz/dartz.dart';

import 'package:auth_flow_flutter_rxdart/common/extensions/failure.dart';
import 'package:auth_flow_flutter_rxdart/domain/repositories/auth_repository.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/base_usecase.dart';

class LogoutUseCase implements BaseUseCase<void, NoParams> {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  @override
  Future<Either<Failure, void>> execute(NoParams params) async {
    return await repository.logout();
  }
}

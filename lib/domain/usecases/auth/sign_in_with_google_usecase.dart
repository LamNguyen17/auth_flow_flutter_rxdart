import 'package:dartz/dartz.dart';

import 'package:auth_flow_flutter_rxdart/common/extensions/failure.dart';
import 'package:auth_flow_flutter_rxdart/domain/repositories/auth_repository.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/base_usecase.dart';

class SignInWithGoogleUseCase implements BaseUseCase<dynamic, NoParams> {
  final AuthRepository repository;
  SignInWithGoogleUseCase(this.repository);

  @override
  Future<Either<Failure, dynamic>> execute(NoParams params) async {
    return await repository.signInWithGoogle();
  }
}
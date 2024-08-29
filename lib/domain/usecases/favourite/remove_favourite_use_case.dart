import 'package:dartz/dartz.dart';

import 'package:auth_flow_flutter_rxdart/common/extensions/failure.dart';
import 'package:auth_flow_flutter_rxdart/domain/repositories/favourite_repository.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/base_usecase.dart';

class RemoveFavouriteUseCase implements BaseUseCase<dynamic, String> {
  final FavouriteRepository repository;
  RemoveFavouriteUseCase(this.repository);

  @override
  Future<Either<Failure, dynamic>> execute(String id) {
    return repository.removeFavourite(id);
  }
}

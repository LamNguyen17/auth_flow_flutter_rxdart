import 'package:dartz/dartz.dart';

import 'package:auth_flow_flutter_rxdart/common/extensions/failure.dart';
import 'package:auth_flow_flutter_rxdart/domain/repositories/favourite_repository.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/base_usecase.dart';

class GetFavouriteListUseCase implements BaseUseCase<List<dynamic>, NoParams> {
  final FavouriteRepository repository;
  GetFavouriteListUseCase(this.repository);

  @override
  Future<Either<Failure, List<dynamic>>> execute(NoParams params) {
    return repository.getFavouriteList();
  }
}

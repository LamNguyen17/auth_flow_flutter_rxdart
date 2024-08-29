import 'package:auth_flow_flutter_rxdart/domain/usecases/favourite/add_favourite_use_case.dart';
import 'package:dartz/dartz.dart';

import 'package:auth_flow_flutter_rxdart/common/extensions/failure.dart';

abstract class FavouriteRepository {
  Future<Either<Failure, List<dynamic>>> getFavouriteList();
  Future<Either<Failure, dynamic>> addFavourite(ReqAddFavouriteCommand req);
  Future<Either<Failure, dynamic>> removeFavourite(String id);
}
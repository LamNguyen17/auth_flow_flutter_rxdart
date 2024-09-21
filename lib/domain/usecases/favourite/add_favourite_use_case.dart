import 'package:dartz/dartz.dart';

import 'package:auth_flow_flutter_rxdart/common/extensions/failure.dart';
import 'package:auth_flow_flutter_rxdart/domain/repositories/favourite_repository.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/base_usecase.dart';
import 'package:equatable/equatable.dart';

class AddFavouriteUseCase implements BaseUseCase<dynamic, ReqAddFavouriteCommand> {
  final FavouriteRepository repository;
  AddFavouriteUseCase(this.repository);

  @override
  Future<Either<Failure, dynamic>> execute(ReqAddFavouriteCommand req) {
    return repository.addFavourite(req);
  }
}

class ReqAddFavouriteCommand extends Equatable {
  final int id;
  final String? title;
  final String? posterPath;
  final double? voteAverage;

  const ReqAddFavouriteCommand(this.id, this.title, this.posterPath, this.voteAverage);

  @override
  List<Object> get props => [id];
}
import 'dart:async';

import 'package:auth_flow_flutter_rxdart/domain/usecases/favourite/get_favourite_list_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:rxdart/rxdart.dart';

import 'package:auth_flow_flutter_rxdart/common/extensions/debug_stream.dart';
import 'package:auth_flow_flutter_rxdart/common/extensions/bloc_provider.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/favourite/add_favourite_use_case.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/favourite/remove_favourite_use_case.dart';


class FavouriteItemBloc extends BlocBase {
  /// Input
  final Function0<void> disposeBag;
  final Sink<ReqAddFavouriteCommand> addFavourite;
  final Sink<String> removeFavourite;

  /// Output
  final Stream<bool> isFavorite$;

  @override
  void dispose() {
    disposeBag();
  }

  factory FavouriteItemBloc(
    GetFavouriteListUseCase getFavouriteListUseCase,
    AddFavouriteUseCase addFavouriteUseCase,
    RemoveFavouriteUseCase removeFavouriteUseCase,
  ) {
    final isLoading = BehaviorSubject<bool>.seeded(false);
    final addFavourite = BehaviorSubject<ReqAddFavouriteCommand>();
    final removeFavourite = BehaviorSubject<String>();

    final Stream<bool> addFavourite$ =
        addFavourite.exhaustMap((ReqAddFavouriteCommand request) {
      isLoading.add(true);
      return Stream.fromFuture(addFavouriteUseCase.execute(request))
          .flatMap((either) {
        isLoading.add(false);
        return either.fold(
            (error) => Stream.value(false), (data) => Stream.value(true));
      }).debug();
    });
    final Stream<bool> removeFavourite$ =
        removeFavourite.exhaustMap((String id) {
      isLoading.add(true);
      return Stream.fromFuture(removeFavouriteUseCase.execute(id))
          .flatMap((either) {
        isLoading.add(false);
        return either.fold(
            (error) => Stream.value(true), (data) => Stream.value(false));
      }).debug();
    });
    final Stream<bool> isFavorite$ =
        Rx.merge([addFavourite$, removeFavourite$]);

    return FavouriteItemBloc._(
        addFavourite: addFavourite,
        removeFavourite: removeFavourite,
        isFavorite$: isFavorite$,
        disposeBag: () {
          isLoading.close();
          addFavourite.close();
          removeFavourite.close();
        });
  }

  FavouriteItemBloc._({
    required this.addFavourite,
    required this.removeFavourite,
    required this.disposeBag,
    required this.isFavorite$,
  });
}

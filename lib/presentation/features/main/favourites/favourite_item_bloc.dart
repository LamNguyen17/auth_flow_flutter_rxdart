import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:rxdart/rxdart.dart';

import 'package:auth_flow_flutter_rxdart/di/injection.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/favourites/favourite_bloc.dart';
import 'package:auth_flow_flutter_rxdart/common/extensions/debug_stream.dart';
import 'package:auth_flow_flutter_rxdart/common/extensions/bloc_provider.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/favourite/add_favourite_use_case.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/favourite/remove_favourite_use_case.dart';

class FavouriteItemBloc extends BlocBase {
  final FavouriteBloc _favouriteBloc;

  /// Input
  final Function0<void> disposeBag;
  final Sink<ReqAddFavouriteCommand> addFavourite;
  final Sink<String> removeFavourite;

  /// Output
  final Stream<dynamic> isFavorite$;
  final Stream<bool> addFavourite$;
  final Stream<bool> removeFavourite$;

  @override
  void dispose() {
    disposeBag();
    _favouriteBloc.dispose();
  }

  factory FavouriteItemBloc(
    AddFavouriteUseCase addFavouriteUseCase,
    RemoveFavouriteUseCase removeFavouriteUseCase,
  ) {
    final favouriteBloc = injector.get<FavouriteBloc>();
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

    final Stream<bool> removeFavourite$ = removeFavourite
        .exhaustMap((String id) {
          isLoading.add(true);
          return Stream.fromFuture(removeFavouriteUseCase.execute(id))
              .flatMap((either) {
            isLoading.add(false);
            return either.fold((error) => Stream.value(true), (data) {
              print('removeFavourite: $id');
              favouriteBloc.getFavouriteList.add(null);
              return Stream.value(false);
            });
          }).debug();
        })
        .publishReplay(maxSize: 1)
        .autoConnect();

    final Stream<dynamic> isFavorite$ =
        Rx.merge([addFavourite$]).whereNotNull().publish();

    return FavouriteItemBloc._(
        favouriteBloc: favouriteBloc,
        addFavourite: addFavourite,
        addFavourite$: addFavourite$,
        removeFavourite: removeFavourite,
        removeFavourite$: removeFavourite$,
        isFavorite$: isFavorite$,
        disposeBag: () {
          isLoading.close();
          addFavourite.close();
          removeFavourite.close();
          favouriteBloc.dispose();
        });
  }

  FavouriteItemBloc._({
    required this.addFavourite,
    required this.removeFavourite,
    required this.disposeBag,
    required this.isFavorite$,
    required this.addFavourite$,
    required this.removeFavourite$,
    required FavouriteBloc favouriteBloc,
  }) : _favouriteBloc = favouriteBloc;
}

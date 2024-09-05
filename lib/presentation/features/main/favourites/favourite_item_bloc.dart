import 'dart:async';

import 'package:auth_flow_flutter_rxdart/di/injection.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/favourite/get_favourite_list_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:rxdart/rxdart.dart';

import 'package:auth_flow_flutter_rxdart/presentation/features/main/favourites/favourite_bloc.dart';
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
    final StreamSubscription<dynamic> removeFavourite$ =
        removeFavourite.exhaustMap((String id) {
      print('removeFavourite_either: $id');
      isLoading.add(true);
      return Stream.fromFuture(removeFavouriteUseCase.execute(id))
          .flatMap((either) {
        isLoading.add(false);
        return either.fold((error) => Stream.value(false), (data) {
          print('removeFavourite_either_1: $id');
          return Stream.value(true);
        });
      }).debug();
    }).listen((event) {
      print('removeFavourite_either_2: $event');
      favouriteBloc.getFavouriteList.add(null);
    });

    final Stream<bool> isFavorite$ = Rx.merge([addFavourite$]);

    return FavouriteItemBloc._(
        favouriteBloc: favouriteBloc,
        addFavourite: addFavourite,
        removeFavourite: removeFavourite,
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
    required FavouriteBloc favouriteBloc,
  });
}

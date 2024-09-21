import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:rxdart/rxdart.dart';

import 'package:auth_flow_flutter_rxdart/domain/usecases/favourite/add_favourite_use_case.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/favourite/remove_favourite_use_case.dart';
import 'package:auth_flow_flutter_rxdart/common/extensions/debug_stream.dart';
import 'package:auth_flow_flutter_rxdart/common/extensions/bloc_provider.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/base_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/favourite/get_favourite_list_use_case.dart';

class FavouriteBloc extends BlocBase {
  /// Input
  final Function0<void> disposeBag;
  final Sink<void> getFavouriteList;

  /// Output
  final Stream<dynamic> favoriteList$;

  @override
  void dispose() {
    disposeBag();
  }

  factory FavouriteBloc(
    GetFavouriteListUseCase getFavouriteListUseCase,
    AddFavouriteUseCase addFavouriteUseCase,
    RemoveFavouriteUseCase removeFavouriteUseCase,
  ) {
    final getFavouriteList = BehaviorSubject<void>();
    final isLoading = BehaviorSubject<bool>.seeded(false);

    final Stream<dynamic> favoriteList$ = getFavouriteList
        .exhaustMap((_) {
          isLoading.add(true);
          return Stream.fromFuture(getFavouriteListUseCase.execute(NoParams()))
              .flatMap((either) {
            isLoading.add(false);
            return either.fold(
                (error) => Stream.value(error), (data) => Stream.value(data));
          }).debug();
        })
        .publishReplay(maxSize: 1)
        .autoConnect();

    return FavouriteBloc._(
        getFavouriteList: getFavouriteList,
        favoriteList$: favoriteList$,
        disposeBag: () {
          getFavouriteList.close();
          isLoading.close();
        });
  }

  FavouriteBloc._({
    required this.getFavouriteList,
    required this.disposeBag,
    required this.favoriteList$,
  });
}

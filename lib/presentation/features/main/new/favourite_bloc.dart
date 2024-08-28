import 'dart:async';

import 'package:auth_flow_flutter_rxdart/domain/entities/movie/movie_list.dart';
import 'package:dartz/dartz.dart';
import 'package:rxdart/rxdart.dart';

import 'package:auth_flow_flutter_rxdart/common/extensions/bloc_provider.dart';

class FavouriteBloc extends BlocBase {

  /// Input
  final Function0<void> disposeBag;
  final Sink<MovieItem> updateFavorite;

  /// Output
  final Stream<bool> isFavorite$;
  final Stream<List<MovieItem>> favoriteList$;

  @override
  void dispose() {
    disposeBag();
  }

  factory FavouriteBloc() {
    final isFavorite = BehaviorSubject<bool>.seeded(false);
    final updateFavorite = BehaviorSubject<MovieItem>();
    final favoriteList = BehaviorSubject<List<MovieItem>>();
    final List<MovieItem> appendFavorites = [];

    final updateFavorite$ = updateFavorite.flatMap((MovieItem item) {
      return Stream.value(item);
    });
    updateFavorite$.listen((event) {
      if (appendFavorites.any((MovieItem item) => item.id == event.id)) {
        appendFavorites.removeWhere((MovieItem item) => item.id == event.id);
        isFavorite.add(false);
      } else {
        appendFavorites.add(event);
        isFavorite.add(true);
      }
      favoriteList.add(appendFavorites);
    });


    // final isFavorite$ = isFavorite.stream.shareValue();
    // favoriteList.stream.map((list) => list.any((dynamic item) {
    //       if (item.id == item.id) {
    //         isFavorite.add(true);
    //         return true;
    //       } else {
    //         return false;
    //       }
    //     }));
    // final isFavorite$ = isFavorite.stream.shareValue();

    return FavouriteBloc._(
        updateFavorite: updateFavorite,
        isFavorite$: isFavorite.asBroadcastStream(),
        favoriteList$: favoriteList.asBroadcastStream(),
        disposeBag: () {
          isFavorite.close();
          favoriteList.close();
          print('FavouriteBloc_disposeBag');
        });
  }

  FavouriteBloc._({
    required this.updateFavorite,
    required this.disposeBag,
    required this.isFavorite$,
    required this.favoriteList$,
  });
}

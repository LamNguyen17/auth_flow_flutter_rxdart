import 'package:dartz/dartz.dart';
import 'package:rxdart/rxdart.dart';

class FavouriteBloc {
  /// Input
  final Function0<void> disposeBag;
  final Sink<bool> isFavorite;
  final Sink<List<dynamic>> favoriteList;

  /// Output
  final Stream<List<dynamic>> favoriteList$;

  factory FavouriteBloc(){
    final isFavorite = BehaviorSubject<bool>.seeded(false);
    final favoriteList = BehaviorSubject<List<dynamic>>();

    return FavouriteBloc._(
        isFavorite: isFavorite,
        favoriteList: favoriteList,
        favoriteList$: favoriteList.asBroadcastStream(),
        disposeBag: () {
          print('disposeBag');
        }
    );
  }

  FavouriteBloc._({
    required this.disposeBag,
    required this.isFavorite,
    required this.favoriteList,
    required this.favoriteList$,
  });
}
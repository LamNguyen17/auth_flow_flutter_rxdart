import 'dart:async';

import 'package:auth_flow_flutter_rxdart/domain/usecases/movie/get_genre_movie_list_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/movie/get_movie_list_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:rxdart/rxdart.dart';

import 'package:auth_flow_flutter_rxdart/di/injection.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_bloc.dart';

class HomeBloc {
  final _movieBloc = injector.get<MovieBloc>();
  /// Input
  final Function0<void> dispose;

  /// Output

  void close() {
    _movieBloc.dispose();
    dispose();
  }

  factory HomeBloc() {

    return HomeBloc._(
      dispose: () {},
    );
  }

  HomeBloc._({
    required this.dispose,
  });
}

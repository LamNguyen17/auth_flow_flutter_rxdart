import 'package:auth_flow_flutter_rxdart/domain/usecases/movie/request/request_movie_list.dart';
import 'package:dartz/dartz.dart';
import 'package:rxdart/rxdart.dart';

import 'package:auth_flow_flutter_rxdart/domain/usecases/movie/get_genre_movie_list_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/movie/get_movie_list_usecase.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_state.dart';

class MovieBloc {
  /// Input
  final Function0<void> dispose;
  final Sink<void> getPopular;

  /// Output
  final Stream<bool> isLoading$;
  final Stream<MovieStatus> getPopularError$;

  factory MovieBloc(
    GetGenreMovieListUseCase getGenreMovieListUseCase,
    GetMovieListUseCase getMovieListUseCase,
  ) {
    final isLoading = BehaviorSubject<bool>.seeded(false);
    final currentPage = BehaviorSubject<int>.seeded(1);
    final getPopular = BehaviorSubject<void>();

    final Stream<MovieStatus> getPopularError$ = getPopular
        .debounceTime(const Duration(milliseconds: 350))
        .exhaustMap((_) {
      return getMovieListUseCase
          .execute(RequestMovieList("popular", currentPage.value))
          .flatMap((either) => either.fold(
              (error) => Stream.value(MovieError(error.toString())),
              (data) => Stream.value(MovieSuccess(data))))
          .doOnDone(() => isLoading.add(false))
          .doOnError((error, _) => isLoading.add(false))
          .onErrorReturnWith(
              (error, _) => const MovieError("Đã có lỗi xảy ra"));
    });
    return MovieBloc._(
      isLoading$: isLoading.asBroadcastStream(),
      getPopular: getPopular,
      getPopularError$: getPopularError$,
      dispose: () {
        isLoading.close();
        getPopular.close();
      },
    );
  }

  MovieBloc._({
    required this.getPopular,
    required this.dispose,
    required this.isLoading$,
    required this.getPopularError$,
  });
}

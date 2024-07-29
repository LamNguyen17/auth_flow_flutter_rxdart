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
  final Sink<void> getGenreMovie;

  /// Output
  final Stream<bool> isLoading$;
  final Stream<MovieStatus> getPopularMessage$;
  final Stream<MovieStatus> getGenreMovieMessage$;

  factory MovieBloc(
    GetGenreMovieListUseCase getGenreMovieListUseCase,
    GetMovieListUseCase getMovieListUseCase,
  ) {
    final isLoading = BehaviorSubject<bool>.seeded(false);
    final currentPage = BehaviorSubject<int>.seeded(1);
    final getPopular = BehaviorSubject<void>();
    final getGenreMovie = BehaviorSubject<void>();

    final Stream<MovieStatus> getGenreMovieMessage$ = getGenreMovie
        .debounceTime(const Duration(milliseconds: 350))
        .exhaustMap((_) {
      isLoading.add(true);
      return getGenreMovieListUseCase
          .execute("movie")
          .flatMap((either) => either.fold(
              (error) => Stream.value(GenreMovieListError(error.toString())),
              (data) => Stream.value(GenreMovieListSuccess(data))))
          .doOnDone(() => isLoading.add(false))
          .doOnError((error, _) => isLoading.add(false))
          .onErrorReturnWith(
              (error, _) => const GenreMovieListError("Đã có lỗi xảy ra"));
    });

    final Stream<MovieStatus> getPopularMessage$ = getPopular
        .debounceTime(const Duration(milliseconds: 350))
        .exhaustMap((_) {
      isLoading.add(true);
      return getMovieListUseCase
          .execute(RequestMovieList("popular", currentPage.value))
          .flatMap((either) => either.fold(
              (error) => Stream.value(MovieListError(error.toString())),
              (data) => Stream.value(MovieListSuccess(data))))
          .doOnDone(() => isLoading.add(false))
          .doOnError((error, _) => isLoading.add(false))
          .onErrorReturnWith(
              (error, _) => const MovieListError("Đã có lỗi xảy ra"));
    });
    return MovieBloc._(
      isLoading$: isLoading.asBroadcastStream(),
      getPopular: getPopular,
      getGenreMovie: getGenreMovie,
      getPopularMessage$: getPopularMessage$,
      getGenreMovieMessage$: getGenreMovieMessage$,
      dispose: () {
        isLoading.close();
        getPopular.close();
        getGenreMovie.close();
      },
    );
  }

  MovieBloc._({
    required this.getPopular,
    required this.getGenreMovie,
    required this.dispose,
    required this.isLoading$,
    required this.getPopularMessage$,
    required this.getGenreMovieMessage$,
  });
}

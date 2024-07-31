import 'package:auth_flow_flutter_rxdart/domain/usecases/movie/get_movie_detail_usecase.dart';
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
  final Sink<int> getMovieDetail;

  /// Output
  final Stream<bool> isLoading$;
  final Stream<MovieStatus> getPopularMessage$;
  final Stream<MovieStatus> getGenreMovieMessage$;
  final Stream<MovieStatus> getMovieDetailMessage$;

  factory MovieBloc(
    GetGenreMovieListUseCase getGenreMovieListUseCase,
    GetMovieListUseCase getMovieListUseCase,
    GetMovieDetailUseCase getMovieDetailUseCase,
  ) {
    final isLoading = BehaviorSubject<bool>.seeded(false);
    final currentPage = BehaviorSubject<int>.seeded(1);
    final getPopular = BehaviorSubject<void>();
    final getGenreMovie = BehaviorSubject<void>();
    final getMovieDetail = BehaviorSubject<int>();

    final Stream<MovieStatus> getMovieDetailMessage$ = getMovieDetail
        .debounceTime(const Duration(milliseconds: 350))
        .exhaustMap((int id) {
      isLoading.add(true);
      return Stream.fromFuture(getMovieDetailUseCase.execute(id))
          .flatMap((either) => either.fold(
              (error) => Stream.value(MovieDetailError(error.toString())),
              (data) => Stream.value(MovieDetailSuccess(data))))
          .doOnDone(() => isLoading.add(false))
          .doOnError((error, _) => isLoading.add(false))
          .onErrorReturnWith(
              (error, _) => const MovieDetailError("Đã có lỗi xảy ra"));
    });

    final Stream<MovieStatus> getGenreMovieMessage$ = getGenreMovie
        .debounceTime(const Duration(milliseconds: 350))
        .exhaustMap((_) {
      isLoading.add(true);
      return Stream.fromFuture(getGenreMovieListUseCase.execute("movie"))
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
      print('getPopular');
      isLoading.add(true);
      return getMovieListUseCase
          .execute(RequestMovieList("popular", currentPage.value))
          .flatMap((either) => either.fold(
              (error) => Stream.value(MovieListError(error.toString())),
              (data) => Stream.value(MovieListSuccess(data, "popular"))))
          .doOnDone(() => isLoading.add(false))
          .doOnError((error, _) => isLoading.add(false))
          .onErrorReturnWith(
              (error, _) => const MovieListError("Đã có lỗi xảy ra"));
    });
    return MovieBloc._(
      isLoading$: isLoading.asBroadcastStream(),
      getPopular: getPopular,
      getGenreMovie: getGenreMovie,
      getMovieDetail: getMovieDetail,
      getPopularMessage$: getPopularMessage$,
      getGenreMovieMessage$: getGenreMovieMessage$,
      getMovieDetailMessage$: getMovieDetailMessage$,
      dispose: () {
        isLoading.close();
        getPopular.close();
        getGenreMovie.close();
        getMovieDetail.close();
      },
    );
  }

  MovieBloc._({
    required this.getPopular,
    required this.getGenreMovie,
    required this.getMovieDetail,
    required this.dispose,
    required this.isLoading$,
    required this.getPopularMessage$,
    required this.getGenreMovieMessage$,
    required this.getMovieDetailMessage$,
  });
}

import 'package:auth_flow_flutter_rxdart/common/extensions/bloc_provider.dart';
import 'package:auth_flow_flutter_rxdart/domain/entities/movie/movie_list.dart';
import 'package:dartz/dartz.dart';
import 'package:rxdart/rxdart.dart';

import 'package:auth_flow_flutter_rxdart/di/injection.dart';
import 'package:auth_flow_flutter_rxdart/di/injection_bloc.dart';
import 'package:auth_flow_flutter_rxdart/common/extensions/debug_stream.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/movie/get_movie_detail_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/movie/get_movie_keyword_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/movie/get_movie_recommendation_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/movie/get_movie_similar_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/movie/request/request_movie_list.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/movie/get_genre_movie_list_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/movie/get_movie_list_usecase.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_state.dart';

class MovieBloc extends BlocBase {
  /// Input
  final Function0<void> disposeBag;
  final Sink<bool> isCollapsed;
  final Sink<void> getPopular;
  final Sink<void> getGenreMovie;
  final Sink<int> getMovieDetail;
  final Sink<int> getMovieKeyword;
  final Sink<int> getMovieSimilar;
  final Sink<int> getMovieRecommendation;

  /// Output
  final Stream<bool> isCollapsed$;
  final Stream<bool> isLoading$;
  final Stream<MovieStatus> getPopularMessage$;
  final Stream<MovieStatus> getGenreMovieMessage$;
  final Stream<MovieStatus> getMovieDetailMessage$;
  final Stream<MovieStatus> getMovieKeywordMessage$;
  final Stream<MovieStatus> getMovieSimilarMessage$;
  final Stream<MovieStatus> getMovieRecommendationMessage$;

  @override
  void dispose() {
    print('MovieBloc_dispose');
    disposeBag();
  }

  factory MovieBloc(
    GetGenreMovieListUseCase getGenreMovieListUseCase,
    GetMovieListUseCase getMovieListUseCase,
    GetMovieDetailUseCase getMovieDetailUseCase,
    GetMovieKeywordUseCase getMovieKeywordUseCase,
    GetMovieSimilarUseCase getMovieSimilarUseCase,
    GetMovieRecommendationUseCase getMovieRecommendationUseCase,
  ) {
    final isCollapsed = BehaviorSubject<bool>.seeded(false);
    final isLoading = BehaviorSubject<bool>.seeded(false);
    final currentPage = BehaviorSubject<int>.seeded(1);
    final getPopular = BehaviorSubject<void>();
    final getGenreMovie = BehaviorSubject<void>();
    final getMovieDetail = BehaviorSubject<int>();
    final getMovieKeyword = BehaviorSubject<int>();
    final getMovieSimilar = BehaviorSubject<int>();
    final getMovieRecommendation = BehaviorSubject<int>();

    final Stream<bool> isCollapsed$ = isCollapsed
        .throttleTime(const Duration(milliseconds: 200))
        .switchMap((value) => Stream.value(value))
        .asBroadcastStream();

    /** region Get detail movie */
    final Stream<MovieStatus> getMovieDetailMessage$ = getMovieDetail
        .debounceTime(const Duration(milliseconds: 150))
        .exhaustMap((int id) {
      isLoading.add(true);
      return Stream.fromFuture(getMovieDetailUseCase.execute(id))
          .flatMap((either) {
            isLoading.add(false);
            return either.fold(
                (error) => Stream.value(MovieDetailError(error.toString())),
                (data) => Stream.value(MovieDetailSuccess(data)));
          })
          .debug()
          .onErrorReturnWith((error, _) {
            isLoading.add(false);
            return const MovieDetailError("Đã có lỗi xảy ra");
          });
    });
    /** endregion Get detail movie */

    /** region Get keyword movie */
    final Stream<MovieStatus> getMovieKeywordMessage$ = getMovieKeyword
        .debounceTime(const Duration(milliseconds: 150))
        .exhaustMap((int id) {
      isLoading.add(true);
      return Stream.fromFuture(getMovieKeywordUseCase.execute(id))
          .flatMap((either) {
            isLoading.add(false);
            return either.fold(
                (error) => Stream.value(MovieKeywordError(error.toString())),
                (data) => Stream.value(MovieKeywordSuccess(data)));
          })
          .debug()
          .onErrorReturnWith((error, _) {
            isLoading.add(false);
            return const MovieKeywordError("Đã có lỗi xảy ra");
          });
    });
    /** endregion Get keyword movie */

    /** region Get similar movie */
    final Stream<MovieStatus> getMovieSimilarMessage$ = getMovieSimilar
        .debounceTime(const Duration(milliseconds: 150))
        .exhaustMap((int id) {
      isLoading.add(true);
      return Stream.fromFuture(getMovieSimilarUseCase.execute(id))
          .flatMap((either) {
            isLoading.add(false);
            return either.fold(
                (error) => Stream.value(MovieSimilarError(error.toString())),
                (data) => Stream.value(MovieSimilarSuccess(data)));
          })
          .debug()
          .onErrorReturnWith((error, _) {
            isLoading.add(false);
            return const MovieSimilarError("Đã có lỗi xảy ra");
          });
    });
    /** endregion Get similar movie */

    /** region Get recommendation movie */
    final Stream<MovieStatus> getMovieRecommendationMessage$ =
        getMovieRecommendation
            .debounceTime(const Duration(milliseconds: 150))
            .exhaustMap((int id) {
      isLoading.add(true);
      return Stream.fromFuture(getMovieRecommendationUseCase.execute(id))
          .flatMap((either) {
            isLoading.add(false);
            return either.fold(
                (error) =>
                    Stream.value(MovieRecommendationError(error.toString())),
                (data) => Stream.value(MovieRecommendationSuccess(data)));
          })
          .debug()
          .onErrorReturnWith((error, _) {
            isLoading.add(false);
            return const MovieRecommendationError("Đã có lỗi xảy ra");
          });
    });
    /** endregion Get recommendation movie */

    /** region Get genre movie */
    final Stream<MovieStatus> getGenreMovieMessage$ = getGenreMovie
        .debounceTime(const Duration(milliseconds: 150))
        .exhaustMap((_) {
      isLoading.add(true);
      return Stream.fromFuture(getGenreMovieListUseCase.execute("movie"))
          .flatMap((either) {
            isLoading.add(false);
            return either.fold(
                (error) => Stream.value(GenreMovieListError(error.toString())),
                (data) => Stream.value(GenreMovieListSuccess(data)));
          })
          .debug()
          .onErrorReturnWith((error, _) {
            isLoading.add(false);
            return const GenreMovieListError("Đã có lỗi xảy ra");
          });
    });
    /** endregion Get genre movie */

    /** region Get popular movie */
    final Stream<MovieStatus> getPopularMessage$ = getPopular
        .debounceTime(const Duration(milliseconds: 150))
        .exhaustMap((_) {
      isLoading.add(true);
      // Check cache first
      if (MovieBloc._cache != null) {
        return Stream.value(MovieBloc._cache!);
      }
      return getMovieListUseCase
          .execute(RequestMovieList("popular", currentPage.value))
          .flatMap((either) {
            isLoading.add(false);
            return either.fold((error) {
              MovieBloc._cache = null; // Clear cache on error
              return Stream.value(MovieListError(error.toString()));
            }, (data) {
              // return Stream.value(MovieListSuccess(data, "popular"));
              final movieListSuccess = MovieListSuccess(data, "popular");
              MovieBloc._cache = movieListSuccess;
              return Stream.value(movieListSuccess);
            });
          })
          .debug()
          .onErrorReturnWith((error, _) {
            isLoading.add(false);
            MovieBloc._cache = null; // Clear cache on error
            return const MovieListError("Đã có lỗi xảy ra");
          });
    });
    /** endregion Get popular movie */

    return MovieBloc._(
      isCollapsed: isCollapsed,
      isCollapsed$: isCollapsed$,
      isLoading$: isLoading.asBroadcastStream(),
      getPopular: getPopular,
      getGenreMovie: getGenreMovie,
      getMovieDetail: getMovieDetail,
      getMovieKeyword: getMovieKeyword,
      getMovieSimilar: getMovieSimilar,
      getMovieRecommendation: getMovieRecommendation,
      getPopularMessage$: getPopularMessage$,
      getGenreMovieMessage$: getGenreMovieMessage$,
      getMovieDetailMessage$: getMovieDetailMessage$,
      getMovieKeywordMessage$: getMovieKeywordMessage$,
      getMovieSimilarMessage$: getMovieSimilarMessage$,
      getMovieRecommendationMessage$: getMovieRecommendationMessage$,
      disposeBag: () {
        print('MovieBloc_dispose');
        isCollapsed.close();
        isLoading.close();
        getPopular.close();
        getGenreMovie.close();
        getMovieDetail.close();
        getMovieKeyword.close();
        getMovieSimilar.close();
        getMovieRecommendation.close();
        // injector.unregister<MovieBloc>();
        // registerMovieBloc(injector);
      },
    );
  }

  MovieBloc._({
    required this.isCollapsed,
    required this.getPopular,
    required this.getGenreMovie,
    required this.getMovieDetail,
    required this.getMovieKeyword,
    required this.getMovieSimilar,
    required this.getMovieRecommendation,
    required this.disposeBag,
    required this.isCollapsed$,
    required this.isLoading$,
    required this.getPopularMessage$,
    required this.getGenreMovieMessage$,
    required this.getMovieDetailMessage$,
    required this.getMovieKeywordMessage$,
    required this.getMovieSimilarMessage$,
    required this.getMovieRecommendationMessage$,
  });

  static MovieListSuccess? _cache;
}

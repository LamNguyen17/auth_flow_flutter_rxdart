import 'package:auth_flow_flutter_rxdart/data/repositories/favourite_repository_impl.dart';
import 'package:auth_flow_flutter_rxdart/data/repositories/movie_repository_impl.dart';
import 'package:auth_flow_flutter_rxdart/di/injection.dart';

import 'package:auth_flow_flutter_rxdart/data/repositories/auth_repository_impl.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/delete_account_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/get_profile_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/logout_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/register_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/sign_in_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/sign_in_with_apple_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/sign_in_with_facebook_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/sign_in_with_google_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/favourite/add_favourite_use_case.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/favourite/get_favourite_list_use_case.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/favourite/remove_favourite_use_case.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/movie/get_genre_movie_list_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/movie/get_movie_detail_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/movie/get_movie_keyword_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/movie/get_movie_list_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/movie/get_movie_recommendation_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/movie/get_movie_similar_usecase.dart';

Future<void> injectionDomain() async {
  /** Authen*/
  injector.registerLazySingleton(
      () => SignInWithGoogleUseCase(injector.get<AuthRepositoryImpl>()));
  injector.registerLazySingleton(
      () => SignInWithAppleUseCase(injector.get<AuthRepositoryImpl>()));
  injector.registerLazySingleton(
      () => SignInUseCase(injector.get<AuthRepositoryImpl>()));
  injector.registerLazySingleton(
      () => LogoutUseCase(injector.get<AuthRepositoryImpl>()));
  injector.registerLazySingleton(
      () => SignInWithFacebookUseCase(injector.get<AuthRepositoryImpl>()));
  injector.registerLazySingleton(
      () => GetProfileUseCase(injector.get<AuthRepositoryImpl>()));
  injector.registerLazySingleton(
      () => RegisterUseCase(injector.get<AuthRepositoryImpl>()));
  injector.registerLazySingleton(
      () => DeleteAccountUseCase(injector.get<AuthRepositoryImpl>()));
  /** Movie*/
  injector.registerLazySingleton(
      () => GetMovieListUseCase(injector.get<MovieRepositoryImpl>()));
  injector.registerLazySingleton(
      () => GetMovieDetailUseCase(injector.get<MovieRepositoryImpl>()));
  injector.registerLazySingleton(
      () => GetGenreMovieListUseCase(injector.get<MovieRepositoryImpl>()));
  injector.registerLazySingleton(
      () => GetMovieKeywordUseCase(injector.get<MovieRepositoryImpl>()));
  injector.registerLazySingleton(
      () => GetMovieSimilarUseCase(injector.get<MovieRepositoryImpl>()));
  injector.registerLazySingleton(
      () => GetMovieRecommendationUseCase(injector.get<MovieRepositoryImpl>()));
  /** Favourite*/
  injector.registerLazySingleton(
      () => GetFavouriteListUseCase(injector.get<FavouriteRepositoryImpl>()));
  injector.registerLazySingleton(
      () => AddFavouriteUseCase(injector.get<FavouriteRepositoryImpl>()));
  injector.registerLazySingleton(
      () => RemoveFavouriteUseCase(injector.get<FavouriteRepositoryImpl>()));
}

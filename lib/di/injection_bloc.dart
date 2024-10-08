import 'package:auth_flow_flutter_rxdart/domain/usecases/favourite/add_favourite_use_case.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/favourite/get_favourite_list_use_case.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/favourite/remove_favourite_use_case.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/favourites/favourite_item_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:auth_flow_flutter_rxdart/di/injection.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/delete_account_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/get_profile_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/logout_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/register_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/sign_in_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/sign_in_with_apple_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/sign_in_with_facebook_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/sign_in_with_google_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/movie/get_genre_movie_list_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/movie/get_movie_detail_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/movie/get_movie_keyword_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/movie/get_movie_list_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/movie/get_movie_recommendation_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/movie/get_movie_similar_usecase.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/favourites/favourite_bloc.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/auth/auth_bloc.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/home/home_bloc.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_bloc.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/profile/profile_bloc.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/splash/splash_bloc.dart';

Future<void> injectionBloc() async {
  injector.registerFactory(() => HomeBloc());
  injector.registerFactory(() => AuthBloc(
        injector.get<SignInWithGoogleUseCase>(),
        injector.get<SignInWithFacebookUseCase>(),
        injector.get<SignInWithAppleUseCase>(),
        injector.get<SignInUseCase>(),
        injector.get<RegisterUseCase>(),
        injector.get<LogoutUseCase>(),
        injector.get<DeleteAccountUseCase>(),
      ));
  injector.registerFactory(() => SplashBloc());
  injector.registerFactory(() => FavouriteItemBloc(
        injector.get<AddFavouriteUseCase>(),
        injector.get<RemoveFavouriteUseCase>(),
      ));
  injector.registerFactory(() => FavouriteBloc(
        injector.get<GetFavouriteListUseCase>(),
        injector.get<AddFavouriteUseCase>(),
        injector.get<RemoveFavouriteUseCase>(),
      ));
  injector.registerLazySingleton(() => ProfileBloc(
        injector.get<GetProfileUseCase>(),
      ));
  registerMovieBloc(injector);
}

Future<void> registerMovieBloc(GetIt injector) async {
  injector.registerFactory(() => MovieBloc(
        injector.get<GetGenreMovieListUseCase>(),
        injector.get<GetMovieListUseCase>(),
        injector.get<GetMovieDetailUseCase>(),
        injector.get<GetMovieKeywordUseCase>(),
        injector.get<GetMovieSimilarUseCase>(),
        injector.get<GetMovieRecommendationUseCase>(),
      ));
}

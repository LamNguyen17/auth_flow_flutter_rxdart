import 'package:auth_flow_flutter_rxdart/di/injection.dart';

import 'package:auth_flow_flutter_rxdart/data/repositories/auth_repository_impl.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/get_profile_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/logout_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/sign_in_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/sign_in_with_facebook_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/sign_in_with_google_usecase.dart';

Future<void> injectionDomain() async {
  /** Authen*/
  injector.registerLazySingleton(
          () => SignInWithGoogleUseCase(injector.get<AuthRepositoryImpl>()));
  injector.registerLazySingleton(
          () => SignInUseCase(injector.get<AuthRepositoryImpl>()));
  injector.registerLazySingleton(
          () => LogoutUseCase(injector.get<AuthRepositoryImpl>()));
  injector.registerLazySingleton(
          () => SignInWithFacebookUseCase(injector.get<AuthRepositoryImpl>()));
  injector.registerLazySingleton(
          () => GetProfileUseCase(injector.get<AuthRepositoryImpl>()));
}
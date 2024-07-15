import 'package:auth_flow_flutter_rxdart/di/injection.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/get_profile_usecase.dart';

import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/logout_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/sign_in_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/sign_in_with_facebook_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/sign_in_with_google_usecase.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/auth/auth_bloc.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/profile/profile_bloc.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/splash/splash_bloc.dart';

Future<void> injectionBloc() async {
  injector.registerFactory(() => AuthBloc(
    injector.get<SignInWithGoogleUseCase>(),
    injector.get<SignInWithFacebookUseCase>(),
    injector.get<SignInUseCase>(),
    injector.get<LogoutUseCase>(),
  ));
  injector.registerFactory(() => SplashBloc());
  injector.registerFactory(() => ProfileBloc(
      injector.get<GetProfileUseCase>(),
  ));
}
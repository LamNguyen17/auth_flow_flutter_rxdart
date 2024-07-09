import 'package:auth_flow_flutter_rxdart/presentation/features/auth/auth_bloc.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/splash/splash_bloc.dart';
import 'package:get_it/get_it.dart';

final injector = GetIt.instance;

Future<void> configureDI() async {
  injectionBloc();
}

Future<void> injectionBloc() async {
  injector.registerFactory(() => AuthBloc());
  injector.registerFactory(() => SplashBloc());
}

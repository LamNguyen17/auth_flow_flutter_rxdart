import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:auth_flow_flutter_rxdart/di/injection.dart';
import 'package:auth_flow_flutter_rxdart/common/services/network_service.dart';
import 'package:auth_flow_flutter_rxdart/data/repositories/auth_repository_impl.dart';
import 'package:auth_flow_flutter_rxdart/data/datasources/auth_remote_data_source.dart';

Future<void> injectionData() async {
  /** Datasource*/
  injector.registerLazySingleton(() => AuthRemoteDataSourceImpl(
    FirebaseAuth.instance,
    GoogleSignIn(),
  ));

  /** Repositories*/
  injector.registerLazySingleton(
          () => NetworkServiceImpl(InternetConnectionChecker()));
  injector.registerLazySingleton(() => AuthRepositoryImpl(
    injector.get<AuthRemoteDataSourceImpl>(),
    injector.get<NetworkServiceImpl>(),
  ));
}
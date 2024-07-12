import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:auth_flow_flutter_rxdart/di/injection_bloc.dart';
import 'package:auth_flow_flutter_rxdart/di/injection_data.dart';
import 'package:auth_flow_flutter_rxdart/di/injection_domain.dart';

final injector = GetIt.instance;

Future<void> configureDI() async {
  injectionBloc();
  injectionData();
  injectionDomain();
}

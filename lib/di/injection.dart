import 'package:auth_flow_flutter_rxdart/data/config/app_config.dart';
import 'package:get_it/get_it.dart';
import 'package:auth_flow_flutter_rxdart/data/gateway/api_gateway.dart';
import 'package:auth_flow_flutter_rxdart/data/gateway/storage_gateway.dart';

import 'package:auth_flow_flutter_rxdart/common/services/notification_service.dart';
import 'package:auth_flow_flutter_rxdart/di/injection_bloc.dart';
import 'package:auth_flow_flutter_rxdart/di/injection_data.dart';
import 'package:auth_flow_flutter_rxdart/di/injection_domain.dart';

final injector = GetIt.instance;

Future<void> configureDI() async {
  injector.registerLazySingleton(() => ApiGateway());
  injector.registerLazySingleton(() => StorageGateway());
  injector.registerLazySingleton(() => NotificationService());
  injectionBloc();
  injectionData();
  injectionDomain();
}

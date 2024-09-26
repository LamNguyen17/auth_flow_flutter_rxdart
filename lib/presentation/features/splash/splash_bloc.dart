import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:rxdart/rxdart.dart';

import 'package:auth_flow_flutter_rxdart/common/channel/encryption_channel.dart';
import 'package:auth_flow_flutter_rxdart/common/services/firebase_remote_config_service.dart';
import 'package:auth_flow_flutter_rxdart/presentation/navigations/app_nav_manager.dart';
import 'package:auth_flow_flutter_rxdart/presentation/navigations/navigator/auth_navigator.dart';

class SplashBloc {
  final EncryptionChannel _encryptionChannel = EncryptionChannel();
  final FirebaseRemoteConfigService _remoteConfigService =
      FirebaseRemoteConfigService();

  /// Input
  final Sink<void> onSignIn;
  final Sink<void> onRegister;
  final Function0<void> dispose;

  /// Output
  final StreamSubscription<void> login$;
  final StreamSubscription<void> register$;

  factory SplashBloc() {
    final login = BehaviorSubject<void>();
    final register = BehaviorSubject<void>();

    /** region login */
    final StreamSubscription<void> login$ = login.flatMap((_) {
      AuthNavigator.openSignIn(AppNavManager.currentContext.currentContext!);
      return const Stream.empty();
    }).listen((event) {});
    /** region login */

    /** region register */
    final StreamSubscription<void> register$ = register.flatMap((_) {
      AuthNavigator.openRegister(AppNavManager.currentContext.currentContext!);
      return const Stream.empty();
    }).listen((event) {});
    /** region register */

    return SplashBloc._(
      onSignIn: login,
      onRegister: register,
      login$: login$,
      register$: register$,
      dispose: () {
        login.close();
        register.close();
        login$.cancel();
        register$.cancel();
      },
    );
  }

  SplashBloc._({
    required this.onSignIn,
    required this.onRegister,
    required this.login$,
    required this.register$,
    required this.dispose,
  }) {
    _remoteConfigService.setupRemoteConfig();
    _encryptionChannel
        .encrypt(FirebaseRemoteConfigService.getRemoteValue('api_key'));
  }
}

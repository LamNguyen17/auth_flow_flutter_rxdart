import 'dart:async';

import 'package:auth_flow_flutter_rxdart/main.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/auth/register/register_screen.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/auth/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SplashBloc {
  /// Input
  final Sink<void> onSignIn;
  final Sink<void> onRegister;

  factory SplashBloc() {
    final login = BehaviorSubject<void>();
    final register = BehaviorSubject<void>();

    /** region login */
    final StreamSubscription<void> login$ = login.flatMap((_) {
      Navigator.of(NavigationService.navigatorKey.currentContext!)
          .push(
        MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        ),
      );
      return const Stream.empty();
    }).listen((event) {});
    /** region login */

    /** region register */
    final StreamSubscription<void> register$ = register.flatMap((_) {
      Navigator.of(NavigationService.navigatorKey.currentContext!)
          .push(
        MaterialPageRoute(
          builder: (context) => const RegisterScreen(),
        ),
      );
      return const Stream.empty();
    }).listen((event) {});
    /** region register */

    return SplashBloc._(
      onSignIn: login,
      onRegister: register,
    );
  }

  SplashBloc._({
    required this.onSignIn,
    required this.onRegister,
  });
}

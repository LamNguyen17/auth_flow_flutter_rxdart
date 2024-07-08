import 'package:auth_flow_flutter_rxdart/main.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/auth/user_info/user_info_screen.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'package:auth_flow_flutter_rxdart/common/extensions/loading.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/auth/auth_state.dart';

class AuthBloc {
  /// Input
  final Function0<void> dispose;
  final Sink<dynamic> login;
  // final Sink<dynamic> register;
  // final Sink<void> logout;
  // final Sink<void> deleteAccount;

  /// Output
  final Stream<AuthStatus> authStatus$;
  final Stream<dynamic> authError$;

  factory AuthBloc() {
    final isLoading = BehaviorSubject<bool>();
    final login = BehaviorSubject<LoginCommand>();

    final Stream<AuthStatus> authStatus$ =
        FirebaseAuth.instance.authStateChanges().map((user) {
      if (user != null) {
        return const AuthStatusLoggedIn();
      } else {
        return const AuthStatusLoggedOut();
      }
    });

    final Stream<dynamic> loginError$ = login
        .setLoadingTo(true, onSink: isLoading)
        .asyncMap<dynamic>((loginCommand) async {
      print('loginCommand: ${loginCommand.email} -  ${loginCommand.password}');
      try {
        final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: loginCommand.email,
          password: loginCommand.password,
        );
        if (userCredential.user != null) {
          Navigator.of(NavigationService.navigatorKey.currentContext!).pushReplacement(
            MaterialPageRoute(
              builder: (context) => UserInfoScreen(
                user: userCredential.user!,
              ),
            ),
          );
        }
        print('loginCommand_1: $userCredential');
        return null;
      } catch (e) {
        return e;
      }
    }).setLoadingTo(false, onSink: isLoading);
    login.listen((value) { print('login: ${value.email} -  ${value.password}'); });

    final Stream<dynamic> authError$ = Rx.merge([
      loginError$,
      // registerError$,
      // logoutError$,
      // deleteAccountError$,
    ]);

    return AuthBloc._(
      authStatus$: authStatus$,
      authError$: authError$,
      login: login,
      dispose: () {
        login.close();
        // register.close();
        // logout.close();
        // deleteAccount.close();
      },
    );
  }

  AuthBloc._({
    required this.dispose,
    required this.login,
    // required this.register,
    // required this.logout,
    // required this.deleteAccount,
    required this.authStatus$,
    required this.authError$,
  });
}

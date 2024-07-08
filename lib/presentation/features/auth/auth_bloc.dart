import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:rxdart/rxdart.dart';

import 'package:auth_flow_flutter_rxdart/main.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/auth/user_info/user_info_screen.dart';
import 'package:auth_flow_flutter_rxdart/common/extensions/loading.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/auth/auth_state.dart';

class AuthBloc {
  /// Input
  final Function0<void> dispose;
  final Sink<dynamic> login;
  final Sink<dynamic> register;
  final Sink<void> logout;
  final Sink<void> deleteAccount;

  /// Output
  final Stream<AuthStatus> authStatus$;
  final StreamSubscription<dynamic> authError$;
  final Stream<bool> isLoading;

  factory AuthBloc() {
    final isLoading = BehaviorSubject<bool>();
    final login = BehaviorSubject<LoginCommand>();
    final logout = BehaviorSubject<void>();
    final register = BehaviorSubject<RegisterCommand>();
    final deleteAccount = BehaviorSubject<void>();

    final Stream<AuthStatus> authStatus$ =
        FirebaseAuth.instance.authStateChanges().map((user) {
      if (user != null) {
        return const AuthStatusLoggedIn();
      } else {
        return const AuthStatusLoggedOut();
      }
    });

    /** region Login + err message */
    final Stream<dynamic> loginError$ = login
        .setLoadingTo(true, onSink: isLoading)
        .asyncMap<dynamic>((LoginCommand loginCommand) async {
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
        return null;
      } catch (e) {
        AlertController.show(
            "Thông báo", e.toString(), TypeAlert.error);
        return e;
      }
    }).setLoadingTo(false, onSink: isLoading);
    /** endregion Login */

    /** region Logout + err message */
    final Stream<dynamic> logoutError$ = logout
        .setLoadingTo(true, onSink: isLoading)
        .asyncMap<dynamic>((_) async {
      try {
        await FirebaseAuth.instance.signOut();
        return null;
      } catch (e) {
        AlertController.show(
            "Thông báo", e.toString(), TypeAlert.error);
        return e;
      }
    }).setLoadingTo(false, onSink: isLoading);
    /** endregion Logout */

    /** region Register + err message */
    final Stream<dynamic> registerError$ = register
        .setLoadingTo(true, onSink: isLoading)
        .asyncMap<dynamic>((RegisterCommand registerCommand) async {
      try {
        final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: registerCommand.email,
          password: registerCommand.password,
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
        return null;
      } catch (e) {
        AlertController.show(
            "Thông báo", e.toString(), TypeAlert.error);
        return e;
      }
    }).setLoadingTo(false, onSink: isLoading);
    /** endregion Register */

    /** region Delete Account + err message */
    final Stream<dynamic> deleteAccountError$ = deleteAccount
        .setLoadingTo(true, onSink: isLoading)
        .asyncMap<dynamic>((_) async {
      try {
        await FirebaseAuth.instance.currentUser?.delete();
        return null;
      } catch (e) {
        AlertController.show(
            "Thông báo", e.toString(), TypeAlert.error);
        return e;
      }
    }).setLoadingTo(false, onSink: isLoading);
    /** endregion Delete Account */

    final StreamSubscription<dynamic> authError$ = Rx.merge([
      loginError$,
      registerError$,
      logoutError$,
      deleteAccountError$,
    ]).listen((event) { });

    return AuthBloc._(
      authStatus$: authStatus$,
      authError$: authError$,
      login: login,
      register: register,
      logout: logout,
      deleteAccount: deleteAccount,
      isLoading: isLoading.stream,
      dispose: () {
        login.close();
        register.close();
        logout.close();
        deleteAccount.close();
        isLoading.close();
      },
    );
  }

  AuthBloc._({
    required this.dispose,
    required this.login,
    required this.register,
    required this.logout,
    required this.deleteAccount,
    required this.isLoading,
    required this.authStatus$,
    required this.authError$,
  });
}

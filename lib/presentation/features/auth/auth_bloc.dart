import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:auth_flow_flutter_rxdart/main.dart';
import 'package:auth_flow_flutter_rxdart/presentation/utils/validations.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/auth/user_info/user_info_screen.dart';
import 'package:auth_flow_flutter_rxdart/common/extensions/loading.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/auth/auth_state.dart';

class AuthBloc {
  /// Input
  final Function1<String, void> email;
  final Function1<String, void> password;
  final Function0<void> dispose;
  final Sink<dynamic> signInWithGoogle;
  final Sink<dynamic> signInWithFacebook;
  final Sink<dynamic> login;
  final Sink<dynamic> register;
  final Sink<void> logout;
  final Sink<void> deleteAccount;
  final Sink<void> initState;
  final TextEditingController emailTextEditing;
  final TextEditingController passwordTextEditing;

  /// Output
  final Stream<AuthStatus> authStatus$;
  final StreamSubscription<dynamic> authError$;
  final Stream<bool> isLoading$;
  final Stream<bool> isSubmit$;
  final Stream<String?> email$;
  final Stream<String?> password$;

  factory AuthBloc() {
    final isLoading = BehaviorSubject<bool>();
    final login = BehaviorSubject<LoginCommand>();
    final signInWithGoogle = BehaviorSubject<void>();
    final signInWithFacebook = BehaviorSubject<void>();
    final signInWithApple = BehaviorSubject<void>();
    final initState = BehaviorSubject<void>();
    final logout = BehaviorSubject<void>();
    final register = BehaviorSubject<RegisterCommand>();
    final deleteAccount = BehaviorSubject<void>();
    final loginBtn = BehaviorSubject<bool>.seeded(false);
    final email = BehaviorSubject<String>();
    final password = BehaviorSubject<String>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    final emailValid$ = StreamTransformer<String, String?>.fromHandlers(
        handleData: (email, sink) => sink.add(Validation.validateEmail(email)));
    final passwordValid$ = StreamTransformer<String, String?>.fromHandlers(
        handleData: (pass, sink) => sink.add(Validation.validatePass(pass)));

    final isValidSubmit$ = Rx.combineLatest2<String, String, bool>(
      email,
      password,
      (e, p) =>
          Validation.validateEmail(e) == null &&
          Validation.validatePass(p) == null,
    ).shareValueSeeded(false);
    isValidSubmit$.listen((enable) {
      loginBtn.add(enable);
    });

    final submit$ = loginBtn
        .withLatestFrom(isValidSubmit$, (_, bool isValid) => isValid)
        .share();

    final Stream<AuthStatus> authStatus$ =
        FirebaseAuth.instance.authStateChanges().map((user) {
      if (user != null) {
        return const AuthStatusLoggedIn();
      } else {
        return const AuthStatusLoggedOut();
      }
    });

    /** region initState */
    final StreamSubscription<void> initState$ = initState
        .flatMap((_) {
        User? user = FirebaseAuth.instance.currentUser;
        print('initState: $user');
        if (user != null) {
          Navigator.of(NavigationService.navigatorKey.currentContext!).pushReplacement(
            MaterialPageRoute(
              builder: (context) => UserInfoScreen(
                user: user,
              ),
            ),
          );
        }
        return user != null ? Stream.value(user) : const Stream.empty();
      }).listen((event) {});
    /** region initState */

    /** region signInWithFacebook + err message*/
    final Stream<dynamic> signInWithFacebookError$ = signInWithFacebook
        .setLoadingTo(true, onSink: isLoading)
        .asyncMap<dynamic>((_) async {
      try {
        final LoginResult loginResult = await FacebookAuth.instance.login();
        final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);
        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
        if (userCredential.user != null) {
          Navigator.of(NavigationService.navigatorKey.currentContext!)
              .pushReplacement(
            MaterialPageRoute(
              builder: (context) => UserInfoScreen(
                user: userCredential.user!,
              ),
            ),
          );
        }
        return userCredential.user;
      } on Exception catch (e) {
        return e;
      }
    });
    /** region signInWithFacebook + err message*/

    /** region signInWithGoogle + err message */
    final Stream<dynamic> signInWithGoogleError$ = signInWithGoogle
        .setLoadingTo(true, onSink: isLoading)
        .asyncMap<dynamic>((_) async {
        try {
          final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
          final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth?.accessToken,
            idToken: googleAuth?.idToken,
          );
          final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
          if (userCredential.user != null) {
            Navigator.of(NavigationService.navigatorKey.currentContext!)
                .pushReplacement(
              MaterialPageRoute(
                builder: (context) => UserInfoScreen(
                  user: userCredential.user!,
                ),
              ),
            );
          }
          return userCredential.user;
        } on Exception catch (e) {
          return e;
        }
    });
    /** endregion signInWithGoogle + err message */

    /** region Login + err message */
    final Stream<dynamic> loginError$ = login
        .setLoadingTo(true, onSink: isLoading)
        .asyncMap<dynamic>((LoginCommand loginCommand) async {
      try {
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: loginCommand.email,
          password: loginCommand.password,
        );
        if (userCredential.user != null) {
          Navigator.of(NavigationService.navigatorKey.currentContext!)
              .pushReplacement(
            MaterialPageRoute(
              builder: (context) => UserInfoScreen(
                user: userCredential.user!,
              ),
            ),
          );
        }
        return null;
      } catch (e) {
        AlertController.show("Thông báo", e.toString(), TypeAlert.error);
        return e;
      }
    }).setLoadingTo(false, onSink: isLoading);
    /** endregion Login */

    /** region Logout + err message */
    final Stream<dynamic> logoutError$ = logout
        .setLoadingTo(true, onSink: isLoading)
        .asyncMap<dynamic>((_) async {
      try {
        final GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        await FirebaseAuth.instance.signOut();
        return null;
      } catch (e) {
        AlertController.show("Thông báo", e.toString(), TypeAlert.error);
        return e;
      }
    }).setLoadingTo(false, onSink: isLoading);
    /** endregion Logout */

    /** region Register + err message */
    final Stream<dynamic> registerError$ = register
        .setLoadingTo(true, onSink: isLoading)
        .asyncMap<dynamic>((RegisterCommand registerCommand) async {
      try {
        final UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: registerCommand.email,
          password: registerCommand.password,
        );
        if (userCredential.user != null) {
          Navigator.of(NavigationService.navigatorKey.currentContext!)
              .pushReplacement(
            MaterialPageRoute(
              builder: (context) => UserInfoScreen(
                user: userCredential.user!,
              ),
            ),
          );
        }
        return null;
      } catch (e) {
        AlertController.show("Thông báo", e.toString(), TypeAlert.error);
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
        AlertController.show("Thông báo", e.toString(), TypeAlert.error);
        return e;
      }
    }).setLoadingTo(false, onSink: isLoading);
    /** endregion Delete Account */

    final StreamSubscription<dynamic> authError$ = Rx.merge([
      loginError$,
      registerError$,
      logoutError$,
      deleteAccountError$,
      signInWithGoogleError$,
      signInWithFacebookError$,
    ]).listen((event) {});

    return AuthBloc._(
      email: email.add,
      password: password.add,
      signInWithGoogle: signInWithGoogle,
      signInWithFacebook: signInWithFacebook,
      login: login,
      register: register,
      logout: logout,
      initState: initState,
      emailTextEditing: emailController,
      passwordTextEditing: passwordController,
      authStatus$: authStatus$,
      authError$: authError$,
      deleteAccount: deleteAccount,
      isLoading$: isLoading.asBroadcastStream(),
      isSubmit$: submit$,
      email$: email.stream.transform(emailValid$).skip(1),
      password$: password.stream.transform(passwordValid$).skip(1),
      dispose: () {
        email.close();
        password.close();
        login.close();
        register.close();
        logout.close();
        deleteAccount.close();
        emailController.dispose();
        passwordController.dispose();
        signInWithGoogle.close();
        signInWithFacebook.close();
        initState.close();
      },
    );
  }

  AuthBloc._({
    required this.initState,
    required this.email,
    required this.password,
    required this.emailTextEditing,
    required this.passwordTextEditing,
    required this.dispose,
    required this.signInWithGoogle,
    required this.signInWithFacebook,
    required this.login,
    required this.register,
    required this.logout,
    required this.deleteAccount,
    required this.isLoading$,
    required this.authStatus$,
    required this.authError$,
    required this.isSubmit$,
    required this.email$,
    required this.password$,
  });
}

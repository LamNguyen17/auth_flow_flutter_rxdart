import 'dart:async';
import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/sign_in_with_apple_usecase.dart';
import 'package:flutter/material.dart';

import 'package:dartz/dartz.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';

import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/delete_account_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/register_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/sign_in_with_facebook_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/logout_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/sign_in_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/auth/sign_in_with_google_usecase.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/base_usecase.dart';
import 'package:auth_flow_flutter_rxdart/presentation/navigations/app_nav_manager.dart';
import 'package:auth_flow_flutter_rxdart/presentation/navigations/navigator/auth_navigator.dart';
import 'package:auth_flow_flutter_rxdart/presentation/navigations/navigator/main_navigator.dart';
import 'package:auth_flow_flutter_rxdart/presentation/utils/validations.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/auth/auth_state.dart';

class AuthBloc extends Cubit<AuthStatus> {
  /// Input
  final Function1<String, void> email;
  final Function1<String, void> password;
  final Function1<String, void> confirmPassword;
  final Function0<void> dispose;
  final Sink<void> signInWithGoogle;
  final Sink<void> signInWithFacebook;
  final Sink<void> signInWithApple;
  final Sink<dynamic> login;
  final Sink<dynamic> register;
  final Sink<void> logout;
  final Sink<void> deleteAccount;
  final Sink<void> initState;
  final TextEditingController emailTextEditing;
  final TextEditingController passwordTextEditing;
  final TextEditingController confirmPasswordTextEditing;

  /// Output
  final StreamSubscription<dynamic> authError$;
  final Stream<bool> isLoading$;
  final Stream<bool> isSubmitLogin$;
  final Stream<bool> isSubmitRegister$;
  final Stream<String?> email$;
  final Stream<String?> password$;
  final Stream<String?> confirmPassword$;

  factory AuthBloc(
    SignInWithGoogleUseCase signInWithGoogleUseCase,
    SignInWithFacebookUseCase signInWithFacebookUseCase,
    SignInWithAppleUseCase signInWithAppleUseCase,
    SignInUseCase signInUseCase,
    RegisterUseCase registerUseCase,
    LogoutUseCase logoutUseCase,
    DeleteAccountUseCase deleteAccountUseCase,
  ) {
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
    final registerBtn = BehaviorSubject<bool>.seeded(false);
    final email = BehaviorSubject<String>();
    final password = BehaviorSubject<String>();
    final confirmPassword = BehaviorSubject<String>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    final emailValid$ = StreamTransformer<String, String?>.fromHandlers(
        handleData: (email, sink) => sink.add(Validation.validateEmail(email)));
    final passwordValid$ = StreamTransformer<String, String?>.fromHandlers(
        handleData: (pass, sink) => sink.add(Validation.validatePass(pass)));
    final confirmPasswordValid$ =
        StreamTransformer<String, String?>.fromHandlers(
            handleData: (confirmPassword, sink) => sink.add(
                Validation.validateConfirmPass(
                    passwordController.text, confirmPassword)));

    /** region initState */
    final StreamSubscription<void> initState$ = initState.flatMap((_) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        MainNavigator.openHome(AppNavManager.currentContext.currentContext!);
      }
      return user != null ? Stream.value(user) : const Stream.empty();
    }).listen((event) {});
    /** region initState */

    /** region SignInWithApple + err message*/
    final Stream<AuthStatus> signInWithAppleError$ = signInWithApple
        .debounceTime(const Duration(milliseconds: 350))
        .exhaustMap((_) {
      isLoading.add(true);
      return Stream.fromFuture(signInWithAppleUseCase.execute(NoParams()))
          .flatMap((either) => _responseSignIn(either))
          .doOnDone(() => isLoading.add(false))
          .doOnError((error, _) => isLoading.add(false))
          .onErrorReturnWith(
              (error, _) => const SignInError("Đã có lỗi xảy ra"));
    });
    /** endregion SignInWithApple + err message*/

    /** region SignInWithFacebook + err message*/
    final Stream<AuthStatus> signInWithFacebookError$ = signInWithFacebook
        .debounceTime(const Duration(milliseconds: 350))
        .exhaustMap((_) {
      isLoading.add(true);
      return Stream.fromFuture(signInWithFacebookUseCase.execute(NoParams()))
          .flatMap((either) => _responseSignIn(either))
          .doOnDone(() => isLoading.add(false))
          .doOnError((error, _) => isLoading.add(false))
          .onErrorReturnWith(
              (error, _) => const SignInError("Đã có lỗi xảy ra"));
    });
    /** endregion SignInWithFacebook + err message*/

    /** region SignInWithGoogle + err message */
    final Stream<AuthStatus> signInWithGoogleError$ = signInWithGoogle
        .debounceTime(const Duration(milliseconds: 350))
        .exhaustMap((_) {
      return Stream.fromFuture(signInWithGoogleUseCase.execute(NoParams()))
          .flatMap((either) => _responseSignIn(either))
          .doOnDone(() => isLoading.add(false))
          .doOnError((error, _) => isLoading.add(false))
          .onErrorReturnWith(
              (error, _) => const SignInError("Đã có lỗi xảy ra"));
    });
    /** endregion SignInWithGoogle + err message */

    /** region SignIn + err message */
    final isValidSubmitLogin$ = Rx.combineLatest2<String, String, bool>(
      email,
      password,
      (e, p) =>
          Validation.validateEmail(e) == null &&
          Validation.validatePass(p) == null,
    ).shareValueSeeded(false);
    isValidSubmitLogin$.listen((enable) {
      loginBtn.add(enable);
    });

    final submitLogin$ = loginBtn
        .withLatestFrom(isValidSubmitLogin$, (_, bool isValid) => isValid)
        .share();

    final Stream<AuthStatus> loginError$ = login
        .debounceTime(const Duration(milliseconds: 300))
        .exhaustMap<AuthStatus>((LoginCommand loginCommand) {
      return Stream.fromFuture(signInUseCase.execute(
              ReqLoginCommand(loginCommand.email, loginCommand.password)))
          .flatMap((either) => _responseSignIn(either))
          .doOnDone(() => isLoading.add(false))
          .doOnError((error, _) => isLoading.add(false))
          .onErrorReturnWith(
              (error, _) => const SignInError("Đã có lỗi xảy ra"));
    });
    /** endregion SignIn */

    /** region Logout + err message */
    final Stream<dynamic> logoutError$ =
        logout.debounceTime(const Duration(milliseconds: 300)).exhaustMap((_) {
      return Stream.fromFuture(logoutUseCase.execute(NoParams()))
          .flatMap((either) => either.fold((error) {
                AlertController.show(
                    "Thông báo", error.toString(), TypeAlert.error);
                return Stream.value(LogoutError(error.toString()));
              }, (data) {
                AuthNavigator.openReplaceSignIn(
                    AppNavManager.currentContext.currentContext!);
                return Stream.value(const LogoutSuccess(null));
              }))
          .doOnDone(() => isLoading.add(false))
          .doOnError((error, _) => isLoading.add(false));
    });
    /** endregion Logout */

    /** region Register + err message */
    final isValidSubmitRegister$ =
        Rx.combineLatest3<String, String, String, bool>(
      email,
      password,
      confirmPassword,
      (e, p, cp) =>
          Validation.validateEmail(e) == null &&
          Validation.validatePass(p) == null &&
          Validation.validateConfirmPass(p, cp) == null,
    ).shareValueSeeded(false);
    isValidSubmitRegister$.listen((enable) {
      registerBtn.add(enable);
    });

    final submitRegister$ = registerBtn
        .withLatestFrom(isValidSubmitRegister$, (_, bool isValid) => isValid)
        .share();

    final Stream<AuthStatus> registerError$ = register
        .debounceTime(const Duration(milliseconds: 300))
        .exhaustMap<AuthStatus>((RegisterCommand registerCommand) {
      return Stream.fromFuture(registerUseCase.execute(ReqRegisterCommand(
              registerCommand.email, registerCommand.password)))
          .flatMap((either) => _responseRegister(either))
          .doOnDone(() => isLoading.add(false))
          .doOnError((error, _) => isLoading.add(false))
          .onErrorReturnWith(
              (error, _) => const SignInError("Đã có lỗi xảy ra"));
    });
    /** endregion Register */

    /** region Delete Account + err message */
    final Stream<dynamic> deleteAccountError$ = deleteAccount
        .debounceTime(const Duration(milliseconds: 300))
        .exhaustMap((_) {
      return Stream.fromFuture(deleteAccountUseCase.execute(NoParams()))
          .flatMap((either) => either.fold((error) {
                AlertController.show(
                    "Thông báo", error.toString(), TypeAlert.error);
                return Stream.value(LogoutError(error.toString()));
              }, (data) {
                AuthNavigator.openReplaceSignIn(
                    AppNavManager.currentContext.currentContext!);
                return Stream.value(const LogoutSuccess(null));
              }))
          .doOnDone(() => isLoading.add(false))
          .doOnError((error, _) => isLoading.add(false))
          .onErrorReturnWith(
              (error, _) => const LogoutError("Đã có lỗi xảy ra"));
    });
    /** endregion Delete Account */

    final StreamSubscription<dynamic> authError$ = Rx.merge([
      loginError$,
      registerError$,
      logoutError$,
      deleteAccountError$,
      signInWithGoogleError$,
      signInWithFacebookError$,
      signInWithAppleError$,
    ]).listen((event) {});

    return AuthBloc._(
      email: email.add,
      password: password.add,
      confirmPassword: confirmPassword.add,
      signInWithGoogle: signInWithGoogle,
      signInWithFacebook: signInWithFacebook,
      signInWithApple: signInWithApple,
      login: login,
      register: register,
      logout: logout,
      initState: initState,
      emailTextEditing: emailController,
      passwordTextEditing: passwordController,
      confirmPasswordTextEditing: confirmPasswordController,
      authError$: authError$,
      deleteAccount: deleteAccount,
      isLoading$: isLoading.asBroadcastStream(),
      isSubmitRegister$: submitRegister$,
      isSubmitLogin$: submitLogin$,
      email$: email.stream.transform(emailValid$).skip(1),
      password$: password.stream.transform(passwordValid$).skip(1),
      confirmPassword$:
          confirmPassword.stream.transform(confirmPasswordValid$).skip(1),
      dispose: () {
        initState$.cancel();
        authError$.cancel();
        email.close();
        password.close();
        confirmPassword.close();
        login.close();
        register.close();
        logout.close();
        deleteAccount.close();
        emailController.dispose();
        passwordController.dispose();
        confirmPasswordController.dispose();
        signInWithGoogle.close();
        signInWithFacebook.close();
        signInWithApple.close();
        initState.close();
        isLoading.close();
      },
    );
  }

  AuthBloc._({
    required this.initState,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.emailTextEditing,
    required this.passwordTextEditing,
    required this.confirmPasswordTextEditing,
    required this.dispose,
    required this.signInWithGoogle,
    required this.signInWithFacebook,
    required this.signInWithApple,
    required this.login,
    required this.register,
    required this.logout,
    required this.deleteAccount,
    required this.isLoading$,
    required this.authError$,
    required this.isSubmitLogin$,
    required this.isSubmitRegister$,
    required this.email$,
    required this.password$,
    required this.confirmPassword$,
  }) : super(const AuthStatusInitial());

  static Stream<AuthStatus> _responseSignIn(dynamic result) {
    return result.fold((error) {
      AlertController.show("Thông báo", error.toString(), TypeAlert.error);
      return Stream.value(SignInError(error.toString()));
    }, (data) {
      MainNavigator.openHome(AppNavManager.currentContext.currentContext!);
      return Stream.value(SignInSuccess(data));
    });
  }

  static Stream<AuthStatus> _responseRegister(dynamic result) {
    return result.fold((error) {
      AlertController.show("Thông báo", error.toString(), TypeAlert.error);
      return Stream.value(RegisterError(error.toString()));
    }, (data) {
      MainNavigator.openHome(AppNavManager.currentContext.currentContext!);
      return Stream.value(RegisterSuccess(data));
    });
  }
}

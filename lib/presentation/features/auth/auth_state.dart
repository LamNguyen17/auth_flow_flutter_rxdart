import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthStatus extends Equatable {
  const AuthStatus();

  @override
  List<Object> get props => [];
}

class AuthStatusInitial extends AuthStatus {
  const AuthStatusInitial();
}

class AuthStatusLoggedIn extends AuthStatus {
  const AuthStatusLoggedIn();
}

class AuthStatusLoggedOut extends AuthStatus {
  const AuthStatusLoggedOut();
}

class LogoutSuccess extends AuthStatus {
  final dynamic data;
  const LogoutSuccess(this.data);

  @override
  List<Object> get props => [data];
}

class LogoutError extends AuthStatus {
  final String message;

  const LogoutError(this.message);

  @override
  List<Object> get props => [message];
}

class DeleteAccountSuccess extends AuthStatus {
  final dynamic data;
  const DeleteAccountSuccess(this.data);

  @override
  List<Object> get props => [data];
}

class DeleteAccountError extends AuthStatus {
  final String message;

  const DeleteAccountError(this.message);

  @override
  List<Object> get props => [message];
}

class SignInSuccess extends AuthStatus {
  // final Customer data;
  final dynamic data;

  const SignInSuccess(this.data);

  @override
  List<Object> get props => [data];
}

class SignInError extends AuthStatus {
  final String message;

  const SignInError(this.message);

  @override
  List<Object> get props => [message];
}

class RegisterSuccess extends AuthStatus {
  final User data;

  const RegisterSuccess(this.data);

  @override
  List<Object> get props => [data];
}

class RegisterError extends AuthStatus {
  final String message;

  const RegisterError(this.message);

  @override
  List<Object> get props => [message];
}

abstract class AuthCommand {
  final String email;
  final String password;

  const AuthCommand({
    required this.email,
    required this.password,
  });
}

class LoginCommand extends AuthCommand {
  const LoginCommand({
    required super.email,
    required super.password,
  });
}

class RegisterCommand extends AuthCommand {
  const RegisterCommand({
    required super.email,
    required super.password,
  });
}

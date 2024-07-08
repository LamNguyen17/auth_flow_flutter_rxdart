import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthStatus extends Equatable {
  const AuthStatus();

  @override
  List<Object> get props => [];
}

class AuthStatusLoggedIn extends AuthStatus {
  const AuthStatusLoggedIn();
}

class AuthStatusLoggedOut extends AuthStatus {
  const AuthStatusLoggedOut();
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

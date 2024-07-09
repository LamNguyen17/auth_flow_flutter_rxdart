import 'package:flutter/material.dart';

import 'package:auth_flow_flutter_rxdart/di/injection.dart';
import 'package:auth_flow_flutter_rxdart/presentation/components/clear_focus.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/auth/auth_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _authBloc = injector.get<AuthBloc>();

  @override
  void dispose() {
    super.dispose();
    _authBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: ClearFocus(
        child: SafeArea(
          child: Center(
            child: Text('Register Screen'),
          ),
        ),
      ),
    );
  }
}

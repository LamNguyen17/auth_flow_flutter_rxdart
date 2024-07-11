import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:auth_flow_flutter_rxdart/presentation/navigations/constants.dart';

class AuthNavigator {
  static openSignIn(BuildContext context) =>
      context.pushNamed(Routes.auth[Auth.signIn]!);

  static openRegister(BuildContext context) =>
      context.pushNamed(Routes.auth[Auth.register]!);
}
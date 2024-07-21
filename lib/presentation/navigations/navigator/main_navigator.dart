import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:auth_flow_flutter_rxdart/presentation/navigations/constants.dart';

class MainNavigator {
  static openHome(BuildContext context) => context.goNamed(Routes.main[Main.home]!);
  static openNews(BuildContext context) => context.goNamed(Routes.main[Main.news]!);
  static openProfile(BuildContext context) => context.goNamed(Routes.main[Main.profile]!);
}
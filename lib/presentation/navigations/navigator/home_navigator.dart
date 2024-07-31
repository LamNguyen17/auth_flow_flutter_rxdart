import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:auth_flow_flutter_rxdart/presentation/navigations/constants.dart';

class HomeNavigator {
  static openMovieList(BuildContext context) =>
      context.pushNamed(Routes.home[Home.movieList]!);

  static openMovieDetail(BuildContext context, int id) =>
      context.pushNamed(Routes.home[Home.movieDetail]!, extra: id);
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:auth_flow_flutter_rxdart/presentation/navigations/constants.dart';

class MovieNavigator {
  static openMovieDetail(BuildContext context, int id) =>
      context.pushNamed(Routes.home[Home.movieDetail]!, extra: id);

  static openMovieReservation(BuildContext context) =>
      context.pushNamed(Routes.home[Home.movieReservation]!);
}

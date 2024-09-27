import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MovieNavigator {
  static openMovieDetail(BuildContext context, int id) =>
      context.push('/home/movies/$id');

  static openMovieReservation(BuildContext context) =>
      context.push('/home/movies/booking');
}

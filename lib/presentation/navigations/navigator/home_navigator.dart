import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeNavigator {
  static openMovieList(BuildContext context) =>
      context.push('/home/movies');

  static openMovieDetail(BuildContext context, int id) =>
      context.push('/home/movies/$id');

  static openFavouriteList(BuildContext context) =>
      context.push('/home/favourite_list');

  static openNotificationList(BuildContext context) =>
      context.push('/home/notifications');
}

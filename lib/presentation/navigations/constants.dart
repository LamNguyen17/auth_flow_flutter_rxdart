import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:auth_flow_flutter_rxdart/presentation/navigations/not_found_page.dart';

enum Auth { signIn, socialSignIn, register }

enum Main { home, profile, news }

enum Home { movieList, movieDetail }

class Routes {
  static const splash = '/splash';

  static final Map<dynamic, String> auth = {
    Auth.signIn: 'sign_in',
    Auth.socialSignIn: 'social_sign_in',
    Auth.register: 'register',
  };

  static final Map<dynamic, String> main = {
    Main.home: 'home',
    Main.profile: 'profile',
    Main.news: 'news',
  };

  static final Map<dynamic, String> home = {
    Home.movieList: 'movie_list',
    Home.movieDetail: 'movie_detail',
  };

  static Widget errorWidget(BuildContext context, GoRouterState state) =>
      const NotFoundScreen();
}

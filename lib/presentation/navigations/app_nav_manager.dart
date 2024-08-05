import 'package:auth_flow_flutter_rxdart/domain/entities/movie/movie_list.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_detail/movie_detail_screen.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_list/movie_list_screen.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_reservation/movie_reservation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:auth_flow_flutter_rxdart/common/extensions/color_extensions.dart';
import 'package:auth_flow_flutter_rxdart/presentation/assets/images/app_images.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/home/home_screen.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/new/new_screen.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/profile/profile_screen.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/auth/register/register_screen.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/auth/sign_in/sign_in_screen.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/splash/splash_screen.dart';
import 'package:auth_flow_flutter_rxdart/presentation/navigations/constants.dart';
import 'package:auth_flow_flutter_rxdart/presentation/navigations/not_found_page.dart';

const String tabProfile = AppImages.icBottomTabProfile;
const String tabHome = AppImages.icBottomTabHome;
const String tabList = AppImages.icBottomTabList;

class AppNavManager {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter _router = GoRouter(
    initialLocation: Routes.splash,
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: Routes.splash,
          builder: (BuildContext context, GoRouterState state) =>
              const SplashScreen(),
          routes: [
            GoRoute(
              path: Routes.auth[Auth.signIn]!,
              name: Routes.auth[Auth.signIn]!,
              builder: (BuildContext context, GoRouterState state) =>
                  const SignInScreen(),
            ),
            GoRoute(
              path: Routes.auth[Auth.register]!,
              name: Routes.auth[Auth.register]!,
              builder: (BuildContext context, GoRouterState state) =>
                  const RegisterScreen(),
            ),
          ]),
      StatefulShellRoute.indexedStack(
        builder: (BuildContext context, GoRouterState state,
            StatefulNavigationShell navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/home',
                name: Routes.main[Main.home]!,
                builder: (BuildContext context, GoRouterState state) {
                  return const HomeScreen();
                },
                routes: [
                  GoRoute(
                    path: 'movies',
                    builder: (context, state) => const MovieListScreen(),
                    routes: <GoRoute>[
                      GoRoute(
                        parentNavigatorKey: _rootNavigatorKey,
                        path: 'booking',
                        builder: (BuildContext context, GoRouterState state) {
                          return const MovieReservationScreen();
                        },
                      ),
                      GoRoute(
                        parentNavigatorKey: _rootNavigatorKey,
                        path: ':movieId',
                        builder: (BuildContext context, GoRouterState state) {
                          final movieId =
                              int.parse(state.pathParameters['movieId']!);
                          return MovieDetailScreen(id: movieId);
                        },
                      ),
                    ],
                  ),
                  // GoRoute(
                  //   path: Routes.home[Home.movieDetail]!,
                  //   name: Routes.home[Home.movieDetail]!,
                  //   builder: (BuildContext context, dynamic state) {
                  //     final movieId = state.extra as int;
                  //     return MovieDetailScreen(id: movieId);
                  //   },
                  // ),
                ],
              )
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                  path: '/news',
                  name: Routes.main[Main.news]!,
                  builder: (BuildContext context, GoRouterState state) =>
                      const NewScreen())
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                  path: '/profile',
                  name: Routes.main[Main.profile]!,
                  builder: (BuildContext context, GoRouterState state) =>
                      const ProfileScreen())
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );

  static GoRouter get router => _router;

  static GlobalKey<NavigatorState> get currentContext => _rootNavigatorKey;
}

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({required this.navigationShell, Key? key})
      : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    bool isNeedSafeArea = MediaQuery.of(context).viewPadding.bottom > 0;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: navigationShell,
      bottomNavigationBar: Container(
        height: isNeedSafeArea ? 100 : 80,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          boxShadow: [
            BoxShadow(color: Colors.black26, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                label: 'Home',
                icon: SvgPicture.asset(tabHome,
                    colorFilter:
                        ColorFilter.mode(Colors.grey[500]!, BlendMode.srcIn)),
                activeIcon: SvgPicture.asset(tabHome,
                    colorFilter:
                        ColorFilter.mode(Colors.green[500]!, BlendMode.srcIn)),
              ),
              BottomNavigationBarItem(
                label: 'News',
                icon: SvgPicture.asset(tabList,
                    colorFilter:
                        ColorFilter.mode(Colors.grey[500]!, BlendMode.srcIn)),
                activeIcon: SvgPicture.asset(tabList,
                    colorFilter:
                        ColorFilter.mode(Colors.green[500]!, BlendMode.srcIn)),
              ),
              BottomNavigationBarItem(
                label: 'Profile',
                icon: SvgPicture.asset(tabProfile,
                    colorFilter:
                        ColorFilter.mode(Colors.grey[500]!, BlendMode.srcIn)),
                activeIcon: SvgPicture.asset(tabProfile,
                    colorFilter:
                        ColorFilter.mode(Colors.green[500]!, BlendMode.srcIn)),
              )
            ],
            currentIndex: navigationShell.currentIndex,
            onTap: (int index) => _onTap(context, index),
            unselectedItemColor: HexColor.fromHex('7F7D83'),
            selectedItemColor: HexColor.fromHex('67A346'),
            selectedLabelStyle:
                const TextStyle(fontSize: 10, fontFamily: 'Inter'),
            unselectedLabelStyle:
                const TextStyle(fontSize: 9, fontFamily: 'Inter'),
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }

  /// Navigate to the current location of the branch at the provided index when
  /// tapping an item in the BottomNavigationBar.
  void _onTap(BuildContext context, int index) {
    if (navigationShell.currentIndex != index) {
      navigationShell.goBranch(index,
          initialLocation: index == navigationShell.currentIndex);
    }
  }
}

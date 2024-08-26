import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:auth_flow_flutter_rxdart/di/injection.dart';
import 'package:auth_flow_flutter_rxdart/common/extensions/bloc_provider.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/widgets/movie_cell_widget.dart';
import 'package:auth_flow_flutter_rxdart/presentation/navigations/navigator/home_navigator.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/home/widgets/search_widget.dart';
import 'package:auth_flow_flutter_rxdart/presentation/components/app_carousel.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/home/widgets/category_widget.dart';
import 'package:auth_flow_flutter_rxdart/presentation/assets/images/app_images.dart';
import 'package:auth_flow_flutter_rxdart/presentation/components/app_button.dart';
import 'package:auth_flow_flutter_rxdart/presentation/components/fast_image.dart';
import 'package:auth_flow_flutter_rxdart/presentation/components/app_bar.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_bloc.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_state.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/profile/profile_state.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/profile/profile_bloc.dart';

const String icNotification = AppImages.icNotification;
const String icSearch = AppImages.icSearch;
const outerList = ['search', 'category', 'movie'];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late MovieBloc _movieBloc;

  @override
  void initState() {
    super.initState();
    _createBloc();
  }

  void _createBloc() {
    _movieBloc = BlocProvider.of<MovieBloc>(context);
    _movieBloc.getPopular.add(null);
  }

  @override
  void dispose() {
    _movieBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileBloc = BlocProvider.of<ProfileBloc>(context);
    return StreamBuilder(
        stream: profileBloc.getProfileMessage$,
        builder: (context, snapshot) {
          return CustomAppBar(
            type: AppbarType.profile,
            title: 'Home Screen',
            childLeading: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Center(
                    child: ClipOval(
                      child: SizedBox.fromSize(
                          size: const Size.fromRadius(20),
                          // Image radius
                          child: FastImage(
                            url: snapshot.data is ProfileSuccess
                                ? snapshot.data?.data.photoURL
                                : null,
                            fit: BoxFit.cover,
                            width: 40,
                            height: 40,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                          )),
                    ),
                  ),
                  const Text(
                    'Home',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  AppTouchable(
                      onPress: () {
                        // Open the notifications
                      },
                      child: SvgPicture.asset(
                        icNotification,
                        fit: BoxFit.scaleDown,
                        width: 24.0,
                        height: 24.0,
                      ))
                ],
              ),
            ),
            child: RefreshIndicator(
              onRefresh: () async {},
              child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(
                      parent: Platform.isIOS
                          ? const BouncingScrollPhysics()
                          : const ClampingScrollPhysics()),
                  itemCount: outerList.length,
                  itemBuilder: (context, index) {
                    final item = outerList[index];
                    switch (item) {
                      case 'search':
                        // return SearchWidget(bloc: profileBloc);
                        return const SearchWidget();
                      case 'category':
                        return const CategoryWidget();
                      case 'movie':
                        return _renderMovieWidget();
                      default:
                        return const SizedBox.shrink();
                    }
                  }),
            ),
          );
        });
  }

  Widget _renderMovieWidget() {
    final movieBloc = BlocProvider.of<MovieBloc>(context).getPopular.add(null);

    return Column(children: <Widget>[
      Container(
        margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text(
              'Popular',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            AppTouchable(
              onPress: () {
                // Open the category screen
                HomeNavigator.openMovieList(context);
              },
              child: const Text(
                'See all',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
      StreamBuilder(
        stream: _movieBloc.getPopularMessage$,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final state = snapshot.data;
            if (state is MovieListSuccess) {
              final movies = state.data?.results;
              return AppCarousel(
                itemCount: movies,
                itemBuilder: (BuildContext context, int index) {
                  return MovieCellWidget(
                      width: 1000,
                      movieCardItem: movies![index],
                      onPressed: () {
                        HomeNavigator.openMovieDetail(
                            context, movies[index].id);
                      });
                },
              );
            } else if (state is MovieListError) {
              return Text('Movie Error: ${state.message}');
            }
          }
          return const SizedBox.shrink();
        },
      )
    ]);
  }
}

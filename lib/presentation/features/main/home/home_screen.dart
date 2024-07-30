import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:auth_flow_flutter_rxdart/di/injection.dart';
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
const outerList = ['search', 'category', 'movie', 'movie', 'movie'];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _profileBloc = injector.get<ProfileBloc>();
  final _movieBloc = injector.get<MovieBloc>();

  @override
  void initState() {
    super.initState();
    _movieBloc.getPopular.add(null);
    _movieBloc.getGenreMovie.add(null);
  }

  @override
  void dispose() {
    // Dispose of the ProfileBloc here
    _profileBloc.close();
    _movieBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
        builder: (BuildContext context, state) {
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
                        url: state is ProfileSuccess ? state.data.photoURL : '',
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
              final movies = state.data.results;
              return AppCarousel(
                itemCount: movies,
                itemBuilder: (BuildContext context, int index) {
                  final movie = movies[index];
                  return Container(
                      margin: const EdgeInsets.all(2),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(36),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w300${movie.posterPath}',
                            fit: BoxFit.cover,
                            width: 1000,
                          )));
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

import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:auth_flow_flutter_rxdart/common/extensions/bloc_provider.dart';
import 'package:auth_flow_flutter_rxdart/presentation/navigations/navigator/home_navigator.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/home/widgets/movie_widget.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/home/widgets/search_widget.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/home/widgets/category_widget.dart';
import 'package:auth_flow_flutter_rxdart/presentation/assets/images/app_images.dart';
import 'package:auth_flow_flutter_rxdart/presentation/components/app_button.dart';
import 'package:auth_flow_flutter_rxdart/presentation/components/fast_image.dart';
import 'package:auth_flow_flutter_rxdart/presentation/components/app_bar.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_bloc.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/profile/profile_state.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/profile/profile_bloc.dart';

const String icNotification = AppImages.icNotification;
const String icSearch = AppImages.icSearch;
const outerList = ['search', 'category', 'movie'];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late MovieBloc _movieBloc;
  late ProfileBloc _profileBloc;

  @override
  void initState() {
    super.initState();
    _profileBloc = BlocProvider.of<ProfileBloc>(context)!;
    _movieBloc = BlocProvider.of<MovieBloc>(context)!;
    _profileBloc.getProfile.add(null);
    _movieBloc.getPopular.add(null);
    _movieBloc.getGenreMovie.add(null);
  }

  @override
  void dispose() {
    _movieBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _profileBloc.getProfileMessage$,
        builder: (context, snapshot) {
          return CustomAppBar(
            type: AppbarType.home,
            title: 'Home',
            actions: [
              AppTouchable(
                  onPress: () {
                    HomeNavigator.openFavouriteList(context);
                  },
                  child: const Icon(
                    Icons.favorite_outline_rounded,
                    color: Colors.black,
                  )),
              const SizedBox(width: 16.0),
              AppTouchable(
                  onPress: () {
                    HomeNavigator.openNotificationList(context);
                  },
                  child: SvgPicture.asset(
                    icNotification,
                    fit: BoxFit.scaleDown,
                    width: 24.0,
                    height: 24.0,
                  )),
              const SizedBox(width: 16.0),
            ],
            childLeading: Container(
              margin: const EdgeInsets.only(left: 16.0),
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
                  // const Text(
                  //   'Home',
                  //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  // ),
                  // AppTouchable(
                  //     onPress: () {
                  //       // Open the notifications
                  //     },
                  //     child: SvgPicture.asset(
                  //       icNotification,
                  //       fit: BoxFit.scaleDown,
                  //       width: 24.0,
                  //       height: 24.0,
                  //     )),
                  // AppTouchable(
                  //     onPress: () {
                  //       // Open the notifications
                  //     },
                  //     child: SvgPicture.asset(
                  //       icNotification,
                  //       fit: BoxFit.scaleDown,
                  //       width: 24.0,
                  //       height: 24.0,
                  //     ))
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
                        return const MovieWidget();
                      default:
                        return const SizedBox.shrink();
                    }
                  }),
            ),
          );
        });
  }
}

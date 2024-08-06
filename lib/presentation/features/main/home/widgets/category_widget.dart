import 'dart:io';
import 'package:auth_flow_flutter_rxdart/di/injection.dart';
import 'package:flutter/material.dart';

import 'package:auth_flow_flutter_rxdart/common/extensions/color_extensions.dart';
import 'package:auth_flow_flutter_rxdart/common/extensions/dark_mode_extensions.dart';
import 'package:auth_flow_flutter_rxdart/presentation/components/app_button.dart';
import 'package:auth_flow_flutter_rxdart/presentation/components/box_wapper.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_bloc.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_state.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key});

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> with AutomaticKeepAliveClientMixin {
  final _movieBloc = injector.get<MovieBloc>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _movieBloc.getGenreMovie.add(null);
  }

  @override
  void dispose() {
    _movieBloc.disposeBag();
    print('CategoryWidget dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                'Categories',
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
        Container(
          height: 40,
          margin: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 24.0),
          child: StreamBuilder(
            stream: _movieBloc.getGenreMovieMessage$,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final state = snapshot.data;
                if (state is GenreMovieListSuccess) {
                  final genres = state.data;
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: AlwaysScrollableScrollPhysics(
                          parent: Platform.isIOS
                              ? const BouncingScrollPhysics()
                              : const ClampingScrollPhysics()),
                      shrinkWrap: true,
                      itemCount: genres?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        return BoxWapper(
                            key: ValueKey(genres[index].id),
                            title: genres[index].name,
                            borderRadius: 8.0,
                            borderColor: context.isDarkMode == true
                                ? Colors.transparent
                                : HexColor.fromHex('7F7D83'),
                            color: context.isDarkMode == true
                                ? HexColor.fromHex('7F7D83')
                                : Colors.transparent);
                      });
                } else if (state is GenreMovieListError) {
                  return Text('Genre Movie List Error: ${state.message}');
                }
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}

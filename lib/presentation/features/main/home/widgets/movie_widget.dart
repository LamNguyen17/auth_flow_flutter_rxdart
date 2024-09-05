import 'package:flutter/material.dart';

import 'package:auth_flow_flutter_rxdart/common/extensions/bloc_provider.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_bloc.dart';
import 'package:auth_flow_flutter_rxdart/presentation/components/app_button.dart';
import 'package:auth_flow_flutter_rxdart/presentation/components/app_carousel.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_state.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/widgets/movie_cell_widget.dart';
import 'package:auth_flow_flutter_rxdart/presentation/navigations/navigator/home_navigator.dart';

class MovieWidget extends StatelessWidget {
  const MovieWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final movieBloc = BlocProvider.of<MovieBloc>(context);
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
        stream: movieBloc?.getPopularMessage$,
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

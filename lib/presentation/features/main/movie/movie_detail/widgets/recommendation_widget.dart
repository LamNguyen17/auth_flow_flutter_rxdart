import 'dart:io';
import 'package:flutter/material.dart';

import 'package:auth_flow_flutter_rxdart/presentation/components/app_button.dart';
import 'package:auth_flow_flutter_rxdart/presentation/navigations/navigator/movie_navigator.dart';
import 'package:auth_flow_flutter_rxdart/presentation/components/fast_image.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_bloc.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_state.dart';

class RecommendationWidget extends StatelessWidget {
  final MovieBloc _movieBloc;

  const RecommendationWidget({super.key, required MovieBloc bloc})
      : _movieBloc = bloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _movieBloc.getMovieRecommendationMessage$,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data is MovieRecommendationSuccess) {
            final movie = snapshot.data.data?.results;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (movie != null || movie.isNotEmpty) ...[
                  const Text('Recommendations',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  SizedBox(
                      height: 250,
                      child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(
                            parent: Platform.isIOS
                                ? const BouncingScrollPhysics()
                                : const ClampingScrollPhysics()),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        // children: movie
                        //     .map<Widget>((item) => Container(
                        //         margin: const EdgeInsets.all(8.0),
                        //         child: FastImage(
                        //           key: PageStorageKey<int>(item.id),
                        //           url:
                        //               'https://image.tmdb.org/t/p/original${item.posterPath}',
                        //           width: 200,
                        //           height: 250,
                        //           fit: BoxFit.cover,
                        //           borderRadius:
                        //               const BorderRadius.all(Radius.circular(16)),
                        //         )))
                        //     .toList()
                        itemCount: movie?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          return AppTouchable(
                              onPress: () {
                                MovieNavigator.openMovieDetail(
                                    context, movie[index].id);
                              },
                              child: Container(
                                  key: ValueKey(
                                      movie[index].id), // Use a unique key
                                  margin: const EdgeInsets.only(
                                      right: 16.0, top: 8.0),
                                  child: FastImage(
                                    url:
                                        'https://image.tmdb.org/t/p/original${movie![index].posterPath}',
                                    width: 200,
                                    height: 250,
                                    fit: BoxFit.cover,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(16)),
                                  )));
                        },
                      )),
                ] else ...[
                  const SizedBox.shrink(),
                ]
              ],
            );
          }
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

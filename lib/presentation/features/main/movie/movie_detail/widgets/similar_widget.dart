import 'dart:io';
import 'package:flutter/material.dart';

import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_state.dart';
import 'package:auth_flow_flutter_rxdart/presentation/navigations/navigator/movie_navigator.dart';
import 'package:auth_flow_flutter_rxdart/presentation/components/fast_image.dart';
import 'package:auth_flow_flutter_rxdart/presentation/components/app_button.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_bloc.dart';

class SimilarWidget extends StatelessWidget {
  final MovieBloc _movieBloc;

  const SimilarWidget({super.key, required MovieBloc bloc}) : _movieBloc = bloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _movieBloc.getMovieSimilarMessage$,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data is MovieSimilarSuccess) {
            final movie = snapshot.data.data?.results;
            return Padding(
                padding: movie != null && movie.isNotEmpty
                    ? const EdgeInsets.only(left: 16.0, top: 16.0)
                    : const EdgeInsets.all(0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (movie != null && movie.isNotEmpty) ...[
                        const Text('Similar',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600)),
                        SizedBox(
                            height: 250,
                            child: ListView.builder(
                                physics: AlwaysScrollableScrollPhysics(
                                    parent: Platform.isIOS
                                        ? const BouncingScrollPhysics()
                                        : const ClampingScrollPhysics()),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: movie?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  print(
                                      'itemBuilder: ${movie[index]?.posterPath}');
                                  return AppTouchable(
                                      onPress: () {
                                        MovieNavigator.openMovieDetail(
                                            context, movie[index].id);
                                      },
                                      child: Container(
                                        key: ValueKey(movie[index].id),
                                        width: 200,
                                        height: 250,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey[300]!,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                        margin: const EdgeInsets.only(
                                            right: 16.0, top: 8.0),
                                        child: FastImage(
                                          url: movie[index]?.posterPath == null
                                              ? null
                                              : 'https://image.tmdb.org/t/p/w300${movie[index]?.posterPath}',
                                          width: 200,
                                          height: 250,
                                          fit: BoxFit.cover,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(16.0)),
                                        ),
                                      ));
                                })),
                      ] else ...[
                        const SizedBox.shrink(),
                      ]
                    ]));
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

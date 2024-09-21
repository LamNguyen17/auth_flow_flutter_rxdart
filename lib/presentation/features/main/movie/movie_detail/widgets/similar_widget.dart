import 'dart:io';
import 'package:flutter/material.dart';

import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/widgets/movie_cell_widget.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_state.dart';
import 'package:auth_flow_flutter_rxdart/presentation/navigations/navigator/movie_navigator.dart';
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
                                  return MovieCellWidget(
                                      movieCardItem: movie[index],
                                      onPressed: () {
                                        MovieNavigator.openMovieDetail(
                                            context, movie[index].id);
                                      });
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

import 'package:flutter/material.dart';

import 'package:auth_flow_flutter_rxdart/common/extensions/bloc_provider.dart';
import 'package:auth_flow_flutter_rxdart/domain/entities/movie/movie_list.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_bloc.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_state.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/widgets/movie_cell_widget.dart';
import 'package:auth_flow_flutter_rxdart/presentation/navigations/navigator/movie_navigator.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  late MovieBloc _movieBloc;

  @override
  void initState() {
    super.initState();
    _movieBloc = BlocProvider.of<MovieBloc>(context)!;
    _movieBloc.getPopular.add(null);
  }

  @override
  void dispose() {
    _movieBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('Movie List Screen'),
        ),
        body: RefreshIndicator(
            onRefresh: () async {},
            child: Container(
              margin: const EdgeInsets.only(left: 16.0),
              child: StreamBuilder(
                  stream: _movieBloc.getPopularMessage$,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      final state = snapshot.data;
                      if (state is MovieListSuccess) {
                        final movies = state.data?.results;
                        if (movies!.isEmpty) {
                          return const Center(
                            child: Text('No data'),
                          );
                        } else {
                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.0,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return _renderStatePage(movies[index]);
                            },
                            itemCount: movies.length,
                          );
                        }
                      }
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            )));
  }

  Widget _renderStatePage(MovieItem movie) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (scrollInfo is ScrollStartNotification) {
        } else if (scrollInfo is ScrollUpdateNotification) {
        } else if (scrollInfo is ScrollEndNotification) {
          // if (state.hasReachedMax &&
          //     scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          //   _photoBloc1.input.onLoadMore.add(null);
          // }
        }
        return false;
      },
      child: MovieCellWidget(
          movieCardItem: movie,
          onPressed: () {
            MovieNavigator.openMovieDetail(context, movie.id);
          }),
    );
  }
}

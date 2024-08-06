import 'package:auth_flow_flutter_rxdart/domain/entities/movie/movie_list.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_state.dart';
import 'package:flutter/material.dart';

import 'package:auth_flow_flutter_rxdart/di/injection.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_bloc.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final _movieBloc = injector.get<MovieBloc>();

  @override
  void initState() {
    super.initState();
    _movieBloc.getPopular.add(null);
  }

  @override
  void dispose() {
    super.dispose();
    _movieBloc.disposeBag();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Movie List Screen'),
      ),
      body: StreamBuilder(
          stream: _movieBloc.getPopularMessage$,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              final state = snapshot.data;
              if (state is MovieListSuccess) {
                final movies = state.data?.results;
                return ListView.builder(
                  itemCount: movies?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    final ResultItem? movie = movies?[index];
                    return ListTile(
                      title: Text('${movie?.title}'),
                      subtitle: Text('${movie?.overview}'),
                    );
                  },
                );
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}

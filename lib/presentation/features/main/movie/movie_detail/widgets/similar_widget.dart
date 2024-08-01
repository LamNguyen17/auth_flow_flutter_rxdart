import 'package:flutter/material.dart';

import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_state.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_bloc.dart';

class SimilarWidget extends StatelessWidget {
  final MovieBloc _movieBloc;

  const SimilarWidget({super.key, required MovieBloc bloc})
      : _movieBloc = bloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _movieBloc.getMovieSimilarMessage$,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data is MovieSimilarSuccess) {
            final movie = snapshot.data.data?.results;
            return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: movie?.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                      leading: const Icon(Icons.list),
                      title: Text("${movie![index].title}"));
                });
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
import 'package:auth_flow_flutter_rxdart/di/injection.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_bloc.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:auth_flow_flutter_rxdart/presentation/features/main/profile/profile_state.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/profile/profile_bloc.dart';

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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Home Screen'),
      ),
      body: StreamBuilder(
        stream: _movieBloc.getPopularError$,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final state = snapshot.data;
            if (state is MovieSuccess) {
              final movies = state.data.results;
              return ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return Container(
                    margin: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Image.network(
                          'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          movie.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          movie.overview,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );

                },
              );
            } else if (state is MovieError) {
              return Text('Movie Error: ${state.message}');
            }
          }
          return const SizedBox.shrink();
        },
      ),

      // body: BlocBuilder<ProfileBloc, ProfileState>(
      //   builder: (context, state) {
      //     if (state is ProfileSuccess) {
      //       final user = state.data;
      //       return Text(
      //         user.displayName ?? '',
      //         style: const TextStyle(
      //           fontSize: 26,
      //         ),
      //       );
      //     } else if (state is ProfileError) {
      //       return Text('Profile Error: ${state.message}');
      //     }
      //     return const SizedBox.shrink();
      //   },
      // ),
    );
  }
}

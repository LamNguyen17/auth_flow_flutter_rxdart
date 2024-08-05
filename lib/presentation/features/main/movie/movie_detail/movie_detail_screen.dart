import 'dart:io';
import 'package:auth_flow_flutter_rxdart/presentation/navigations/navigator/movie_navigator.dart';
import 'package:flutter/material.dart';

import 'package:auth_flow_flutter_rxdart/di/injection.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_detail/widgets/genres_widget.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_detail/widgets/overview_widget.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_detail/widgets/app_bar/leading_app_bar_widget.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_detail/widgets/app_bar/expanded_app_bar_widget.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_detail/widgets/app_bar/collapsed_app_bar_widget.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_detail/widgets/keyword_widget.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_detail/widgets/recommendation_widget.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_detail/widgets/similar_widget.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_bloc.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_state.dart';

const collapsedBarHeight = 60.0;
const expandedBarHeight = 350.0;

class MovieDetailScreen extends StatefulWidget {
  final int id;

  const MovieDetailScreen({super.key, required this.id});

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final _movieBloc = injector.get<MovieBloc>();

  @override
  void initState() {
    super.initState();
    _movieBloc.getMovieDetail.add(widget.id);
    _movieBloc.getMovieKeyword.add(widget.id);
    _movieBloc.getMovieSimilar.add(widget.id);
    _movieBloc.getMovieRecommendation.add(widget.id);
  }

  @override
  void dispose() {
    super.dispose();
    _movieBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: _movieBloc.getMovieDetailMessage$,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final state = snapshot.data;
          if (state is MovieDetailSuccess) {
            final movie = state.data;
            return NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  /** Listen to scroll vertical to collapse app bar */
                  if (scrollInfo.metrics.axis == Axis.vertical) {
                    var isCollapsed = scrollInfo.metrics.pixels >
                        (expandedBarHeight - collapsedBarHeight);
                    _movieBloc.isCollapsed.add(isCollapsed);
                  }
                  return false;
                },
                child: Stack(children: [
                  CustomScrollView(
                      physics: AlwaysScrollableScrollPhysics(
                          parent: Platform.isIOS
                              ? const BouncingScrollPhysics()
                              : const ClampingScrollPhysics()),
                      slivers: <Widget>[
                        SliverAppBar(
                          pinned: true,
                          expandedHeight: expandedBarHeight,
                          centerTitle: true,
                          leading: LeadingAppBarWidget(bloc: _movieBloc),
                          title: CollapsedAppBarWidget(
                              bloc: _movieBloc, data: movie),
                          flexibleSpace: ExpandedAppBarWidget(data: movie),
                        ),
                        SliverToBoxAdapter(
                          child: Container(
                            padding:
                                const EdgeInsets.only(left: 16.0, top: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${movie.originalTitle}',
                                  style: const TextStyle(
                                      fontSize: 26.0,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text('Release date : ${movie.releaseDate}'),
                                Text('Status : ${movie.status}'),
                                const SizedBox(height: 16.0),
                                Text('Budget : ${movie.budget}'),
                                Text('Revenue : ${movie.revenue}'),
                              ],
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                            child: GenresWidget(genre: movie.genres)),
                        SliverToBoxAdapter(
                            child: KeywordWidget(bloc: _movieBloc)),
                        SliverToBoxAdapter(
                            child: OverviewWidget(overview: movie.overview)),
                        SliverToBoxAdapter(
                            child: RecommendationWidget(bloc: _movieBloc)),
                        SliverToBoxAdapter(
                            child: SimilarWidget(bloc: _movieBloc)),
                        const SliverToBoxAdapter(child: SizedBox(height: 100)),
                      ]),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Colors.white,
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          MovieNavigator.openMovieReservation(context);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // Change the value to your desired radius
                          ),
                        ),
                        child: const Text('Get reservation'),
                      ),
                    ),
                  ),
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
    ));
  }
}

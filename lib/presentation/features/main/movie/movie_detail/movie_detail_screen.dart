import 'dart:io';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:auth_flow_flutter_rxdart/di/injection.dart';
import 'package:auth_flow_flutter_rxdart/common/extensions/double_extensions.dart';
import 'package:auth_flow_flutter_rxdart/common/extensions/color_extensions.dart';
import 'package:auth_flow_flutter_rxdart/domain/entities/movie/movie_detail.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_detail/widgets/app_bar/leading_app_bar_widget.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_detail/widgets/app_bar/expanded_app_bar_widget.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_detail/widgets/app_bar/collapsed_app_bar_widget.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_detail/widgets/keyword_widget.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_detail/widgets/recommendation_widget.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_detail/widgets/similar_widget.dart';
import 'package:auth_flow_flutter_rxdart/presentation/components/box_wapper.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_bloc.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_state.dart';

class MovieDetailScreen extends StatefulWidget {
  final int id;

  const MovieDetailScreen({super.key, required this.id});

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

const collapsedBarHeight = 60.0;
const expandedBarHeight = 350.0;

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
                  var isCollapsed = scrollInfo.metrics.pixels >
                      (expandedBarHeight - collapsedBarHeight);
                  _movieBloc.isCollapsed.add(isCollapsed);
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
                          child: Padding(
                            padding:
                            const EdgeInsets.only(left: 16.0, top: 16.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Genres',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 8.0),
                                  _renderContentMovie(movie.genres),
                                ]),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, top: 16.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Keywords',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 8.0),
                                  _renderKeywordsMovie(_movieBloc),
                                ]),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, top: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Overview',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600)),
                                Text('${movie.overview}'),
                              ],
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, top: 16.0),
                            child: _renderRecommendationsMovie(_movieBloc),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, top: 16.0),
                            child: _renderSimilarMovie(_movieBloc),
                          ),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(
                              height:
                                  100), // Spacer to ensure footer visibility
                        ),
                      ]),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Colors.white,
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle button press
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

  Widget _renderSimilarMovie(MovieBloc movieBloc) {
    return SimilarWidget(bloc: movieBloc);
  }

  Widget _renderRecommendationsMovie(MovieBloc movieBloc) {
    return RecommendationWidget(bloc: movieBloc);
  }

  Widget _renderKeywordsMovie(MovieBloc movieBloc) {
    return KeywordWidget(bloc: movieBloc);
  }

  Widget _renderContentMovie(List<dynamic> movie) {
    return Row(
        children: movie
            .map((item) => BoxWapper(
                borderRadius: 16.0,
                title: '${item.name}',
                color: HexColor.fromHex('7F7D83')))
            .toList());
  }
}

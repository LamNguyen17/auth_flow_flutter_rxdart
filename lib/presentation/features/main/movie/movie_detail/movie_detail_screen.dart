import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:auth_flow_flutter_rxdart/di/injection.dart';
import 'package:auth_flow_flutter_rxdart/common/extensions/double_extensions.dart';
import 'package:auth_flow_flutter_rxdart/common/extensions/color_extensions.dart';
import 'package:auth_flow_flutter_rxdart/domain/entities/movie/movie_detail.dart';
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
            return CustomScrollView(
                physics: AlwaysScrollableScrollPhysics(
                    parent: Platform.isIOS
                        ? const BouncingScrollPhysics()
                        : const ClampingScrollPhysics()),
                slivers: <Widget>[
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: 350.0,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        '${movie.originalTitle}',
                        style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      titlePadding: const EdgeInsetsDirectional.only(
                          start: 16.0, bottom: 16.0),
                      centerTitle: true,
                      background: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              Image(
                                  image: CachedNetworkImageProvider(
                                      'https://image.tmdb.org/t/p/w300${movie.posterPath}'),
                                  fit: BoxFit.cover),
                              ClipRRect(
                                // Clip it cleanly.
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    color: Colors.grey.withOpacity(0.1),
                                    alignment: Alignment.center,
                                    child: const SizedBox.shrink(),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Release date : ${movie.releaseDate}'),
                            Text('Status : ${movie.status}'),
                            Text('${movie.tagline}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 16.0),
                            _renderContentMovie(movie.genres),
                            const SizedBox(height: 16.0),
                            _renderUserScore(movie),
                            const SizedBox(height: 16.0),
                            Text('Budget : ${movie.budget}'),
                            Text('Revenue : ${movie.revenue}'),
                            const SizedBox(height: 16.0),
                            const Text('Keywords',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8.0),
                            _renderKeywordsMovie(_movieBloc),
                            const SizedBox(height: 16.0),
                            const Text('Overview',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600)),
                            Text('${movie.overview}'),
                            const SizedBox(height: 16.0),
                            const Text('Recommendations',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600)),
                            _renderRecommendationsMovie(_movieBloc),
                            const SizedBox(height: 16.0),
                            const Text('Similar',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600)),
                            _renderSimilarMovie(_movieBloc),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ]);
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

  Widget _renderUserScore(MovieDetail movie) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularPercentIndicator(
          radius: 60.0,
          lineWidth: 13.0,
          percent: movie.voteAverage! * 10 / 100,
          center: Text(
            "${(movie.voteAverage! * 10).toFixed(1)}%",
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: Colors.purple,
        ),
        const SizedBox(width: 16.0),
        const Text('User score'),
      ],
    );
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

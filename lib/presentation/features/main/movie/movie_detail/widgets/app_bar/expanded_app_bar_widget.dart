import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:percent_indicator/circular_percent_indicator.dart';

import 'package:auth_flow_flutter_rxdart/common/extensions/double_extensions.dart';
import 'package:auth_flow_flutter_rxdart/domain/entities/movie/movie_list.dart';
import 'package:auth_flow_flutter_rxdart/presentation/components/fast_image.dart';

const expandedBarHeight = 350.0;

class ExpandedAppBarWidget extends StatelessWidget {
  final MovieItem data;

  const ExpandedAppBarWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double scrollPosition = constraints.biggest.height;
        Color backgroundColor = Colors.transparent;
        if (scrollPosition > 100) {
          backgroundColor = Colors.transparent;
        } else if (scrollPosition > 50) {
          backgroundColor = Colors.black;
        }
        return FlexibleSpaceBar(
          titlePadding:
              const EdgeInsetsDirectional.only(start: 16.0, bottom: 16.0),
          centerTitle: true,
          background: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  FastImage(
                    key: const ValueKey('expanded_app_bar'),
                    url: data.posterPath == null
                        ? null
                        : 'https://image.tmdb.org/t/p/original${data.posterPath}',
                    fit: BoxFit.cover,
                    width: screenWidth,
                    height: expandedBarHeight,
                  ),
                  ClipRRect(
                    // Clip it cleanly.
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        color: Colors.grey.withOpacity(0.1),
                        alignment: Alignment.center,
                        child: const SizedBox.shrink(),
                      ),
                    ),
                  ),
                  Positioned(
                    top: (expandedBarHeight - 200) / 2,
                    left: (screenWidth - (screenWidth / 2)) / 2,
                    child: SizedBox(
                        width: screenWidth / 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Material(
                                borderRadius: BorderRadius.circular(16.0),
                                elevation: 7,
                                clipBehavior: Clip.antiAlias,
                                child: SizedBox(
                                    width: 140,
                                    height: 200,
                                    child: FastImage(
                                      key: const ValueKey(
                                          'expanded_app_bar_poster'),
                                      url: data.posterPath == null
                                          ? null
                                          : 'https://image.tmdb.org/t/p/w300${data.posterPath}',
                                      fit: BoxFit.cover,
                                      width: 140,
                                      height: 200,
                                    ))),
                            const SizedBox(height: 8.0),
                            Text(
                              '${data.originalTitle}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${data.releaseDate}',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey[300],
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        )),
                  ),
                  Positioned(
                    top: (expandedBarHeight - 200) / 2 + 200 - 58,
                    left: (screenWidth - (screenWidth / 2)) / 2 + 116,
                    child: _renderUserScore(data),
                  ),
                ],
              )),
        );
      },
    );
  }

  Widget _renderUserScore(MovieItem movie) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularPercentIndicator(
              radius: 24.0,
              lineWidth: 6.0,
              percent: movie.voteAverage! * 10 / 100,
              center: Text(
                "${(movie.voteAverage! * 10).toFixed(1)}%",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.0),
              ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: Colors.green,
            ),
          ],
        ));
  }
}

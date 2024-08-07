import 'package:flutter/material.dart';

import 'package:auth_flow_flutter_rxdart/domain/entities/movie/movie_list.dart';
import 'package:auth_flow_flutter_rxdart/presentation/components/app_button.dart';
import 'package:auth_flow_flutter_rxdart/presentation/components/fast_image.dart';

class MovieCellWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final ResultItem movieCardItem;
  final double? width;
  final double? height;

  const MovieCellWidget(
      {super.key, required this.movieCardItem, this.width, this.height,  this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AppTouchable(
      onPress: onPressed,
      child: Container(
          key: ValueKey(movieCardItem.id),
          width: width ?? 200,
          height: height ?? 250,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(16.0),
          ),
          margin: const EdgeInsets.only(right: 16.0, top: 8.0),
          child: Stack(
            fit: StackFit.expand,
            children: [
              FastImage(
                width: width ?? 200,
                height: height ?? 250,
                fit: BoxFit.cover,
                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                url: movieCardItem.posterPath == null
                    ? null
                    : 'https://image.tmdb.org/t/p/w300${movieCardItem.posterPath}',
              ),
              Container(
                decoration: _buildGradientBackground(),
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: _buildTextualInfo(movieCardItem),
              ),
            ],
          )),
    );
  }

  BoxDecoration _buildGradientBackground() {
    return const BoxDecoration(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(16.0),
        bottomRight: Radius.circular(16.0),
      ),
      gradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        stops: <double>[0.0, 0.7, 0.7],
        colors: <Color>[
          Colors.black,
          Colors.transparent,
          Colors.transparent,
        ],
      ),
    );
  }

  Widget _buildTextualInfo(ResultItem movieCardItem) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          '${movieCardItem.title}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          '${movieCardItem.voteAverage}',
          style: const TextStyle(
            fontSize: 12.0,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}

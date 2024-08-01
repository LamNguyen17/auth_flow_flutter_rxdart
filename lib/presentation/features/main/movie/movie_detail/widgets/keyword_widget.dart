import 'package:flutter/material.dart';

import 'package:auth_flow_flutter_rxdart/common/extensions/color_extensions.dart';
import 'package:auth_flow_flutter_rxdart/presentation/components/box_wapper.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_bloc.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_state.dart';

class KeywordWidget extends StatelessWidget {
  final MovieBloc _movieBloc;

  const KeywordWidget({super.key, required MovieBloc bloc})
      : _movieBloc = bloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _movieBloc.getMovieKeywordMessage$,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data is MovieKeywordSuccess) {
            final keywords = snapshot.data.data?.keywords;
            return Wrap(
              direction: Axis.horizontal,
              runSpacing: 12.0, // <-- Spacing between down the line
              children: keywords
                  .map<Widget>((item) => BoxWapper(
                      borderRadius: 16.0,
                      title: '${item.name}',
                      color: HexColor.fromHex('7F7D83')))
                  .toList(),
            );
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

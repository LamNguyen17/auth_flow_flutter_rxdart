import 'package:auth_flow_flutter_rxdart/domain/entities/movie/movie_detail.dart';
import 'package:flutter/material.dart';

import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_bloc.dart';

class CollapsedAppBarWidget extends StatelessWidget {
  final MovieBloc _movieBloc;
  final MovieDetail data;

  const CollapsedAppBarWidget(
      {super.key, required MovieBloc bloc, required this.data})
      : _movieBloc = bloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _movieBloc.isCollapsed$,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final isCollapsed = snapshot.data;
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 0),
            opacity: isCollapsed ? 1 : 0,
            child: Text('${data.originalTitle}',
                style: TextStyle(
                    fontSize: 14.0,
                    color: isCollapsed ? Colors.black : Colors.transparent,
                    fontWeight: FontWeight.bold)),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

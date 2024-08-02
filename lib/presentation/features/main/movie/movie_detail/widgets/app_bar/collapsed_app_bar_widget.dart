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
    return StreamBuilder<bool>(
      stream: _movieBloc.isCollapsed$,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final bool isCollapsed = snapshot.data;
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: isCollapsed ? Text('${data.originalTitle}',
                style: TextStyle(
                    fontSize: 14.0,
                    color: isCollapsed ? Colors.black : Colors.transparent,
                    fontWeight: FontWeight.bold)) : const SizedBox.shrink(),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

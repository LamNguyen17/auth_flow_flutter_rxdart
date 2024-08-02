import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_bloc.dart';
import 'package:flutter/material.dart';

class LeadingAppBarWidget extends StatelessWidget {
  final MovieBloc _movieBloc;

  const LeadingAppBarWidget({super.key, required MovieBloc bloc})
      : _movieBloc = bloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _movieBloc.isCollapsed$,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final isCollapsed = snapshot.data;
          return BackButton(
            color: isCollapsed ? Colors.black : Colors.white,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

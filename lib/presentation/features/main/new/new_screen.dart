import 'dart:io';
import 'package:auth_flow_flutter_rxdart/domain/entities/movie/movie_list.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/widgets/movie_cell_widget.dart';
import 'package:flutter/material.dart';

import 'package:auth_flow_flutter_rxdart/common/extensions/bloc_provider.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/new/favourite_bloc.dart';

class NewScreen extends StatelessWidget {
  const NewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favouriteBloc = BlocProvider.of<FavouriteBloc>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('New Screen'),
      ),
      body: StreamBuilder(
        stream: favouriteBloc.favoriteList$,
        builder: (context, snapshot) {
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const SizedBox.shrink();
          }
          return ListView.builder(
              physics: AlwaysScrollableScrollPhysics(
                  parent: Platform.isIOS
                      ? const BouncingScrollPhysics()
                      : const ClampingScrollPhysics()),
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return Container(
                    margin: const EdgeInsets.only(left: 16),
                    child: MovieCellWidget(
                        movieCardItem: snapshot.data![index],
                        onPressed: () {}));
              });
        },
      ),
    );
  }
}

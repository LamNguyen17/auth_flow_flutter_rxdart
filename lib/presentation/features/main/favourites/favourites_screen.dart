import 'dart:io';
import 'package:flutter/material.dart';

import 'package:auth_flow_flutter_rxdart/common/extensions/bloc_provider.dart';
import 'package:auth_flow_flutter_rxdart/presentation/components/app_bar.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/favourites/favourite_bloc.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/widgets/movie_cell_widget.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favouriteBloc = BlocProvider.of<FavouriteBloc>(context);
    return CustomAppBar(
      type: AppbarType.normal,
      title: 'Favourites',
      child: StreamBuilder(
        stream: favouriteBloc.favoriteList$,
        builder: (context, snapshot) {
          print('favouriteBloc: ${snapshot.data}');
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

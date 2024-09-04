import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:auth_flow_flutter_rxdart/common/extensions/bloc_provider.dart';
import 'package:auth_flow_flutter_rxdart/presentation/components/app_bar.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/favourites/favourite_bloc.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/widgets/movie_cell_widget.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  _FavouritesScreenState createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  late FavouriteBloc _favouriteBloc;

  @override
  void initState() {
    super.initState();
    _favouriteBloc = BlocProvider.of<FavouriteBloc>(context);
    _favouriteBloc.getFavouriteList.add(null);
  }

  @override
  Widget build(BuildContext context) {
    final favouriteBloc = BlocProvider.of<FavouriteBloc>(context);
    return CustomAppBar(
      type: AppbarType.normal,
      title: 'Favourites',
      child: StreamBuilder(
        stream: favouriteBloc.favoriteList$,
        builder: (context, snapshot) {
          print('favouriteBloc_snapshot: ${snapshot.data}');
          return !snapshot.hasData
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(
                      parent: Platform.isIOS
                          ? const BouncingScrollPhysics()
                          : const ClampingScrollPhysics()),
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return Container(
                        margin: const EdgeInsets.only(left: 16),
                        child: MovieCellWidget(
                            movieCardItem: snapshot.data?[index],
                            onPressed: () {}));
                  });
        },
      ),
    );
  }
}

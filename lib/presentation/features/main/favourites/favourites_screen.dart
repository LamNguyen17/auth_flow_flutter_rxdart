import 'dart:io';
import 'package:auth_flow_flutter_rxdart/domain/entities/movie/movie_list.dart';
import 'package:auth_flow_flutter_rxdart/presentation/components/app_button.dart';
import 'package:auth_flow_flutter_rxdart/presentation/components/fast_image.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/favourites/favourite_item_bloc.dart';
import 'package:flutter/material.dart';

import 'package:auth_flow_flutter_rxdart/common/extensions/bloc_provider.dart';
import 'package:auth_flow_flutter_rxdart/presentation/components/app_bar.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/favourites/favourite_bloc.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  _FavouritesScreenState createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  late FavouriteBloc _favouriteBloc;
  late FavouriteItemBloc _favouriteItemBloc;

  @override
  void initState() {
    super.initState();
    _favouriteBloc = BlocProvider.of<FavouriteBloc>(context)!;
    _favouriteItemBloc = BlocProvider.of<FavouriteItemBloc>(context)!;
    _favouriteBloc.getFavouriteList.add(null);
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      type: AppbarType.normal,
      title: 'Favourites',
      child: StreamBuilder(
        stream: _favouriteBloc.favoriteList$,
        builder: (context, snapshot) {
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
                        child: MovieFavouriteCellWidget(
                          favouriteItemBloc: _favouriteItemBloc,
                          movieCardItem: snapshot.data?[index],
                        ));
                  });
        },
      ),
    );
  }
}

class MovieFavouriteCellWidget extends StatelessWidget {
  final FavouriteItemBloc favouriteItemBloc;
  final MovieItem movieCardItem;

  const MovieFavouriteCellWidget({
    super.key,
    required this.movieCardItem,
    required this.favouriteItemBloc,
  });

  @override
  Widget build(BuildContext context) {
    return AppTouchable(
        onPress: () {},
        child: Container(
          width: 200,
          height: 250,
          margin: const EdgeInsets.only(right: 16.0, top: 8.0),
          child: Stack(
            fit: StackFit.expand,
            children: [
              FastImage(
                width: 200,
                height: 250,
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
              _renderFavouriteButton(context, favouriteItemBloc),
            ],
          ),
        ));
  }

  Widget _renderFavouriteButton(BuildContext context, FavouriteItemBloc bloc) {
    return StreamBuilder<dynamic>(
        stream: bloc.isFavorite$,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Positioned(
            top: 4.0,
            right: 4.0,
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(50.0),
                ),
                padding: const EdgeInsets.all(8.0),
                child: AppTouchable(
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  onPress: () {
                    print('movieCardItem_docID: ${movieCardItem.docId}');
                    favouriteItemBloc.removeFavourite
                        .add(movieCardItem.docId.toString());
                  },
                )),
          );
        });
  }

  BoxDecoration _buildGradientBackground() {
    return BoxDecoration(
      border: Border.all(
        color: Colors.grey[300]!,
        width: 1,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(16.0)),
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.transparent, Colors.black],
      ),
    );
  }

  Widget _buildTextualInfo(MovieItem? movieCardItem) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          movieCardItem?.originalTitle ?? '',
          style: const TextStyle(
              fontSize: 16.0, color: Colors.red, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4.0),
        Text(
          movieCardItem?.releaseDate ?? '',
          style: const TextStyle(
            fontSize: 12.0,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}

import 'package:auth_flow_flutter_rxdart/domain/entities/movie/movie_list.dart';
import 'package:flutter/material.dart';

import 'package:auth_flow_flutter_rxdart/common/extensions/bloc_provider.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/new/favourite_bloc.dart';

class FavouriteWidget extends StatelessWidget {
  final dynamic movie;

  const FavouriteWidget({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final favouriteBloc = BlocProvider.of<FavouriteBloc>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Text(
              "${movie.originalTitle}",
              style: const TextStyle(
                  fontSize: 26.0,
                  color: Colors.red,
                  fontWeight: FontWeight.bold),
            )),
        StreamBuilder<bool>(
            stream: favouriteBloc.isFavorite$,
            builder: (BuildContext context,
                AsyncSnapshot snapshot) {
              print('FavouriteWidget_build: ${snapshot.data}');
              return Container(
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius:
                    BorderRadius.circular(
                        50.0),
                  ),
                  padding:
                  const EdgeInsets.all(8.0),
                  child: InkWell(
                    child: Icon(
                      Icons.favorite,
                      color: snapshot.data == true
                          ? Colors.red
                          : Colors.grey,
                    ),
                    onTap: () {
                      favouriteBloc.updateFavorite.add(
                          movie);
                    },
                  ));
            }),
      ],
    );
  }
}

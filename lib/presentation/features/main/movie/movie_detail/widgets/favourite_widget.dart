import 'package:auth_flow_flutter_rxdart/domain/usecases/favourite/add_favourite_use_case.dart';
import 'package:flutter/material.dart';

import 'package:auth_flow_flutter_rxdart/presentation/components/app_button.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/favourites/favourite_item_bloc.dart';
import 'package:auth_flow_flutter_rxdart/domain/entities/movie/movie_list.dart';
import 'package:auth_flow_flutter_rxdart/common/extensions/bloc_provider.dart';

class FavouriteWidget extends StatelessWidget {
  final MovieItem movie;

  const FavouriteWidget({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final favouriteItemBloc = BlocProvider.of<FavouriteItemBloc>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Text(
          "${movie.originalTitle}",
          style: const TextStyle(
              fontSize: 26.0, color: Colors.red, fontWeight: FontWeight.bold),
        )),
        StreamBuilder<bool>(
            stream: favouriteItemBloc.isFavorite$,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              print('AsyncSnapshot: ${snapshot.data}');
              return Container(
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: AppTouchable(
                    child: Icon(
                      Icons.favorite,
                      color: snapshot.data == true ? Colors.red : Colors.grey,
                    ),
                    onPress: () {
                      // snapshot.data == true
                      //     ? favouriteItemBloc.removeFavourite.add(movie.id)
                      //     :
                      favouriteItemBloc.addFavourite.add(ReqAddFavouriteCommand(
                        movie.id,
                        movie.title,
                        movie.posterPath,
                        movie.voteAverage
                      ));
                    },
                  ));
            }),
      ],
    );
  }
}

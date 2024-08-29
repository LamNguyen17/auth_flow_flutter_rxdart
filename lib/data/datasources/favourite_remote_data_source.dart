import 'package:auth_flow_flutter_rxdart/domain/usecases/favourite/add_favourite_use_case.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FavouriteRemoteDataSource {
  Future<List<QueryDocumentSnapshot<Object?>>> getFavouriteList();

  Future<dynamic> addFavourite(ReqAddFavouriteCommand req);

  Future<dynamic> removeFavourite(String id);
}

class FavouriteRemoteDataSourceImpl implements FavouriteRemoteDataSource {
  @override
  Future addFavourite(ReqAddFavouriteCommand req) async {
    CollectionReference favourites =
        FirebaseFirestore.instance.collection('favourites');
    final isExists = await hasFavouriteId(req.id);
    if (isExists == true) {
      return await favourites.add({
        'id': req.id,
        'timestamp': Timestamp.now(),
        'title': req.title,
        'poster_path': req.posterPath,
        'vote_average': req.voteAverage,
      });
    }
  }

  @override
  Future<List<QueryDocumentSnapshot<Object?>>> getFavouriteList() async {
    CollectionReference favourites =
        FirebaseFirestore.instance.collection('favourites');
    return favourites.get().then((QuerySnapshot snapshot) => snapshot.docs);
  }

  @override
  Future removeFavourite(String id) async {
    CollectionReference favourites =
        FirebaseFirestore.instance.collection('favourites');
    return await favourites.doc(id).delete();
  }

  Future<bool> hasFavouriteId(int id) async {
    CollectionReference favourites =
        FirebaseFirestore.instance.collection('favourites');
    QuerySnapshot querySnapshot =
        await favourites.where('id', isEqualTo: id).get();
    if (querySnapshot.docs.isEmpty) {
      return true;
    } else {
      return false;
    }
  }
}

import 'package:equatable/equatable.dart';

class GenreMovieList extends Equatable {
  int? id;
  String? name;

  GenreMovieList({
    this.id,
    this.name,
  });

  @override
  List<Object?> get props => [id, name];
}

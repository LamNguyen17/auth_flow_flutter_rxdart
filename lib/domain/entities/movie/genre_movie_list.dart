import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class GenreMovieList extends Equatable {
  final int? id;
  final String? name;

  const GenreMovieList({
    this.id,
    this.name,
  });

  @override
  List<Object?> get props => [id, name];
}

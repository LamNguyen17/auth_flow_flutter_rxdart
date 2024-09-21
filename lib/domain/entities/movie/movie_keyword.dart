import 'package:equatable/equatable.dart';

class MovieKeyword extends Equatable {
  int? id;
  List<Keyword>? keywords;

  MovieKeyword({
    this.id,
    this.keywords,
  });

  @override
  List<Object?> get props => [id, keywords];
}

class Keyword extends Equatable {
  int? id;
  String? name;

  Keyword({
    this.id,
    this.name,
  });

  @override
  List<Object?> get props => [id, name];
}

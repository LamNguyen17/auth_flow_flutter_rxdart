import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class MovieKeyword extends Equatable {
  final int? id;
  final List<Keyword>? keywords;

  const MovieKeyword({
    this.id,
    this.keywords,
  });

  @override
  List<Object?> get props => [id, keywords];
}

@immutable
class Keyword extends Equatable {
  final int? id;
  final String? name;

  const Keyword({
    this.id,
    this.name,
  });

  @override
  List<Object?> get props => [id, name];
}

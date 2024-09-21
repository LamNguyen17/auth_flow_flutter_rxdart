import 'package:auth_flow_flutter_rxdart/domain/entities/movie/genre_movie_list.dart';
import 'package:json_annotation/json_annotation.dart';

part 'genre_movie_list_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GenreMovieListResponse {
  final int? id;
  final String? name;

  GenreMovieListResponse({this.id, this.name});

  factory GenreMovieListResponse.fromJson(Map<String, dynamic> json) =>
      _$GenreMovieListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GenreMovieListResponseToJson(this);

  GenreMovieList toEntity() {
    return GenreMovieList(id: id, name: name);
  }
}

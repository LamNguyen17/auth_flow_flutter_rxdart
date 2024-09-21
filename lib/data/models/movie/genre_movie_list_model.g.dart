// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'genre_movie_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenreMovieListResponse _$GenreMovieListResponseFromJson(
        Map<String, dynamic> json) =>
    GenreMovieListResponse(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$GenreMovieListResponseToJson(
        GenreMovieListResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

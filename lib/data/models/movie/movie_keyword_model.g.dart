// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_keyword_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieKeywordResponse _$MovieKeywordResponseFromJson(
        Map<String, dynamic> json) =>
    MovieKeywordResponse(
      id: (json['id'] as num?)?.toInt(),
      keywords: (json['keywords'] as List<dynamic>?)
          ?.map((e) => KeywordResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MovieKeywordResponseToJson(
        MovieKeywordResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'keywords': instance.keywords?.map((e) => e.toJson()).toList(),
    };

KeywordResponse _$KeywordResponseFromJson(Map<String, dynamic> json) =>
    KeywordResponse(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$KeywordResponseToJson(KeywordResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

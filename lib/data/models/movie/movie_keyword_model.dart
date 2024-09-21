import 'package:json_annotation/json_annotation.dart';

import 'package:auth_flow_flutter_rxdart/domain/entities/movie/movie_keyword.dart';

part 'movie_keyword_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MovieKeywordResponse {
  final int? id;
  final List<KeywordResponse>? keywords;

  MovieKeywordResponse({this.id, this.keywords});

  factory MovieKeywordResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieKeywordResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MovieKeywordResponseToJson(this);

  MovieKeyword toEntity() {
    return MovieKeyword(
      id: id,
      keywords: keywords?.map((x) => x.toEntity()).toList(),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class KeywordResponse {
  final int? id;
  final String? name;

  KeywordResponse({this.id, this.name});

  factory KeywordResponse.fromJson(Map<String, dynamic> json) =>
      _$KeywordResponseFromJson(json);

  Map<String, dynamic> toJson() => _$KeywordResponseToJson(this);

  Keyword toEntity() {
    return Keyword(
      id: id,
      name: name,
    );
  }
}
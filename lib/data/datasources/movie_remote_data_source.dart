import 'package:auth_flow_flutter_rxdart/common/extensions/failure.dart';
import 'package:auth_flow_flutter_rxdart/data/config/app_config.dart';
import 'package:auth_flow_flutter_rxdart/data/gateway/api_gateway.dart';
import 'package:auth_flow_flutter_rxdart/data/models/movie/genre_movie_list_model.dart';
import 'package:auth_flow_flutter_rxdart/data/models/movie/movie_list_model.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/movie/request/request_movie_list.dart';
import 'package:dio/dio.dart';

abstract class MovieRemoteDataSource {
  Stream<GenreMovieListResponse> genreMovieList(String type);

  Stream<MovieListResponse> getMovieList(RequestMovieList request);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final ApiGateway _apiGateway;

  MovieRemoteDataSourceImpl(this._apiGateway);

  /// Get genre movie list
  /// type = movie or tv
  @override
  Stream<GenreMovieListResponse> genreMovieList(String type) async* {
    final response = await _apiGateway.dio.get("/genre/$type/list");
    if (response.statusCode == 200) {
      yield GenreMovieListResponse.fromJson(response.data);
    } else {
      throw const ServerFailure('');
    }
  }

  /// Get movie list
  /// type = popular, top_rated, now_playing, upcoming
  @override
  Stream<MovieListResponse> getMovieList(RequestMovieList request) async* {
    final response = await _apiGateway.dio.get("/movie/${request.type}?page=${request.page}&api_key=${AppConfig.apiKey}");
    if (response.statusCode == 200) {
      yield MovieListResponse.fromJson(response.data);
    } else {
      throw const ServerFailure('');
    }
  }
}

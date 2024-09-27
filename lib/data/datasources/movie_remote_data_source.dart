import 'package:auth_flow_flutter_rxdart/common/extensions/failure.dart';
import 'package:auth_flow_flutter_rxdart/data/config/app_config.dart';
import 'package:auth_flow_flutter_rxdart/data/gateway/api_gateway.dart';
import 'package:auth_flow_flutter_rxdart/data/models/movie/genre_movie_list_model.dart';
import 'package:auth_flow_flutter_rxdart/data/models/movie/movie_keyword_model.dart';
import 'package:auth_flow_flutter_rxdart/data/models/movie/movie_list_model.dart';
import 'package:auth_flow_flutter_rxdart/domain/usecases/movie/request/request_movie_list.dart';

abstract class MovieRemoteDataSource {
  Future<List<GenreMovieListResponse>> getGenreMovieList(String type);

  Future<MovieItemResponse> getMovieDetail(int id);

  Future<MovieKeywordResponse> getMovieKeywords(int id);

  Future<MovieListResponse> getMovieSimilar(int id);

  Future<MovieListResponse> getMovieRecommendation(int id);

  Stream<MovieListResponse> getMovieList(RequestMovieList request);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final ApiGateway _apiGateway;

  MovieRemoteDataSourceImpl(this._apiGateway);

  /// Get genre movie list
  /// type = movie or tv
  @override
  Future<List<GenreMovieListResponse>> getGenreMovieList(String type) async {
    final apiKey = await AppConfig.apiKey();
    final response = await _apiGateway.dio
        .get("/genre/$type/list?api_key=$apiKey");
    if (response.statusCode == 200) {
      final result = response.data?['genres'] as List<dynamic>;
      return result.map((e) => GenreMovieListResponse.fromJson(e)).toList();
    } else {
      throw const ServerFailure('');
    }
  }

  /// Get movie list
  /// type = popular, top_rated, now_playing, upcoming
  @override
  Stream<MovieListResponse> getMovieList(RequestMovieList request) async* {
    final apiKey = await AppConfig.apiKey();
    final response = await _apiGateway.dio.get(
        "/movie/${request.type}?page=${request.page}&api_key=$apiKey");
    if (response.statusCode == 200) {
      print('getPopular_1: ${response.data}');
      yield MovieListResponse.fromJson(response.data);
    } else {
      throw const ServerFailure('');
    }
  }

  /// Get movie detail
  /// id = movie id
  @override
  Future<MovieItemResponse> getMovieDetail(int id) async {
    final apiKey = await AppConfig.apiKey();
    final response =
        await _apiGateway.dio.get("/movie/$id?api_key=$apiKey");
    if (response.statusCode == 200) {
      return MovieItemResponse.fromJson(response.data);
    } else {
      throw const ServerFailure('');
    }
  }

  @override
  Future<MovieKeywordResponse> getMovieKeywords(int id) async {
    final apiKey = await AppConfig.apiKey();
    final response =
    await _apiGateway.dio.get("/movie/$id/keywords?api_key=$apiKey");
    if (response.statusCode == 200) {
      return MovieKeywordResponse.fromJson(response.data);
    } else {
      throw const ServerFailure('');
    }
  }

  @override
  Future<MovieListResponse> getMovieRecommendation(int id) async {
    final apiKey = await AppConfig.apiKey();
    final response =
    await _apiGateway.dio.get("/movie/$id/recommendations?api_key=$apiKey");
    if (response.statusCode == 200) {
      return MovieListResponse.fromJson(response.data);
    } else {
      throw const ServerFailure('');
    }
  }

  @override
  Future<MovieListResponse> getMovieSimilar(int id) async {
    final apiKey = await AppConfig.apiKey();
    final response =
    await _apiGateway.dio.get("/movie/$id/similar?api_key=$apiKey");
    if (response.statusCode == 200) {
      return MovieListResponse.fromJson(response.data);
    } else {
      throw const ServerFailure('');
    }
  }
}

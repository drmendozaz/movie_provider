import 'package:movie_provider/data/api_config.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:movie_provider/data/models/movie_list_response.dart';

abstract class MovieRemoteDataSource {
  Future<MovieListResponse> getPopularMovies({required int page});
  Future<MovieListResponse> getNowPlayingMovies({required int page});
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final Client client;

  MovieRemoteDataSourceImpl({required this.client});

  @override
  Future<MovieListResponse> getPopularMovies({required int page}) async {
    try {
      final uri = Uri.parse(ApiConfig.popularMovies(page));
      final response = await client.get(uri);
      if (response.statusCode == 200) {
        return MovieListResponse.fromJsonMap(json.decode(response.body));
      } else {
        throw ClientException('Failed to fetch movies', uri);
      }
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<MovieListResponse> getNowPlayingMovies({required int page}) async {
    try {
      final uri = Uri.parse(ApiConfig.nowPlayingMovies(page));
      final response = await client.get(uri);
      if (response.statusCode == 200) {
        return MovieListResponse.fromJsonMap(json.decode(response.body));
      } else {
        throw ClientException('Failed to fetch movies', uri);
      }
    } catch (_) {
      rethrow;
    }
  }
}

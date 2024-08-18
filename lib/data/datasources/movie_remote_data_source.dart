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
    final response = await client.get(Uri.parse(ApiConfig.popularMovies(page)));

    if (response.statusCode == 200) {
      return MovieListResponse.fromJsonMap(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch movies');
    }
  }

  @override
  Future<MovieListResponse> getNowPlayingMovies({required int page}) async {
    final response =
        await client.get(Uri.parse(ApiConfig.nowPlayingMovies(page)));

    if (response.statusCode == 200) {
      return MovieListResponse.fromJsonMap(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch movies');
    }
  }
}

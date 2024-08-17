import 'package:flutter_application_1/data/models/movie_model.dart';
import 'package:flutter_application_1/domain/entities/movie_list.dart';

class MovieListResponse {
  int page;
  List<MovieModel> movies;
  int totalPages;
  int totalResults;
  MovieListResponse({
    required this.page,
    required this.movies,
    required this.totalPages,
    required this.totalResults,
  });

  factory MovieListResponse.fromJsonMap(Map<String, dynamic> map) {
    return MovieListResponse(
      page: map['page'] as int,
      movies: List<MovieModel>.from(
          map['results'].map((e) => MovieModel.fromJsonMap(e))),
      totalPages: map['total_pages'] as int,
      totalResults: map['total_results'] as int,
    );
  }

  MovieListEntity toEntity() => MovieListEntity(
        movies: movies.map((e) => e.toEntity()).toList(),
        page: page,
        totalPages: totalPages,
        totalResults: totalResults,
      );
}

import 'dart:convert';

import 'package:movie_provider/domain/entities/movie.dart';

class MovieModel {
  int id;
  String title;
  String? posterPath;
  String? backdropPath;
  String overview;
  String releaseDate;
  double voteAverage;
  List<int> genreIds;
  MovieModel({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.backdropPath,
    required this.overview,
    required this.releaseDate,
    required this.voteAverage,
    required this.genreIds,
  });

  factory MovieModel.fromJsonMap(Map<String, dynamic> map) {
    return MovieModel(
      id: map['id'] as int,
      title: map['title'] ?? '',
      posterPath: map['poster_path'] ?? '',
      backdropPath: map['backdrop_path'] ?? '',
      overview: map['overview'] ?? '',
      releaseDate: map['release_date'] ?? '',
      voteAverage: map['vote_average']?.toDouble() ?? 0.0,
      genreIds: List<int>.from(map['genre_ids']),
    );
  }

  factory MovieModel.fromJson(String source) =>
      MovieModel.fromJsonMap(json.decode(source));

  Movie toEntity() => Movie(
        backdropPath: backdropPath,
        genreIds: genreIds,
        id: id,
        overview: overview,
        posterPath: posterPath,
        releaseDate: releaseDate,
        title: title,
        voteAverage: voteAverage,
      );
}

import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Movie extends Equatable {
  final int id;
  final String? backdropPath;
  final List<int>? genreIds;
  final String? overview;
  final String? posterPath;
  final String? releaseDate;
  final String? title;
  final double? voteAverage;
  final int? voteCount;
  bool saved = false;

  Movie({
    required this.id,
    this.backdropPath,
    this.genreIds,
    this.overview,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.voteAverage,
    this.voteCount,
  });

  @override
  List<Object?> get props => [
        id,
        backdropPath,
        genreIds,
        overview,
        posterPath,
        releaseDate,
        title,
        voteAverage,
        voteCount,
      ];
}

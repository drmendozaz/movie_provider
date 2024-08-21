import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';
import 'package:movie_provider/domain/entities/movie.dart';

part 'movie_collection.g.dart';

@collection
class MovieCollection extends Equatable {
  final Id id;
  final bool? adult;
  final String? backdropPath;
  final List<int>? genreIds;
  final String? originalLanguage;
  final String? originalTitle;
  final String? overview;
  final double? popularity;
  final String? posterPath;
  final String? releaseDate;
  final String? title;
  final bool? video;
  final double? voteAverage;
  final int? voteCount;

  const MovieCollection({
    required this.id,
    this.adult,
    this.backdropPath,
    this.genreIds,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
  });

  Movie toEntity() {
    return Movie(
      backdropPath: backdropPath,
      genreIds: genreIds,
      id: id,
      overview: overview,
      posterPath: posterPath,
      releaseDate: releaseDate,
      title: title,
      voteAverage: voteAverage,
      voteCount: voteCount,
    );
  }

  MovieCollection fromEntity(Movie model) {
    return MovieCollection(
      backdropPath: model.backdropPath,
      genreIds: model.genreIds,
      id: model.id,
      overview: model.overview,
      posterPath: model.posterPath,
      releaseDate: model.releaseDate,
      title: model.title,
      voteAverage: model.voteAverage,
      voteCount: model.voteCount,
    );
  }

  @override
  List<Object?> get props => [id, title];
}

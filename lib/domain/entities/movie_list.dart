import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/domain/entities/movie.dart';

class MovieListEntity extends Equatable {
  final int? page;
  final List<Movie>? movies;
  final int? totalPages;
  final int? totalResults;

  const MovieListEntity({
    this.page,
    this.movies,
    this.totalPages,
    this.totalResults,
  });

  @override
  List<Object?> get props => [page, movies, totalPages, totalResults];
}
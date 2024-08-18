import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/domain/entities/movie.dart';

sealed class PopularMoviesState extends Equatable {
  const PopularMoviesState();
  const factory PopularMoviesState.initial() = InitialPopularMoviesState;
  const factory PopularMoviesState.loading() = LoadingPopularMoviesState;
  const factory PopularMoviesState.success({required List<Movie> movies}) =
      SuccessPopularMoviesState;
  const factory PopularMoviesState.noResults({required String message}) =
      NoResultsPopularMoviesState;

  @override
  List<Object> get props => [];
}

final class InitialPopularMoviesState extends PopularMoviesState {
  const InitialPopularMoviesState();
}

final class LoadingPopularMoviesState extends PopularMoviesState {
  const LoadingPopularMoviesState();
}

final class SuccessPopularMoviesState extends PopularMoviesState {
  const SuccessPopularMoviesState({required this.movies});

  final List<Movie> movies;

  @override
  List<Object> get props => [movies];
}

final class NoResultsPopularMoviesState extends PopularMoviesState {
  const NoResultsPopularMoviesState({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}

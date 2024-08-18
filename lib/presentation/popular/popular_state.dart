import 'package:flutter_application_1/domain/entities/movie.dart';

sealed class PopularMoviesState {
  const factory PopularMoviesState.initial() = InitialPopularMoviesState;
  const factory PopularMoviesState.loading() = LoadingPopularMoviesState;
  const factory PopularMoviesState.success({required List<Movie> movies}) =
      SuccessPopularMoviesState;
  const factory PopularMoviesState.noResults({required String message}) =
      NoResultsPopularMoviesState;
}

final class InitialPopularMoviesState implements PopularMoviesState {
  const InitialPopularMoviesState();
}

final class LoadingPopularMoviesState implements PopularMoviesState {
  const LoadingPopularMoviesState();
}

final class SuccessPopularMoviesState implements PopularMoviesState {
  const SuccessPopularMoviesState({required this.movies});

  final List<Movie> movies;
}

final class NoResultsPopularMoviesState implements PopularMoviesState {
  const NoResultsPopularMoviesState({required this.message});

  final String message;
}

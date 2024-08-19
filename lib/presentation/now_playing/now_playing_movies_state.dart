import 'package:equatable/equatable.dart';
import 'package:movie_provider/domain/entities/movie.dart';

sealed class NowPlayingMoviesState extends Equatable {
  const NowPlayingMoviesState();
  const factory NowPlayingMoviesState.initial() = InitialNowPlayingMoviesState;
  const factory NowPlayingMoviesState.loading() = LoadingNowPlayingMoviesState;
  const factory NowPlayingMoviesState.success({required List<Movie> movies}) =
      SuccessNowPlayingMoviesState;
  const factory NowPlayingMoviesState.noResults({required String message}) =
      NoResultsNowPlayingMoviesState;

  @override
  List<Object> get props => [];
}

final class InitialNowPlayingMoviesState extends NowPlayingMoviesState {
  const InitialNowPlayingMoviesState();
}

final class LoadingNowPlayingMoviesState extends NowPlayingMoviesState {
  const LoadingNowPlayingMoviesState();
}

final class SuccessNowPlayingMoviesState extends NowPlayingMoviesState {
  const SuccessNowPlayingMoviesState({required this.movies});

  final List<Movie> movies;

  @override
  List<Object> get props => [movies];
}

final class NoResultsNowPlayingMoviesState extends NowPlayingMoviesState {
  const NoResultsNowPlayingMoviesState({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}

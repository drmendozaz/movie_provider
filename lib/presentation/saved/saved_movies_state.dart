import 'package:equatable/equatable.dart';
import 'package:movie_provider/domain/entities/movie.dart';

sealed class SavedMoviesState extends Equatable {
  const SavedMoviesState();
  const factory SavedMoviesState.initial() = InitialSavedMoviesState;
  const factory SavedMoviesState.loading() = LoadingSavedMoviesState;
  const factory SavedMoviesState.success(
      {required Stream<List<Movie>> movies}) = SuccessSavedMoviesState;
  const factory SavedMoviesState.noResults({required String message}) =
      NoResultsSavedMoviesState;

  @override
  List<Object> get props => [];
}

final class InitialSavedMoviesState extends SavedMoviesState {
  const InitialSavedMoviesState();
}

final class LoadingSavedMoviesState extends SavedMoviesState {
  const LoadingSavedMoviesState();
}

final class SuccessSavedMoviesState extends SavedMoviesState {
  const SuccessSavedMoviesState({required this.movies});

  final Stream<List<Movie>> movies;

  @override
  List<Object> get props => [movies];
}

final class NoResultsSavedMoviesState extends SavedMoviesState {
  const NoResultsSavedMoviesState({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}

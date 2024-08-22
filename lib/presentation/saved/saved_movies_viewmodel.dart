import 'package:movie_provider/core/viewmodel.dart';
import 'package:movie_provider/domain/usecases/movie_usecases.dart';
import 'package:movie_provider/presentation/saved/saved_movies_state.dart';

class SavedMoviesViewModel extends ViewModel<SavedMoviesState> {
  SavedMoviesViewModel(this._movieUseCases)
      : super(const SavedMoviesState.initial());

  final MovieUseCases _movieUseCases;

  Future<void> getSavedMovies() async {
    try {
      if (state is! SuccessSavedMoviesState) {
        setState(const SavedMoviesState.loading());
      }

      final result = await _movieUseCases.streamSavedMovies();

      result.fold(
        (error) => setState(SavedMoviesState.noResults(message: error.message)),
        (success) => setState(SavedMoviesState.success(movies: success)),
      );
    } catch (_) {
      rethrow;
    }
  }
}

import 'package:movie_provider/core/viewmodel.dart';
import 'package:movie_provider/domain/entities/movie.dart';
import 'package:movie_provider/domain/usecases/movie_usecases.dart';
import 'package:movie_provider/presentation/popular/popular_state.dart';

class PopularMoviesViewModel extends ViewModel<PopularMoviesState> {
  PopularMoviesViewModel(this._movieUsecases)
      : super(const PopularMoviesState.initial());

  final MovieUsecases _movieUsecases;
  final List<Movie> _movieList = [];
  int _page = 1;
  bool hasReachedMax = false;

  Future<void> getPopularMovies() async {
    try {
      if (hasReachedMax) return;

      if (state is! SuccessPopularMoviesState) {
        setState(const PopularMoviesState.loading());
      }

      final result = await _movieUsecases.getPopularMovies(page: _page);

      result.fold(
        (error) =>
            setState(PopularMoviesState.noResults(message: error.message)),
        (success) {
          _page++;
          _movieList.addAll(success.movies
                  ?.where((movie) => _movieList.contains(movie) == false) ??
              []);

          if ((success.movies?.length ?? 0) < 20) {
            hasReachedMax = true;
          }

          setState(PopularMoviesState.success(movies: List.of(_movieList)));
        },
      );
    } catch (_) {
      rethrow;
    }
  }
}

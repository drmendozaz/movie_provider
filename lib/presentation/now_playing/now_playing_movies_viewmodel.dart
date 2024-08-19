import 'package:movie_provider/core/viewmodel.dart';
import 'package:movie_provider/domain/entities/movie.dart';
import 'package:movie_provider/domain/usecases/movie_usecases.dart';
import 'package:movie_provider/presentation/now_playing/now_playing_movies_state.dart';

class NowPlayingMoviesViewModel extends ViewModel<NowPlayingMoviesState> {
  NowPlayingMoviesViewModel(this._movieUsecases)
      : super(const NowPlayingMoviesState.initial());

  final MovieUsecases _movieUsecases;
  final List<Movie> _movieList = [];
  int _page = 1;
  bool hasReachedMax = false;

  Future<void> getNowPlayingMovies() async {
    try {
      if (hasReachedMax) return;

      if (state is! SuccessNowPlayingMoviesState) {
        setState(const NowPlayingMoviesState.loading());
      }

      final result = await _movieUsecases.getNowPlayingMovies(page: _page);

      result.fold(
        (error) =>
            setState(NowPlayingMoviesState.noResults(message: error.message)),
        (success) {
          _page++;
          _movieList.addAll(success.movies
                  ?.where((movie) => _movieList.contains(movie) == false) ??
              []);

          if ((success.movies?.length ?? 0) < 20) {
            hasReachedMax = true;
          }

          setState(NowPlayingMoviesState.success(movies: List.of(_movieList)));
        },
      );
    } catch (_) {
      rethrow;
    }
  }
}

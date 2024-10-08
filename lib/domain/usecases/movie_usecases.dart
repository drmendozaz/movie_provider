import 'package:movie_provider/core/failure.dart';
import 'package:movie_provider/domain/entities/movie.dart';
import 'package:movie_provider/domain/entities/movie_list.dart';
import 'package:movie_provider/domain/repositories/movie_repository.dart';
import 'package:fpdart/fpdart.dart';

class MovieUseCases {
  final MovieRepository _movieRepository;

  const MovieUseCases(this._movieRepository);

  Future<Either<Failure, MovieListEntity>> getPopularMovies(
      {required int page}) async {
    return _movieRepository.getPopularMovies(page: page);
  }

  Future<Either<Failure, MovieListEntity>> getNowPlayingMovies(
      {required int page}) async {
    return _movieRepository.getNowPlayingMovies(page: page);
  }

  Future<Either<Failure, List<Movie>>> getSavedMovies() async {
    return _movieRepository.getSavedMovies();
  }

  Future<Either<Failure, Stream<List<Movie>>>> streamSavedMovies() async {
    return _movieRepository.streamSavedMovies();
  }

  Future<bool> isSavedMovie(int id) async {
    var saved = await _movieRepository.isSavedMovie(movieId: id);
    return saved.getOrElse((_) => false);
  }

  Future<Either<Failure, void>> toggleBookmark(
      {required Movie movieEntity}) async {
    final isSaved =
        await _movieRepository.isSavedMovie(movieId: movieEntity.id);

    return isSaved.fold(
      (error) {
        return Left(error);
      },
      (isSaved) {
        if (isSaved) {
          return _movieRepository.deleteMovie(movieId: movieEntity.id);
        } else {
          return _movieRepository.saveMovie(movieEntity: movieEntity);
        }
      },
    );
  }
}

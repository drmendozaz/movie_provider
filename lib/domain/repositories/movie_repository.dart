import 'package:movie_provider/core/failure.dart';
import 'package:movie_provider/domain/entities/movie.dart';
import 'package:movie_provider/domain/entities/movie_list.dart';
import 'package:fpdart/fpdart.dart';

abstract class MovieRepository {
  //* Remote Data Source
  Future<Either<Failure, MovieListEntity>> getPopularMovies(
      {required int page});
  Future<Either<Failure, MovieListEntity>> getNowPlayingMovies(
      {required int page});

  //* Local Data Source
  Future<Either<Failure, List<Movie>>> getSavedMovies();
  Future<Either<Failure, void>> saveMovie({required Movie movieDetailEntity});
  Future<Either<Failure, void>> deleteMovie({required int movieId});
  Future<Either<Failure, bool>> isSavedMovie({required int movieId});
}

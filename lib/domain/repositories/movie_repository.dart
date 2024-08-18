import 'package:movie_provider/core/failure.dart';
import 'package:movie_provider/domain/entities/movie_list.dart';
import 'package:fpdart/fpdart.dart';

abstract class MovieRepository {
  Future<Either<Failure, MovieListEntity>> getPopularMovies(
      {required int page});
  Future<Either<Failure, MovieListEntity>> getNowPlayingMovies(
      {required int page});
}

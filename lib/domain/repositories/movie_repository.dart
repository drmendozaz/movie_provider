import 'package:flutter_application_1/core/failure.dart';
import 'package:flutter_application_1/data/models/movie_list_response.dart';
import 'package:fpdart/fpdart.dart';

abstract class MovieRepository {
  Future<Either<Failure, MovieListResponse>> getPopularMovies({required int page});
  Future<Either<Failure, MovieListResponse>> getNowPlayingMovies({required int page});

}
import 'package:fpdart/fpdart.dart';

import 'package:movie_provider/core/failure.dart';
import 'package:movie_provider/data/datasources/movie_remote_data_source.dart';
import 'package:movie_provider/domain/entities/movie_list.dart';
import 'package:movie_provider/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource _movieRemoteDataSource;

  MovieRepositoryImpl(this._movieRemoteDataSource);

  @override
  Future<Either<Failure, MovieListEntity>> getPopularMovies(
      {required int page}) async {
    try {
      final result = await _movieRemoteDataSource.getPopularMovies(page: page);
      return Right(result.toEntity());
    } on Exception {
      return const Left(ServerFailure('Server error'));
    }
  }

  @override
  Future<Either<Failure, MovieListEntity>> getNowPlayingMovies(
      {required int page}) async {
    try {
      final result =
          await _movieRemoteDataSource.getNowPlayingMovies(page: page);
      return Right(result.toEntity());
    } on Exception {
      return const Left(ServerFailure('Server error'));
    }
  }
}

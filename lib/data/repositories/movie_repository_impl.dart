import 'package:fpdart/fpdart.dart';

import 'package:flutter_application_1/core/failure.dart';
import 'package:flutter_application_1/data/datasources/movie_remote_data_source.dart';
import 'package:flutter_application_1/domain/entities/movie_list.dart';
import 'package:flutter_application_1/domain/repositories/movie_repository.dart';

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

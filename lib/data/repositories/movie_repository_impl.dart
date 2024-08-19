import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart';
import 'package:isar/isar.dart';

import 'package:movie_provider/core/failure.dart';
import 'package:movie_provider/data/datasources/movie_collection.dart';
import 'package:movie_provider/data/datasources/movie_local_data_source.dart';
import 'package:movie_provider/data/datasources/movie_remote_data_source.dart';
import 'package:movie_provider/domain/entities/movie.dart';
import 'package:movie_provider/domain/entities/movie_list.dart';
import 'package:movie_provider/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource _movieRemoteDataSource;
  final MovieLocalDataSource _movieLocalDataSource;

  MovieRepositoryImpl(this._movieRemoteDataSource, this._movieLocalDataSource);

  @override
  Future<Either<Failure, MovieListEntity>> getPopularMovies(
      {required int page}) async {
    try {
      final result = await _movieRemoteDataSource.getPopularMovies(page: page);
      return Right(result.toEntity());
    } on ClientException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, MovieListEntity>> getNowPlayingMovies(
      {required int page}) async {
    try {
      final result =
          await _movieRemoteDataSource.getNowPlayingMovies(page: page);
      return Right(result.toEntity());
    } on ClientException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMovie({required int movieId}) async {
    try {
      final result = await _movieLocalDataSource.deleteMovie(movieId: movieId);

      return Right(result);
    } on IsarError catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getSavedMovies() async {
    try {
      final result = await _movieLocalDataSource.getSavedMovie();

      return Right(result.map((e) => e.toEntity()).toList());
    } on IsarError catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> isSavedMovie({required int movieId}) async {
    try {
      final result = await _movieLocalDataSource.isSavedMovie(movieId: movieId);

      return Right(result);
    } on IsarError catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> saveMovie(
      {required Movie movieDetailEntity}) async {
    try {
      final result = await _movieLocalDataSource.saveMovie(
        movieCollection: MovieCollection(id: 1).fromEntity(movieDetailEntity),
      );

      return Right(result);
    } on IsarError catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}

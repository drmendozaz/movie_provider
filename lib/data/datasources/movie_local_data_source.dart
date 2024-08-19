import 'package:isar/isar.dart';
import 'package:movie_provider/core/database.dart';
import 'package:movie_provider/data/datasources/movie_collection.dart';

abstract class MovieLocalDataSource {
  /// Saves the [movieCollection] to the local data source.
  Future<void> saveMovie({required MovieCollection movieCollection});

  /// Deletes the movie with the given [movieId] from the local data source.
  Future<void> deleteMovie({required int movieId});

  /// Returns a boolean indicating whether the movie with the given [movieId] is saved in the local data source.
  Future<bool> isSavedMovie({required int movieId});

  /// Returns a list of all saved movie from the local data source.
  Future<List<MovieCollection>> getSavedMovie();
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  MovieLocalDataSourceImpl(this.localDatabase);

  final LocalDatabase localDatabase;

  /// Deletes the movie with the given [movieId] from the local database.
  @override
  Future<void> deleteMovie({required int movieId}) async {
    try {
      final db = localDatabase.db;
      await db.writeTxn(() async =>
          db.movieCollections.filter().idEqualTo(movieId).deleteAll());
    } catch (_) {
      rethrow;
    }
  }

  /// Retrieves all saved movie from the local database.
  @override
  Future<List<MovieCollection>> getSavedMovie() async {
    try {
      final list = await localDatabase.db.movieCollections.where().findAll();

      return list;
    } catch (_) {
      rethrow;
    }
  }

  /// Saves the given [movieCollection] to the local database.
  @override
  Future<void> saveMovie({required MovieCollection movieCollection}) async {
    try {
      final db = localDatabase.db;

      await db.writeTxn(() async => db.movieCollections.put(movieCollection));
    } catch (_) {
      rethrow;
    }
  }

  /// Checks if the movie with the given [movieId] is saved in the local database.
  @override
  Future<bool> isSavedMovie({required int movieId}) async {
    try {
      final db = localDatabase.db;
      final isSaved =
          await db.movieCollections.filter().idEqualTo(movieId).isNotEmpty();

      return isSaved;
    } catch (_) {
      rethrow;
    }
  }
}

import 'package:isar/isar.dart';
import 'package:movie_provider/data/datasources/movie_collection.dart';

/// A class representing a local database.
///
/// This class provides methods to initialize and access the Isar database.
class LocalDatabase {
  late final Isar _isar;
  bool _isInitialized = false;

  /// Returns the initialized Isar database instance.
  ///
  /// Throws an [IsarError] if the database has not been initialized.
  Isar get db => _isInitialized
      ? _isar
      : throw IsarError('Isar has not been initialized.');

  /// Initializes the Isar database.
  ///
  /// Throws an [IsarError] if the database has already been initialized.
  Future<void> initialize({required String directory}) async {
    if (_isInitialized) throw IsarError('Isar has already been initialized.');

    _isar = await Isar.open([MovieCollectionSchema], directory: directory);

    _isInitialized = true;
  }
}

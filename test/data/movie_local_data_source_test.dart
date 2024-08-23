import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:movie_provider/core/database.dart';
import 'package:movie_provider/data/datasources/movie_collection.dart';
import 'package:movie_provider/data/datasources/movie_local_data_source.dart';

void main() {
  late final LocalDatabase testDatabase;
  late final MovieLocalDataSource dataSource;
  const tId = 1;
  const tMovie = MovieCollection(id: tId);

  setUpAll(() async {
    testDatabase = LocalDatabase();
    await Isar.initializeIsarCore(download: true);
    await testDatabase.initialize(directory: '');
    await testDatabase.db.writeTxn(() async {
      await testDatabase.db.movieCollections.clear();
    });
    dataSource = MovieLocalDataSourceImpl(testDatabase);
  });

  tearDownAll(() async {
    await testDatabase.db.close();
  });

  setUp(() {});

  test(
    'save movie should store movie in db',
    () async {
      await dataSource.saveMovie(movieCollection: tMovie);
      final found = await testDatabase.db.movieCollections.get(tId);
      expect(tMovie, equals(found));
    },
  );

  test(
    'get saved movie should return a list of movies',
    () async {
      final result = await dataSource.getSavedMovies();
      expect(result, isA<List<MovieCollection>>());
    },
  );

  test(
    'stream saved movies should return a stream of list of movies',
    () async {
      final result = dataSource.streamSavedMovies();
      expect(result, isA<Stream<List<MovieCollection>>>());
    },
  );

  test(
    'delete movie should erase movie from db',
    () async {
      await testDatabase.db
          .writeTxn(() => testDatabase.db.movieCollections.put(tMovie));
      await dataSource.deleteMovie(movieId: tId);
      final found = await testDatabase.db.movieCollections.get(tId);
      expect(found, isNull);
    },
  );

  test(
    'find movie by id should return true when data is found',
    () async {
      await testDatabase.db
          .writeTxn(() => testDatabase.db.movieCollections.put(tMovie));
      final result = await dataSource.isSavedMovie(movieId: tId);

      expect(result, equals(true));
    },
  );
}

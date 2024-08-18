import 'package:movie_provider/data/datasources/movie_remote_data_source.dart';
import 'package:movie_provider/data/repositories/movie_repository_impl.dart';
import 'package:movie_provider/domain/repositories/movie_repository.dart';
import 'package:movie_provider/domain/usecases/movie_usecases.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

final locator = GetIt.instance;

void init() {
  // use case
  locator.registerLazySingleton(() => MovieUsecases(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(locator()),
  );

  // data source
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));

  // http
  locator.registerLazySingleton(() => Client());
}

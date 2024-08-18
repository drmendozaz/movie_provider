import 'package:movie_provider/core/failure.dart';
import 'package:movie_provider/data/datasources/movie_remote_data_source.dart';
import 'package:movie_provider/data/models/movie_list_response.dart';
import 'package:movie_provider/data/repositories/movie_repository_impl.dart';
import 'package:movie_provider/domain/entities/movie_list.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieRemoteDataSource extends Mock implements MovieRemoteDataSource {}

void main() {
  late MockMovieRemoteDataSource mockRemoteDataSource;
  late MovieRepositoryImpl repository;

  final movieListResponse =
      MovieListResponse(page: 1, movies: [], totalPages: 1, totalResults: 1);

  setUp(() {
    mockRemoteDataSource = MockMovieRemoteDataSource();
    repository = MovieRepositoryImpl(mockRemoteDataSource);

    when(() => mockRemoteDataSource.getPopularMovies(page: 1))
        .thenAnswer((_) async => movieListResponse);

    when(() => mockRemoteDataSource.getNowPlayingMovies(page: 1))
        .thenAnswer((_) async => movieListResponse);
  });

  group('Get popular movies', () {
    test(
      'should return movie list when a call to data source is successful',
      () async {
        final result = await repository.getPopularMovies(page: 1);

        verify(() => mockRemoteDataSource.getPopularMovies(page: 1));

        final resultList = result.getOrElse((_) => const MovieListEntity());
        expect(resultList, equals(movieListResponse.toEntity()));
      },
    );
  });

  group('Get now playing movies', () {
    test(
      'should return movie list when a call to data source is successful',
      () async {
        final result = await repository.getNowPlayingMovies(page: 1);

        verify(() => mockRemoteDataSource.getNowPlayingMovies(page: 1));

        final resultList =
            result.getOrElse((failure) => const MovieListEntity());
        expect(resultList, equals(movieListResponse.toEntity()));
      },
    );

    test(
      'should return server failure when a call to data source is unsuccessful',
      () async {
        when(() => mockRemoteDataSource.getNowPlayingMovies(page: 1))
            .thenThrow(Exception(''));

        final result = await repository.getNowPlayingMovies(page: 1);

        verify(() => mockRemoteDataSource.getNowPlayingMovies(page: 1));
        expect(
            result,
            equals(const Left<Failure, MovieListEntity>(
                ServerFailure('Server error'))));
      },
    );
  });
}

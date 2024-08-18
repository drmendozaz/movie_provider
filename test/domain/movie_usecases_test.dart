import 'package:movie_provider/domain/entities/movie_list.dart';
import 'package:movie_provider/domain/repositories/movie_repository.dart';
import 'package:movie_provider/domain/usecases/movie_usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late final MovieRepository mockMovieRepository = MockMovieRepository();
  late final MovieUsecases movieUseCases = MovieUsecases(mockMovieRepository);

  const tMovies = MovieListEntity();

  setUp(() async {
    when(() => mockMovieRepository.getPopularMovies(page: 1))
        .thenAnswer((_) async => const Right(tMovies));
    when(() => mockMovieRepository.getNowPlayingMovies(page: 1))
        .thenAnswer((_) async => const Right(tMovies));
  });

  test('Fetches now playing movies', () async {
    final response = await movieUseCases.getNowPlayingMovies(page: 1);

    expect(response, equals(const Right(tMovies)));
    verify(() => mockMovieRepository.getNowPlayingMovies(page: 1));
    verifyNoMoreInteractions(mockMovieRepository);
  });

  test('Fetches popular movies', () async {
    final response = await movieUseCases.getPopularMovies(page: 1);

    expect(response, equals(const Right(tMovies)));
    verify(() => mockMovieRepository.getPopularMovies(page: 1));
    verifyNoMoreInteractions(mockMovieRepository);
  });
}

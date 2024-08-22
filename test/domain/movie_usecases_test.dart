import 'package:movie_provider/domain/entities/movie.dart';
import 'package:movie_provider/domain/entities/movie_list.dart';
import 'package:movie_provider/domain/repositories/movie_repository.dart';
import 'package:movie_provider/domain/usecases/movie_usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late final MovieRepository mockMovieRepository = MockMovieRepository();
  late final MovieUseCases movieUseCases = MovieUseCases(mockMovieRepository);

  const tMovies = MovieListEntity();

  setUp(() async {});

  test('Fetches now playing movies', () async {
    when(() => mockMovieRepository.getNowPlayingMovies(page: 1))
        .thenAnswer((_) async => const Right(tMovies));

    final response = await movieUseCases.getNowPlayingMovies(page: 1);

    expect(response, equals(const Right(tMovies)));
    verify(() => mockMovieRepository.getNowPlayingMovies(page: 1));
    verifyNoMoreInteractions(mockMovieRepository);
  });

  test('Fetches popular movies', () async {
    when(() => mockMovieRepository.getPopularMovies(page: 1))
        .thenAnswer((_) async => const Right(tMovies));

    final response = await movieUseCases.getPopularMovies(page: 1);

    expect(response, equals(const Right(tMovies)));
    verify(() => mockMovieRepository.getPopularMovies(page: 1));
    verifyNoMoreInteractions(mockMovieRepository);
  });

  test('Fetches saved movies', () async {
    when(() => mockMovieRepository.getSavedMovies())
        .thenAnswer((_) async => const Right(<Movie>[]));

    final response = await movieUseCases.getSavedMovies();

    expect(response, equals(const Right(<Movie>[])));
    verify(() => mockMovieRepository.getSavedMovies());
    verifyNoMoreInteractions(mockMovieRepository);
  });

  test('Returns true if a movie is saved', () async {
    when(() => mockMovieRepository.isSavedMovie(movieId: 1))
        .thenAnswer((_) async => const Right(true));

    final response = await movieUseCases.isSavedMovie(1);

    expect(response, equals(true));
    verify(() => mockMovieRepository.isSavedMovie(movieId: 1));
    verifyNoMoreInteractions(mockMovieRepository);
  });

  test('Toggle bookmark tuns correctly', () async {
    when(() => mockMovieRepository.deleteMovie(movieId: 1))
        .thenAnswer((_) async => const Right(null));
    when(() => mockMovieRepository.saveMovie(movieEntity: Movie(id: 1)))
        .thenAnswer((_) async => const Right(null));

    when(() => mockMovieRepository.isSavedMovie(movieId: 1))
        .thenAnswer((_) async => const Right(true));
    await movieUseCases.toggleBookmark(movieEntity: Movie(id: 1));
    verify(() => mockMovieRepository.deleteMovie(movieId: 1));

    when(() => mockMovieRepository.isSavedMovie(movieId: 1))
        .thenAnswer((_) async => const Right(false));
    await movieUseCases.toggleBookmark(movieEntity: Movie(id: 1));
    verify(() => mockMovieRepository.saveMovie(movieEntity: Movie(id: 1)));
    verify(() => mockMovieRepository.isSavedMovie(movieId: 1)).called(2);
    verifyNoMoreInteractions(mockMovieRepository);
  });
}

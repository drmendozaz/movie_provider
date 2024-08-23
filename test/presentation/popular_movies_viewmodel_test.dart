import 'dart:convert';

import 'package:movie_provider/core/failure.dart';
import 'package:movie_provider/data/models/movie_list_response.dart';
import 'package:movie_provider/domain/entities/movie.dart';
import 'package:movie_provider/domain/entities/movie_list.dart';
import 'package:movie_provider/domain/usecases/movie_usecases.dart';
import 'package:movie_provider/presentation/popular/popular_movies_viewmodel.dart';
import 'package:movie_provider/presentation/popular/popular_movies_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/json_reader.dart';

class MockMovieUsecases extends Mock implements MovieUseCases {}

void main() {
  late int listenerCallCount;
  late MovieUseCases mockMovieUsecases;
  late PopularMoviesViewModel viewModel;

  var tMovies = MovieListResponse.fromJsonMap(
          json.decode(readJson('helpers/movies_response.json')))
      .toEntity();

  setUp(() {
    listenerCallCount = 0;
    mockMovieUsecases = MockMovieUsecases();
    viewModel = PopularMoviesViewModel(mockMovieUsecases)
      ..addListener(() {
        listenerCallCount++;
      });
  });

  test(
    'Should change state to loading when usecase is called',
    () async {
      when(() => mockMovieUsecases.getPopularMovies(page: 1))
          .thenAnswer((_) async => const Right(MovieListEntity()));

      viewModel.getPopularMovies();

      expect(viewModel.state, equals(const PopularMoviesState.loading()));
      expect(listenerCallCount, equals(1));
    },
  );

  test(
    'Should change movies when data is gotten successfully',
    () async {
      when(() => mockMovieUsecases.getPopularMovies(page: 1))
          .thenAnswer((_) async => Right(tMovies));

      await viewModel.getPopularMovies();

      expect(
          viewModel.state,
          equals(
              PopularMoviesState.success(movies: tMovies.movies ?? <Movie>[])));
      expect(listenerCallCount, equals(2));
    },
  );

  test(
    'Should return server failure when error',
    () async {
      when(() => mockMovieUsecases.getPopularMovies(page: 1))
          .thenAnswer((_) async => const Left(ServerFailure('Server failure')));

      await viewModel.getPopularMovies();

      expect(
          viewModel.state,
          equals(
              const PopularMoviesState.noResults(message: 'Server failure')));
      expect(listenerCallCount, equals(2));
    },
  );

  test(
    'Should return true if a movie is saved',
    () async {
      when(() => mockMovieUsecases.isSavedMovie(1))
          .thenAnswer((_) async => true);

      final saved = await viewModel.isSavedMovie(1);

      expect(saved, equals(true));
    },
  );

  test(
    'Should notify listeners when toggling a bookmark',
    () async {
      when(() => mockMovieUsecases.toggleBookmark(movieEntity: Movie(id: 1)))
          .thenAnswer((_) async => const Right(null));

      await viewModel.toggleBookmark(movieEntity: Movie(id: 1));

      expect(listenerCallCount, equals(1));
    },
  );
}

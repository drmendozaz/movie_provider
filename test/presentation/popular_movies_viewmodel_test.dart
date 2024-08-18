import 'dart:convert';

import 'package:flutter_application_1/core/failure.dart';
import 'package:flutter_application_1/data/models/movie_list_response.dart';
import 'package:flutter_application_1/domain/entities/movie.dart';
import 'package:flutter_application_1/domain/entities/movie_list.dart';
import 'package:flutter_application_1/domain/usecases/movie_usecases.dart';
import 'package:flutter_application_1/presentation/popular/popular_movies_viewmodel.dart';
import 'package:flutter_application_1/presentation/popular/popular_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/json_reader.dart';

class MockMovieUsecases extends Mock implements MovieUsecases {}

void main() {
  late int listenerCallCount;
  late MockMovieUsecases mockMovieUsecases;
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
    'should change state to loading when usecase is called',
    () async {
      when(() => mockMovieUsecases.getPopularMovies(page: 1))
          .thenAnswer((_) async => const Right(MovieListEntity()));

      viewModel.getPopularMovies();

      expect(viewModel.state, equals(const PopularMoviesState.loading()));
      expect(listenerCallCount, equals(1));
    },
  );

  test(
    'should change movies when data is gotten successfully',
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
    'should return server failure when error',
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
}

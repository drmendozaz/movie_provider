import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:movie_provider/data/models/movie_list_response.dart';
import 'package:movie_provider/domain/entities/movie.dart';
import 'package:movie_provider/presentation/popular/popular_movies_view.dart';
import 'package:movie_provider/presentation/popular/popular_movies_viewmodel.dart';
import 'package:movie_provider/presentation/popular/popular_movies_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import '../helpers/json_reader.dart';

class MockPopularMoviesViewModel extends Mock
    implements PopularMoviesViewModel {}

void main() {
  late PopularMoviesViewModel mockViewModel;

  final movieEntity = MovieListResponse.fromJsonMap(
          json.decode(readJson('helpers/movies_response.json')))
      .toEntity();

  setUp(() {
    mockViewModel = MockPopularMoviesViewModel();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<PopularMoviesViewModel>.value(
      value: mockViewModel,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('View should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockViewModel.state)
        .thenReturn(const PopularMoviesState.loading());

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(makeTestableWidget(const PopularMoviesView()));

    expect(progressBarFinder, equals(findsOneWidget));
  });

  testWidgets(
    'View should display list view when data is loaded',
    (WidgetTester tester) async {
      when(() => mockViewModel.state).thenReturn(
          PopularMoviesState.success(movies: movieEntity.movies ?? <Movie>[]));
      when(() => mockViewModel.hasReachedMax).thenReturn(true);
      when(() => mockViewModel.isSavedMovie(any()))
          .thenAnswer((_) async => false);

      final listViewFinder = find.byKey(const Key('moviesListView'));
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          makeTestableWidget(const PopularMoviesView()),
          duration: const Duration(milliseconds: 500),
        );
      });
      await tester.pump(const Duration(milliseconds: 500));

      expect(listViewFinder, equals(findsOneWidget));
    },
  );

  testWidgets(
    'View should display grid view when grid button is tapped',
    (WidgetTester tester) async {
      when(() => mockViewModel.state).thenReturn(
          PopularMoviesState.success(movies: movieEntity.movies ?? <Movie>[]));
      when(() => mockViewModel.hasReachedMax).thenReturn(true);
      when(() => mockViewModel.isSavedMovie(any()))
          .thenAnswer((_) async => false);

      final gridViewFinder = find.byKey(const Key('moviesGridView'));
      final gridButton = find.byType(IconButton);
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          makeTestableWidget(const PopularMoviesView()),
          duration: const Duration(milliseconds: 500),
        );
      });
      await tester.tap(gridButton);
      await tester.pump();
      expect(gridViewFinder, equals(findsOneWidget));
      await tester.pump(const Duration(milliseconds: 500));
    },
  );

  testWidgets(
    'View should display text with message when error',
    (WidgetTester tester) async {
      when(() => mockViewModel.state).thenReturn(
          const PopularMoviesState.noResults(message: 'Error message'));

      final textFinder = find.byKey(const Key('error_message'));

      await tester.pumpWidget(
        makeTestableWidget(const PopularMoviesView()),
        duration: const Duration(milliseconds: 500),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(textFinder, equals(findsOneWidget));
    },
  );
}

import 'package:flutter_application_1/data/api_config.dart';
import 'package:flutter_application_1/data/datasources/movie_remote_data_source.dart';
import 'package:flutter_application_1/data/models/movie_list_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/json_reader.dart';

class MockHttpClient extends Mock implements Client {}

class MockResponse extends Mock implements Response {}

void main() {
  late final Client mockHttpClient = MockHttpClient();
  late final Response mockResponse = MockResponse();
  late final MovieRemoteDataSource remoteDataSource =
      MovieRemoteDataSourceImpl(client: mockHttpClient);

  setUp(() async {
    when(() => mockResponse.statusCode).thenReturn(200);
    when(() => mockResponse.body).thenReturn(
      readJson('helpers/movies_response.json'),
    );

    when(() => mockHttpClient.get(Uri.parse(ApiConfig.nowPlayingMovies)))
        .thenAnswer(
      (_) async => mockResponse,
    );
    when(() => mockHttpClient.get(Uri.parse(ApiConfig.popularMovies)))
        .thenAnswer(
      (_) async => mockResponse,
    );
  });

  test('Fetches now playing movies', () async {
    final response = await remoteDataSource.getNowPlayingMovies(page: 1);

    expect(response, isA<MovieListResponse>());
  });

  test('Fetches popular movies', () async {
    final response = await remoteDataSource.getPopularMovies(page: 1);

    expect(response, isA<MovieListResponse>());
  });

  test('Throws exeption with incorrect response', () async {
    when(() => mockHttpClient.get(Uri.parse(ApiConfig.popularMovies)))
        .thenAnswer((_) async => Response('Not found', 404));

    final response = remoteDataSource.getPopularMovies;

    expect(response(page: 1), throwsException);
  });
}

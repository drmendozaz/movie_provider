import 'package:flutter_application_1/data/api_config.dart';
import 'package:flutter_application_1/data/datasources/movie_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/json_reader.dart';

class MockHttpClient extends Mock implements Client {}

class MockResponse extends Mock implements Response {}

void main() {
  late final Client mockHttpClient = MockHttpClient();
  late final Response response = MockResponse();
  late final MovieRemoteDataSource remoteDataSource = MovieRemoteDataSourceImpl(client: mockHttpClient);

  setUp(() async {
    when(() => response.statusCode).thenReturn(200);
    when(() => response.body).thenReturn(
      readJson('helpers/movies_response.json'),
    );

    when(() => mockHttpClient.get(Uri.parse(ApiConfig.nowPlayingMovies))).thenAnswer(
      (_) async => response,
    );
    when(() => mockHttpClient.get(Uri.parse(ApiConfig.popularMovies))).thenAnswer(
      (_) async => response,
    );
  });

  test('Fetches now playing movies', () async {
    final response = await remoteDataSource.getNowPlayingMovies(page: 1);
    
    expect(response.movies, isNotEmpty);
  });

  test('Fetches popular movies', () async {
    final response = await remoteDataSource.getPopularMovies(page: 1);
    
    expect(response.movies, isNotEmpty);
  });
}
class ApiConfig {
  static const String apiKey = '789a3ad9fb130b33628be0e27eaf57c8';
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  /// Movies
  static const String nowPlayingMovies = '$baseUrl/movie/now_playing?api_key=$apiKey';
  static const String popularMovies = '$baseUrl/movie/popular?api_key=$apiKey';
}
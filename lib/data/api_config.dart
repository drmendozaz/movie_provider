class ApiConfig {
  static const String apiKey = '';
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  /// Movies
  static String nowPlayingMovies(int page) =>
      '$baseUrl/movie/now_playing?api_key=$apiKey&page=$page';
  static String popularMovies(int page) =>
      '$baseUrl/movie/popular?api_key=$apiKey&page=$page';

  /// Image
  static String imageUrl(String path) => '$imageBaseUrl$path';
}

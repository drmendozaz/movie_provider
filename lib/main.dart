import 'package:flutter/material.dart';
import 'package:movie_provider/presentation/home_view.dart';
import 'package:movie_provider/presentation/now_playing/now_playing_movies_state.dart';
import 'package:movie_provider/presentation/now_playing/now_playing_movies_view.dart';
import 'package:movie_provider/presentation/now_playing/now_playing_movies_viewmodel.dart';
import 'package:movie_provider/presentation/popular/popular_movies_viewmodel.dart';
import 'package:provider/provider.dart';

import 'injector.dart' as di;

void main() {
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PopularMoviesViewModel>(
          create: (context) =>
              PopularMoviesViewModel(di.locator())..getPopularMovies(),
        ),
        ChangeNotifierProvider<NowPlayingMoviesViewModel>(
          create: (context) =>
              NowPlayingMoviesViewModel(di.locator())..getNowPlayingMovies(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: HomeView(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (_) => HomeView());
          }
          return null;
        },
      ),
    );
  }
}

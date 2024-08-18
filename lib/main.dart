import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/popular/popular_movies_view.dart';
import 'package:flutter_application_1/presentation/popular/popular_movies_viewmodel.dart';
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
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const PopularMoviesPage(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/popular-movies':
              return MaterialPageRoute(
                  builder: (_) => const PopularMoviesPage());
          }
          return null;
        },
      ),
    );
  }
}

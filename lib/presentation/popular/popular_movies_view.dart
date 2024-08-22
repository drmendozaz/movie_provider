import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_provider/presentation/common/movie_list_view.dart';
import 'package:movie_provider/presentation/popular/popular_movies_viewmodel.dart';
import 'package:movie_provider/presentation/popular/popular_movies_state.dart';
import 'package:provider/provider.dart';

class PopularMoviesView extends StatefulWidget {
  static const routeName = '/popular-movies';

  const PopularMoviesView({super.key});

  @override
  State<PopularMoviesView> createState() => _PopularMoviesViewState();
}

class _PopularMoviesViewState extends State<PopularMoviesView> {
  @override
  void initState() {
    super.initState();

    viewModel = context.read();
  }

  late final PopularMoviesViewModel viewModel;
  bool grid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Popular Movies'),
        backgroundColor: CupertinoColors.activeGreen,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                grid = !grid;
              });
            },
            icon: const Icon(Icons.grid_3x3),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Selector<PopularMoviesViewModel, PopularMoviesState>(
          builder: (context, value, child) {
            switch (value) {
              case InitialPopularMoviesState():
              case LoadingPopularMoviesState():
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case SuccessPopularMoviesState():
                return FadeInUp(
                    from: 20,
                    duration: const Duration(milliseconds: 500),
                    child: () {
                      return MovieListView(
                        hasReachedMax: context
                            .watch<PopularMoviesViewModel>()
                            .hasReachedMax,
                        movies: value.movies,
                        whenScrollBottom: () async =>
                            viewModel.getPopularMovies(),
                        grid: grid,
                        bookmark: (movie) async =>
                            viewModel.toggleBookmark(movieEntity: movie),
                        isSaved: (id) => viewModel.isSavedMovie(id),
                      );
                    }());
              case NoResultsPopularMoviesState():
                return Center(
                  key: const Key('error_message'),
                  child: Text(value.message),
                );
            }
          },
          selector: (context, value) => value.state,
        ),
      ),
    );
  }
}

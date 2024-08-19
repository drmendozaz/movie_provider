import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_provider/presentation/common/movie_list_view.dart';
import 'package:movie_provider/presentation/now_playing/now_playing_movies_state.dart';
import 'package:movie_provider/presentation/now_playing/now_playing_movies_viewmodel.dart';
import 'package:provider/provider.dart';

class NowPlayingMoviesView extends StatefulWidget {
  static const routeName = '/now-playing-movies';

  const NowPlayingMoviesView({super.key});

  @override
  State<NowPlayingMoviesView> createState() => _NowPlayingMoviesViewState();
}

class _NowPlayingMoviesViewState extends State<NowPlayingMoviesView> {
  @override
  void initState() {
    super.initState();

    viewModel = context.read();
  }

  late final NowPlayingMoviesViewModel viewModel;
  bool grid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Now Playing Movies'),
        backgroundColor: CupertinoColors.activeBlue,
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
        child: Selector<NowPlayingMoviesViewModel, NowPlayingMoviesState>(
          builder: (context, value, child) {
            switch (value) {
              case InitialNowPlayingMoviesState():
              case LoadingNowPlayingMoviesState():
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case SuccessNowPlayingMoviesState():
                return FadeInUp(
                    from: 20,
                    duration: const Duration(milliseconds: 500),
                    child: () {
                      return MovieListView(
                        hasReachedMax: context
                            .watch<NowPlayingMoviesViewModel>()
                            .hasReachedMax,
                        movies: value.movies,
                        whenScrollBottom: () async =>
                            viewModel.getNowPlayingMovies(),
                        grid: grid,
                      );
                    }());
              case NoResultsNowPlayingMoviesState():
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

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/common/grid_movie_card.dart';
import 'package:flutter_application_1/presentation/common/movie_card.dart';
import 'package:flutter_application_1/presentation/popular/popular_movies_viewmodel.dart';
import 'package:flutter_application_1/presentation/popular/popular_state.dart';
import 'package:provider/provider.dart';

class PopularMoviesPage extends StatefulWidget {
  static const routeName = '/popular-movies';

  const PopularMoviesPage({super.key});

  @override
  State<PopularMoviesPage> createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage>
    with AutomaticKeepAliveClientMixin<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();

    viewModel = context.read();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<PopularMoviesViewModel>().getPopularMovies();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.99);
  }

  bool grid = false;

  late final PopularMoviesViewModel viewModel;
  late final bool hasReachedMax =
      context.watch<PopularMoviesViewModel>().hasReachedMax;
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Popular Movies'),
        backgroundColor: Colors.black.withOpacity(0.6),
        elevation: 0.0,
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
                      if (grid) {
                        return GridView.builder(
                          key: const Key('popularMoviesGridView'),
                          controller: _scrollController,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 15.0,
                            mainAxisSpacing: 15.0,
                            childAspectRatio: 0.6,
                          ),
                          itemBuilder: (context, index) {
                            final movie = value.movies[index];
                            return GridMovieCard(
                              movie: movie,
                            );
                          },
                          itemCount: value.movies.length,
                        );
                      } else {
                        return ListView.builder(
                          key: const Key('popularMoviesListView'),
                          controller: _scrollController,
                          itemBuilder: (context, index) {
                            final movie = value.movies[index];
                            return MovieCard(
                              movie: movie,
                            );
                          },
                          itemCount: value.movies.length,
                        );
                      }
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

  @override
  bool get wantKeepAlive => true;
}

import 'package:flutter/material.dart';
import 'package:movie_provider/domain/entities/movie.dart';
import 'package:movie_provider/presentation/common/grid_movie_card.dart';
import 'package:movie_provider/presentation/common/movie_card.dart';

class MovieListView extends StatefulWidget {
  const MovieListView(
      {super.key,
      this.movies,
      required this.whenScrollBottom,
      required this.hasReachedMax,
      required this.grid,
      this.bookmark});

  final List<Movie>? movies;
  final void Function() whenScrollBottom;
  final void Function(Movie)? bookmark;
  final bool hasReachedMax;
  final bool grid;

  @override
  State<MovieListView> createState() => _MovieListState();
}

class _MovieListState extends State<MovieListView>
    with AutomaticKeepAliveClientMixin<MovieListView> {
  @override
  void initState() {
    super.initState();
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
      widget.whenScrollBottom.call();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.99);
  }

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ListView(
      shrinkWrap: true,
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      children: [
        widget.grid
            ? GridView.builder(
                key: const Key('popularMoviesGridView'),
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: widget.movies?.length ?? 0,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (_, index) {
                  final tag = UniqueKey();
                  return Hero(
                      tag: tag,
                      child: GridMovieCard(movie: widget.movies?[index]));
                },
              )
            : ListView.builder(
                key: const Key('popularMoviesListView'),
                itemBuilder: (context, index) {
                  final movie = widget.movies?[index];
                  return GestureDetector(
                    onTap: () => widget.bookmark?.call(movie!),
                    child: MovieCard(
                      movie: movie,
                    ),
                  );
                },
                itemCount: widget.movies?.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
              ),
        if (!widget.hasReachedMax)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

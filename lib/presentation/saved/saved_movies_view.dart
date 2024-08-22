import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_provider/domain/entities/movie.dart';
import 'package:movie_provider/presentation/common/movie_list_view.dart';
import 'package:movie_provider/presentation/saved/saved_movies_state.dart';
import 'package:movie_provider/presentation/saved/saved_movies_viewmodel.dart';
import 'package:provider/provider.dart';

class SavedMoviesView extends StatefulWidget {
  static const routeName = '/popular-movies';

  const SavedMoviesView({super.key});

  @override
  State<SavedMoviesView> createState() => _SavedMoviesViewState();
}

class _SavedMoviesViewState extends State<SavedMoviesView> {
  @override
  void initState() {
    super.initState();

    viewModel = context.read();
  }

  late final SavedMoviesViewModel viewModel;
  bool grid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Saved Movies'),
        backgroundColor: CupertinoColors.activeOrange,
        actions: [
          IconButton(
            onPressed: () {
              viewModel.getSavedMovies();
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
        child: Selector<SavedMoviesViewModel, SavedMoviesState>(
          builder: (context, value, child) {
            switch (value) {
              case InitialSavedMoviesState():
              case LoadingSavedMoviesState():
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case SuccessSavedMoviesState():
                return FadeInUp(
                    from: 20,
                    duration: const Duration(milliseconds: 500),
                    child: StreamBuilder(
                        initialData: const <Movie>[],
                        stream: value.movies,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            return MovieListView(
                              hasReachedMax: true,
                              movies: snapshot.data ?? [],
                              whenScrollBottom: () {},
                              grid: grid,
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        }));
              case NoResultsSavedMoviesState():
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

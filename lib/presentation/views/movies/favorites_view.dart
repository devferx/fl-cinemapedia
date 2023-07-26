import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:go_router/go_router.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  FavoritesViewState createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView> {
  bool isLastPage = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    ref.read(favoriteMoviesProvider.notifier).loadNextPage();
  }

  void loadNextPage() async {
    if (isLoading || isLastPage) return;

    setState(() {
      isLoading = true;
    });

    final movies =
        await ref.read(favoriteMoviesProvider.notifier).loadNextPage();

    setState(() {
      isLoading = false;
    });

    if (movies.isEmpty) {
      isLastPage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoritesMovies = ref.watch(favoriteMoviesProvider).values.toList();

    if (favoritesMovies.isEmpty) {
      final colors = Theme.of(context).colorScheme;
      final textTheme = Theme.of(context).textTheme;

      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.heart_broken_rounded, size: 60, color: Colors.red),
          Text("Uh!", style: TextStyle(fontSize: 30, color: colors.primary)),
          Text(
            "You don't have any favorite movie yet",
            style: textTheme.bodyLarge!.copyWith(color: colors.secondary),
          ),
          const SizedBox(height: 20),
          FilledButton.tonal(
            onPressed: () {
              context.go("/home/0");
            },
            child: const Text("Discover Movies"),
          )
        ],
      ));
    }

    return Scaffold(
      body: MovieMasonry(
        movies: favoritesMovies,
        loadNextPage: loadNextPage,
      ),
    );
  }
}

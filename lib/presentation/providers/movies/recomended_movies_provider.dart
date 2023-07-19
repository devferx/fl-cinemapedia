import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/domain/entities/movie.dart';

final recomendedMoviesProvider =
    StateNotifierProvider<RecomendedMoviesNotifier, Map<String, List<Movie>>>(
  (ref) {
    final fetchMoreMovies = ref.watch(movieRepositoryProvider).getSimilarMovies;
    return RecomendedMoviesNotifier(fetchMoreMovies: fetchMoreMovies);
  },
);

typedef GetRecomendedMovies = Future<List<Movie>> Function(
    {required String id, int page});

class RecomendedMoviesNotifier extends StateNotifier<Map<String, List<Movie>>> {
  GetRecomendedMovies fetchMoreMovies;

  RecomendedMoviesNotifier({
    required this.fetchMoreMovies,
  }) : super({});

  Future<void> loadRecomendedMovies(String id) async {
    if (state[id] != null) return;

    final recomendedMovies = await fetchMoreMovies(id: id);

    state = {...state, id: recomendedMovies};
  }
}

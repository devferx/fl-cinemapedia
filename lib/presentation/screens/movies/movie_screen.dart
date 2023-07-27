import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie-screen';
  final String movieId;

  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
    ref
        .read(recomendedMoviesProvider.notifier)
        .loadRecomendedMovies(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];

    if (movie == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(movie: movie),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _MovieDetails(movie: movie),
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieDetails extends ConsumerWidget {
  final Movie movie;

  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context, ref) {
    final size = MediaQuery.of(context).size;

    final recomendedMovies =
        ref.watch(recomendedMoviesProvider)[movie.id.toString()];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TitleAndOverview(movie: movie, size: size),
        _Genres(genres: movie.genreIds),
        ActorsByMovie(movieId: movie.id.toString()),
        if (recomendedMovies != null && recomendedMovies.isNotEmpty)
          MovieHorizontalListview(
            title: "Recomendaciones",
            movies: recomendedMovies,
          ),
        VideosFromMovie(movieId: movie.id),
        const SizedBox(height: 50),
      ],
    );
  }
}

class _TitleAndOverview extends StatelessWidget {
  const _TitleAndOverview({
    required this.movie,
    required this.size,
  });

  final Movie movie;
  final Size size;

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              movie.posterPath,
              width: size.width * 0.3,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie.title, style: textStyles.titleLarge),
                Text(movie.overview),
                const SizedBox(height: 8),
                MovieRating(voteAverage: movie.voteAverage),
                Text(
                  'Fecha de lanzamiento: ${HumanFormats.shortDate(movie.releaseDate)}',
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Genres extends StatelessWidget {
  final List<String> genres;

  const _Genres({required this.genres});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Wrap(
        children: [
          ...genres.map(
            (gender) => Container(
              margin: const EdgeInsets.only(right: 10),
              child: Chip(
                label: Text(gender),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

final isFavoriteProvider =
    FutureProvider.family.autoDispose((ref, int movieId) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return localStorageRepository.isMovieFavorite(movieId);
});

class _CustomSliverAppBar extends ConsumerWidget {
  final Movie movie;

  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavoriteFuture = ref.watch(isFavoriteProvider(movie.id));

    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          onPressed: () async {
            // ref.watch(localStorageRepositoryProvider).toggleFavorite(movie);
            await ref
                .read(favoriteMoviesProvider.notifier)
                .toggleFavorite(movie);

            ref.invalidate(isFavoriteProvider(movie.id));
          },
          icon: isFavoriteFuture.when(
            data: (isFavorite) {
              return isFavorite
                  ? const Icon(
                      Icons.favorite_rounded,
                      color: Colors.red,
                    )
                  : const Icon(Icons.favorite_border);
            },
            error: (_, __) => throw UnimplementedError(),
            loading: () => const CircularProgressIndicator(strokeWidth: 2),
          ),
        )
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(bottom: 0),
        title: _CustomGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.7, 1.0],
          colors: [
            Colors.transparent,
            scaffoldBackgroundColor,
          ],
        ),
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) return const SizedBox();

                  return FadeIn(child: child);
                },
              ),
            ),

            // Favorite Button Gradient
            const _CustomGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.0, 0.2],
              colors: [
                Colors.black45,
                Colors.transparent,
              ],
            ),

            // Back Arrow Gradient
            const _CustomGradient(
              begin: Alignment.topLeft,
              stops: [0.0, 0.3],
              colors: [
                Colors.black87,
                Colors.transparent,
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomGradient extends StatelessWidget {
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<double> stops;
  final List<Color> colors;

  const _CustomGradient({
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
    required this.stops,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: begin,
            end: end,
            stops: stops,
            colors: colors,
          ),
        ),
      ),
    );
  }
}

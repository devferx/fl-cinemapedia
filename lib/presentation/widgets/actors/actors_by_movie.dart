import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';

import 'package:cinemapedia/presentation/providers/providers.dart';

class ActorsByMovie extends ConsumerWidget {
  final String movieId;

  const ActorsByMovie({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, ref) {
    final actorsByMovie = ref.watch(actorsByMovieProvider);

    if (actorsByMovie[movieId] == null) {
      return Container(
        height: 100,
        margin: const EdgeInsets.only(bottom: 50),
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    final actors = actorsByMovie[movieId]!;

    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) {
          final actor = actors[index];

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
            width: 135,
            child: FadeInRight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FadeInImage(
                      height: 180,
                      width: 135,
                      fit: BoxFit.cover,
                      placeholder: const AssetImage("assets/bottle-loader.gif"),
                      image: NetworkImage(actor.profilePath),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(actor.name, maxLines: 2),
                  Text(
                    actor.character ?? '',
                    maxLines: 2,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

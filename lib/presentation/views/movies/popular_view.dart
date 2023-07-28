import 'package:flutter/material.dart';

import 'package:cinemapedia/presentation/widgets/widgets.dart';

class PopularView extends StatelessWidget {
  const PopularView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MovieMasonry(
        // loadNextPage: loadNextPage,
        movies: [],
      ),
    );
  }
}

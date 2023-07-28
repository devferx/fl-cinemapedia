import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'movies_providers.dart';

final initialLoadingProvider = Provider<bool>((ref) {
  final step1 = ref.watch(nowPlayingMoviesProvider).isEmpty;
  // TODO: Uncomment this line when popular movies are implemented
  // final step2 = ref.watch(popularMoviesProvider).isEmpty;
  final step3 = ref.watch(topRatedMoviesProvider).isEmpty;
  final step4 = ref.watch(upcomingMoviesProvider).isEmpty;

  if (step1 || step3 || step4) {
    return true;
  }

  return false;
});

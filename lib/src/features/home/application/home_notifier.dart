import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';
import 'package:lets_stream/src/core/services/tmdb_repository_provider.dart';
import 'package:lets_stream/src/features/home/application/home_state.dart';

class HomeNotifier extends StateNotifier<AsyncValue<HomeState>> {
  final Ref ref;

  HomeNotifier(this.ref) : super(const AsyncValue.loading()) {
    fetchData();
  }

  Future<void> fetchData() async {
    state = const AsyncValue.loading();

    try {
      final tmdbRepository = ref.read(tmdbRepositoryProvider);

      // Fetch all data concurrently
      final results = await Future.wait([
        tmdbRepository.getTrendingMovies(),
        tmdbRepository.getNowPlayingMovies(),
        tmdbRepository.getPopularMovies(),
        tmdbRepository.getTopRatedMovies(),
        tmdbRepository.getTrendingTvShows(),
        tmdbRepository.getAiringTodayTvShows(),
        tmdbRepository.getPopularTvShows(),
        tmdbRepository.getTopRatedTvShows(),
      ]);

      state = AsyncValue.data(
        HomeState(
          trendingMovies: results[0] as List<Movie>,
          nowPlayingMovies: results[1] as List<Movie>,
          popularMovies: results[2] as List<Movie>,
          topRatedMovies: results[3] as List<Movie>,
          trendingTvShows: results[4] as List<TvShow>,
          airingTodayTvShows: results[5] as List<TvShow>,
          popularTvShows: results[6] as List<TvShow>,
          topRatedTvShows: results[7] as List<TvShow>,
        ),
      );
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}

final homeNotifierProvider =
    StateNotifierProvider<HomeNotifier, AsyncValue<HomeState>>((ref) {
  return HomeNotifier(ref);
});
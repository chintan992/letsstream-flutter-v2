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

      // Define API calls with controlled concurrency to avoid overwhelming the API
      final apiCalls = [
        () => tmdbRepository.getTrendingMovies(),
        () => tmdbRepository.getNowPlayingMovies(),
        () => tmdbRepository.getPopularMovies(),
        () => tmdbRepository.getTopRatedMovies(),
        () => tmdbRepository.getTrendingTvShows(),
        () => tmdbRepository.getAiringTodayTvShows(),
        () => tmdbRepository.getPopularTvShows(),
        () => tmdbRepository.getTopRatedTvShows(),
      ];

      // Execute API calls with controlled concurrency (max 3 concurrent requests)
      final results = await _executeWithConcurrencyLimit(
        apiCalls,
        maxConcurrent: 3,
      );

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

  /// Execute API calls with controlled concurrency to prevent overwhelming the API
  Future<List<dynamic>> _executeWithConcurrencyLimit(
    List<Future<dynamic> Function()> apiCalls, {
    int maxConcurrent = 3,
  }) async {
    final results = <dynamic>[];
    final semaphore = List.generate(maxConcurrent, (_) => true);

    for (final apiCall in apiCalls) {
      // Wait for an available slot
      while (semaphore.where((available) => available).isEmpty) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // Find and occupy an available slot
      final slotIndex = semaphore.indexWhere((available) => available);
      semaphore[slotIndex] = false;

      // Execute the API call
      apiCall()
          .then((result) {
            results.add(result);
            semaphore[slotIndex] = true; // Free the slot
          })
          .catchError((error) {
            results.add(error);
            semaphore[slotIndex] = true; // Free the slot even on error
          });
    }

    // Wait for all calls to complete
    while (results.length < apiCalls.length) {
      await Future.delayed(const Duration(milliseconds: 50));
    }

    return results;
  }
}

final homeNotifierProvider =
    StateNotifierProvider<HomeNotifier, AsyncValue<HomeState>>((ref) {
      return HomeNotifier(ref);
    });

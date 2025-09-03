import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';
import 'package:lets_stream/src/core/services/tmdb_repository_provider.dart';
import 'package:lets_stream/src/features/home/application/home_state.dart';
import 'package:lets_stream/src/core/services/image_prefetch_service.dart';

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

      final homeState = HomeState(
        trendingMovies: results[0] as List<Movie>,
        nowPlayingMovies: results[1] as List<Movie>,
        popularMovies: results[2] as List<Movie>,
        topRatedMovies: results[3] as List<Movie>,
        trendingTvShows: results[4] as List<TvShow>,
        airingTodayTvShows: results[5] as List<TvShow>,
        popularTvShows: results[6] as List<TvShow>,
        topRatedTvShows: results[7] as List<TvShow>,
      );

      // Preload images for the first few items in each carousel for better performance
      _preloadImages(homeState);

      // Pre-fetch images for better user experience
      _prefetchImages(homeState);

      state = AsyncValue.data(homeState);
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

  /// Preload images for the first few items in each carousel to improve perceived performance
  void _preloadImages(HomeState homeState) {
    final imageBaseUrl = dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';
    if (imageBaseUrl.isEmpty) return;

    // Collect poster paths from the first 3 items of each carousel
    final posterPaths = <String>[];

    // Movies
    posterPaths.addAll(
      homeState.trendingMovies
          .take(3)
          .map((m) => m.posterPath)
          .whereType<String>(),
    );
    posterPaths.addAll(
      homeState.nowPlayingMovies
          .take(3)
          .map((m) => m.posterPath)
          .whereType<String>(),
    );
    posterPaths.addAll(
      homeState.popularMovies
          .take(3)
          .map((m) => m.posterPath)
          .whereType<String>(),
    );
    posterPaths.addAll(
      homeState.topRatedMovies
          .take(3)
          .map((m) => m.posterPath)
          .whereType<String>(),
    );

    // TV Shows
    posterPaths.addAll(
      homeState.trendingTvShows
          .take(3)
          .map((tv) => tv.posterPath)
          .whereType<String>(),
    );
    posterPaths.addAll(
      homeState.airingTodayTvShows
          .take(3)
          .map((tv) => tv.posterPath)
          .whereType<String>(),
    );
    posterPaths.addAll(
      homeState.popularTvShows
          .take(3)
          .map((tv) => tv.posterPath)
          .whereType<String>(),
    );
    posterPaths.addAll(
      homeState.topRatedTvShows
          .take(3)
          .map((tv) => tv.posterPath)
          .whereType<String>(),
    );

    // Preload images using CachedNetworkImage's provider
    for (final posterPath in posterPaths.toSet()) {
      // Use Set to avoid duplicates
      final imageUrl = '$imageBaseUrl/w500$posterPath';
      // Create CachedNetworkImageProvider to preload and cache images
      CachedNetworkImageProvider(imageUrl);
    }
  }

  /// Pre-fetch images for better user experience
  Future<void> _prefetchImages(HomeState homeState) async {
    final prefetchService = ImagePrefetchService();

    // Pre-fetch trending movies
    if (homeState.trendingMovies.isNotEmpty) {
      await prefetchService.prefetchMovieImages(
        homeState.trendingMovies,
        maxImages: 8,
      );
    }

    // Pre-fetch popular movies
    if (homeState.popularMovies.isNotEmpty) {
      await prefetchService.prefetchMovieImages(
        homeState.popularMovies,
        maxImages: 6,
      );
    }

    // Pre-fetch trending TV shows
    if (homeState.trendingTvShows.isNotEmpty) {
      await prefetchService.prefetchTvShowImages(
        homeState.trendingTvShows,
        maxImages: 8,
      );
    }

    // Pre-fetch popular TV shows
    if (homeState.popularTvShows.isNotEmpty) {
      await prefetchService.prefetchTvShowImages(
        homeState.popularTvShows,
        maxImages: 6,
      );
    }
  }
}

final homeNotifierProvider =
    StateNotifierProvider<HomeNotifier, AsyncValue<HomeState>>((ref) {
      return HomeNotifier(ref);
    });

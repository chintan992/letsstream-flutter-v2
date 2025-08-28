import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lets_stream/src/features/home/application/home_notifier.dart';
import 'package:lets_stream/src/shared/widgets/media_carousel.dart';
import 'package:lets_stream/src/shared/widgets/app_logo.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const AppLogo(showText: true, size: 32),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.pushNamed('search');
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: homeState.when(
        data: (state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Trending Movies
                if (state.trendingMovies.isNotEmpty)
                  MediaCarousel(
                    title: 'Trending Movies',
                    items: state.trendingMovies,
                    onViewAll: () {
                      context.pushNamed('movies-list', pathParameters: {'feed': 'trending'});
                    },
                  ),

                // Now Playing Movies
                if (state.nowPlayingMovies.isNotEmpty)
                  MediaCarousel(
                    title: 'Now Playing',
                    items: state.nowPlayingMovies,
                    onViewAll: () {
                      context.pushNamed('movies-list', pathParameters: {'feed': 'now_playing'});
                    },
                  ),

                // Popular Movies
                if (state.popularMovies.isNotEmpty)
                  MediaCarousel(
                    title: 'Popular Movies',
                    items: state.popularMovies,
                    onViewAll: () {
                      context.pushNamed('movies-list', pathParameters: {'feed': 'popular'});
                    },
                  ),

                // Top Rated Movies
                if (state.topRatedMovies.isNotEmpty)
                  MediaCarousel(
                    title: 'Top Rated Movies',
                    items: state.topRatedMovies,
                    onViewAll: () {
                      context.pushNamed('movies-list', pathParameters: {'feed': 'top_rated'});
                    },
                  ),

                // Trending TV Shows
                if (state.trendingTvShows.isNotEmpty)
                  MediaCarousel(
                    title: 'Trending TV Shows',
                    items: state.trendingTvShows,
                    onViewAll: () {
                      context.pushNamed('tv-list', pathParameters: {'feed': 'trending'});
                    },
                  ),

                // Airing Today TV Shows
                if (state.airingTodayTvShows.isNotEmpty)
                  MediaCarousel(
                    title: 'Airing Today',
                    items: state.airingTodayTvShows,
                    onViewAll: () {
                      context.pushNamed('tv-list', pathParameters: {'feed': 'airing_today'});
                    },
                  ),

                // Popular TV Shows
                if (state.popularTvShows.isNotEmpty)
                  MediaCarousel(
                    title: 'Popular TV Shows',
                    items: state.popularTvShows,
                    onViewAll: () {
                      context.pushNamed('tv-list', pathParameters: {'feed': 'popular'});
                    },
                  ),

                // Top Rated TV Shows
                if (state.topRatedTvShows.isNotEmpty)
                  MediaCarousel(
                    title: 'Top Rated TV Shows',
                    items: state.topRatedTvShows,
                    onViewAll: () {
                      context.pushNamed('tv-list', pathParameters: {'feed': 'top_rated'});
                    },
                  ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(homeNotifierProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lets_stream/src/features/hub/application/hub_notifier.dart';
import 'package:lets_stream/src/shared/widgets/media_carousel.dart';

class MoviesHubScreen extends ConsumerWidget {
  const MoviesHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hubState = ref.watch(hubNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Movies'), centerTitle: true),
      body: hubState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _MoviesHubBody(state: hubState),
    );
  }
}

class _MoviesHubBody extends ConsumerWidget {
  final HubState state;

  const _MoviesHubBody({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MediaCarousel(
            title: 'Trending',
            items: state.trendingMovies,
            onViewAll: () => context.pushNamed('movies-list', pathParameters: {'feed': 'trending'}),
          ),
          MediaCarousel(
            title: 'Now Playing',
            items: state.nowPlayingMovies,
            onViewAll: () => context.pushNamed('movies-list', pathParameters: {'feed': 'now_playing'}),
          ),
          MediaCarousel(
            title: 'Popular',
            items: state.popularMovies,
            onViewAll: () => context.pushNamed('movies-list', pathParameters: {'feed': 'popular'}),
          ),
          MediaCarousel(
            title: 'Top Rated',
            items: state.topRatedMovies,
            onViewAll: () => context.pushNamed('movies-list', pathParameters: {'feed': 'top_rated'}),
          ),
        ],
      ),
    );
  }
}

class TvHubScreen extends ConsumerWidget {
  const TvHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hubState = ref.watch(hubNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('TV Shows'), centerTitle: true),
      body: hubState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _TvHubBody(state: hubState),
    );
  }
}

class _TvHubBody extends ConsumerWidget {
  final HubState state;

  const _TvHubBody({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MediaCarousel(
            title: 'Trending',
            items: state.trendingTvShows,
            onViewAll: () => context.pushNamed('tv-list', pathParameters: {'feed': 'trending'}),
          ),
          MediaCarousel(
            title: 'Airing Today',
            items: state.airingTodayTvShows,
            onViewAll: () => context.pushNamed('tv-list', pathParameters: {'feed': 'airing_today'}),
          ),
          MediaCarousel(
            title: 'Popular',
            items: state.popularTvShows,
            onViewAll: () => context.pushNamed('tv-list', pathParameters: {'feed': 'popular'}),
          ),
          MediaCarousel(
            title: 'Top Rated',
            items: state.topRatedTvShows,
            onViewAll: () => context.pushNamed('tv-list', pathParameters: {'feed': 'top_rated'}),
          ),
        ],
      ),
    );
  }
}


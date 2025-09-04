import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lets_stream/src/features/hub/application/hub_notifier.dart';
import 'package:lets_stream/src/shared/widgets/media_carousel.dart';

class HubScreen extends ConsumerWidget {
  const HubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hubState = ref.watch(hubNotifierProvider);
    final textTheme = Theme.of(context).textTheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                title: const Text('Hub'),
                pinned: true,
                floating: true,
                actions: const [_SearchButton()],
                flexibleSpace: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      color: Colors.black.withAlpha(51),
                    ),
                  ),
                ),
                bottom: TabBar(
                  tabs: const [
                    Tab(text: 'Movies'),
                    Tab(text: 'TV Shows'),
                  ],
                  labelStyle: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: textTheme.titleMedium,
                ),
              ),
            ];
          },
          body: hubState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                  children: [
                    _MoviesHubBody(state: hubState),
                    _TvHubBody(state: hubState),
                  ],
                ),
        ),
      ),
    );
  }
}

class _MoviesHubBody extends ConsumerWidget {
  final HubState state;

  const _MoviesHubBody({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
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
          MediaCarousel(
            title: 'Action',
            items: state.actionMovies,
            onViewAll: () => context.pushNamed('movies-genre', pathParameters: {'id': '28'}, queryParameters: {'name': 'Action'}),
          ),
          MediaCarousel(
            title: 'Comedy',
            items: state.comedyMovies,
            onViewAll: () => context.pushNamed('movies-genre', pathParameters: {'id': '35'}, queryParameters: {'name': 'Comedy'}),
          ),
          MediaCarousel(
            title: 'Horror',
            items: state.horrorMovies,
            onViewAll: () => context.pushNamed('movies-genre', pathParameters: {'id': '27'}, queryParameters: {'name': 'Horror'}),
          ),
        ],
      ),
    );
  }
}

class _TvHubBody extends ConsumerWidget {
  final HubState state;

  const _TvHubBody({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
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
          MediaCarousel(
            title: 'Netflix',
            items: state.netflixShows,
            onViewAll: () => context.pushNamed('tv-list', pathParameters: {'feed': 'netflix'}),
          ),
          MediaCarousel(
            title: 'Amazon Prime Video',
            items: state.amazonPrimeShows,
            onViewAll: () => context.pushNamed('tv-list', pathParameters: {'feed': 'amazon_prime'}),
          ),
        ],
      ),
    );
  }
}

class _SearchButton extends StatelessWidget {
  const _SearchButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => context.pushNamed('search'),
      icon: const Icon(Icons.search),
      tooltip: 'Search',
    );
  }
}

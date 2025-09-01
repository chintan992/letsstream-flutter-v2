import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lets_stream/src/features/home/application/home_notifier.dart';
import 'package:lets_stream/src/features/home/application/home_state.dart';
import 'package:lets_stream/src/shared/widgets/media_carousel.dart';
import 'package:lets_stream/src/shared/widgets/app_logo.dart';
import 'package:lets_stream/src/shared/widgets/shimmer_box.dart';
import 'package:lets_stream/src/core/models/api_error.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const AppLogo(showText: true, size: 32),
        centerTitle: false, // Better alignment with actions
        actions: [
          IconButton(
            onPressed: () => context.pushNamed('search'),
            icon: const Icon(Icons.search),
            tooltip: 'Search',
          ),
        ],
      ),
      body: homeState.when(
        data: (state) => _buildHomeContent(context, state),
        loading: () => const _HomeScreenLoading(),
        error: (error, stack) => _buildErrorWidget(context, ref, error),
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context, HomeState state) {
    final carousels = _getCarouselConfigurations(context, state);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: carousels.map((config) {
          if (config.items.isNotEmpty) {
            return MediaCarousel(
              title: config.title,
              items: config.items,
              onViewAll: config.onViewAll,
            );
          }
          return const SizedBox.shrink();
        }).toList(),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, WidgetRef ref, Object error) {
    final theme = Theme.of(context);

    // Get user-friendly error message
    String title = 'Could not load content';
    String message = 'An unexpected error occurred. Please try again.';
    IconData icon = Icons.cloud_off_rounded;

    if (error is ApiError) {
      title = _getErrorTitle(error);
      message = error.userFriendlyMessage;
      icon = _getErrorIcon(error);
    } else {
      message = error.toString();
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: theme.colorScheme.secondary),
            const SizedBox(height: 24),
            Text(
              title,
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () =>
                  ref.read(homeNotifierProvider.notifier).fetchData(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  String _getErrorTitle(ApiError error) {
    return error.when(
      network: (message, statusCode, details) => 'Connection Problem',
      timeout: (message, details) => 'Request Timeout',
      rateLimit: (message, retryAfter, details) => 'Too Many Requests',
      unauthorized: (message, details) => 'Authentication Error',
      notFound: (message, details) => 'Content Not Found',
      server: (message, statusCode, details) => 'Server Error',
      parsing: (message, details) => 'Data Error',
      unknown: (message, details) => 'Unexpected Error',
      offline: (message, details) => 'Offline Mode',
    );
  }

  IconData _getErrorIcon(ApiError error) {
    return error.when(
      network: (message, statusCode, details) => Icons.wifi_off,
      timeout: (message, details) => Icons.timer_off,
      rateLimit: (message, retryAfter, details) => Icons.speed,
      unauthorized: (message, details) => Icons.lock,
      notFound: (message, details) => Icons.search_off,
      server: (message, statusCode, details) => Icons.cloud_off,
      parsing: (message, details) => Icons.bug_report,
      unknown: (message, details) => Icons.error,
      offline: (message, details) => Icons.signal_wifi_off,
    );
  }

  List<_CarouselConfig> _getCarouselConfigurations(
    BuildContext context,
    HomeState state,
  ) {
    return [
      _CarouselConfig(
        title: 'Trending Movies',
        items: state.trendingMovies,
        onViewAll: () => context.pushNamed(
          'movies-list',
          pathParameters: {'feed': 'trending'},
        ),
      ),
      _CarouselConfig(
        title: 'Now Playing',
        items: state.nowPlayingMovies,
        onViewAll: () => context.pushNamed(
          'movies-list',
          pathParameters: {'feed': 'now_playing'},
        ),
      ),
      _CarouselConfig(
        title: 'Popular Movies',
        items: state.popularMovies,
        onViewAll: () => context.pushNamed(
          'movies-list',
          pathParameters: {'feed': 'popular'},
        ),
      ),
      _CarouselConfig(
        title: 'Top Rated Movies',
        items: state.topRatedMovies,
        onViewAll: () => context.pushNamed(
          'movies-list',
          pathParameters: {'feed': 'top_rated'},
        ),
      ),
      _CarouselConfig(
        title: 'Trending TV Shows',
        items: state.trendingTvShows,
        onViewAll: () =>
            context.pushNamed('tv-list', pathParameters: {'feed': 'trending'}),
      ),
      _CarouselConfig(
        title: 'Airing Today',
        items: state.airingTodayTvShows,
        onViewAll: () => context.pushNamed(
          'tv-list',
          pathParameters: {'feed': 'airing_today'},
        ),
      ),
      _CarouselConfig(
        title: 'Popular TV Shows',
        items: state.popularTvShows,
        onViewAll: () =>
            context.pushNamed('tv-list', pathParameters: {'feed': 'popular'}),
      ),
      _CarouselConfig(
        title: 'Top Rated TV Shows',
        items: state.topRatedTvShows,
        onViewAll: () =>
            context.pushNamed('tv-list', pathParameters: {'feed': 'top_rated'}),
      ),
    ];
  }
}

class _HomeScreenLoading extends StatelessWidget {
  const _HomeScreenLoading();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(4, (index) => _buildShimmerCarousel(context)),
      ),
    );
  }

  Widget _buildShimmerCarousel(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerBox(
                  width: 150,
                  height: textTheme.headlineSmall!.fontSize!,
                ),
                ShimmerBox(width: 70, height: textTheme.bodyMedium!.fontSize!),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: ShimmerBox(width: 130, height: 200),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CarouselConfig {
  final String title;
  final List<dynamic> items;
  final VoidCallback onViewAll;

  _CarouselConfig({
    required this.title,
    required this.items,
    required this.onViewAll,
  });
}

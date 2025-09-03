import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lets_stream/src/features/home/application/home_notifier.dart';
import 'package:lets_stream/src/features/home/application/home_state.dart';
import 'package:lets_stream/src/shared/widgets/media_carousel.dart';
import 'package:lets_stream/src/shared/widgets/app_logo.dart';
import 'package:lets_stream/src/shared/widgets/shimmer_box.dart';
import 'package:lets_stream/src/core/services/error_handling_service.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeAsyncValue = ref.watch(homeNotifierProvider);

    return Semantics(
      label: 'Let\'s Stream Home',
      hint: 'Browse trending movies and TV shows',
      child: Scaffold(
        appBar: const _HomeAppBar(),
        body: homeAsyncValue.when(
          data: (state) => _HomeContent(state: state),
          loading: () => const _HomeScreenLoading(),
          error: (error, stack) => _HomeErrorWidget(error: error, ref: ref),
        ),
      ),
    );
  }

  static List<_CarouselConfig> _getCarouselConfigurations(
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

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _HomeAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const AppLogo(showText: true, size: 32),
      centerTitle: false,
      actions: const [_SearchButton()],
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

class _HomeContent extends StatelessWidget {
  final HomeState state;

  const _HomeContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final carousels = HomeScreen._getCarouselConfigurations(context, state);

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
}

class _HomeErrorWidget extends StatelessWidget {
  final Object error;
  final WidgetRef ref;

  const _HomeErrorWidget({required this.error, required this.ref});

  @override
  Widget build(BuildContext context) {
    final errorHandlingService = ErrorHandlingService();

    return errorHandlingService.buildErrorWidget(
      context,
      error: error,
      onRetry: () => ref.read(homeNotifierProvider.notifier).fetchData(),
    );
  }
}

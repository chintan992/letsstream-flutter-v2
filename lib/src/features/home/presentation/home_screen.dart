import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lets_stream/src/features/home/application/home_notifier.dart';
import 'package:lets_stream/src/features/home/application/home_state.dart';
import 'package:lets_stream/src/shared/theme/netflix_colors.dart';

import 'package:lets_stream/src/shared/widgets/shimmer_box.dart';
import 'package:lets_stream/src/core/services/error_handling_service.dart';
import 'widgets/hero_carousel.dart';
import 'widgets/media_horizontal_list.dart';
import 'widgets/continue_watching_section.dart';
import '../application/hero_movie_provider.dart';

/// The redesigned home screen with SkyStream-style UI.
///
/// Features:
/// - Hero carousel with parallax effect
/// - Animated app bar with scroll-based transparency
/// - CustomScrollView with Slivers for better performance
/// - Filter and search buttons
/// - Horizontal media lists with "View All" navigation
/// - Blue accent design throughout
class HomeScreen extends ConsumerStatefulWidget {
  /// Creates a new [HomeScreen] instance.
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  late ScrollController _scrollController;
  final ValueNotifier<bool> _isScrolledNotifier = ValueNotifier<bool>(false);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final isScrolled = _scrollController.offset > 200;
    if (isScrolled != _isScrolledNotifier.value) {
      _isScrolledNotifier.value = isScrolled;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _isScrolledNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    final homeAsyncValue = ref.watch(homeNotifierProvider);
    final heroMoviesAsync = ref.watch(heroMovieProvider);

    return ValueListenableBuilder<bool>(
      valueListenable: _isScrolledNotifier,
      builder: (context, isScrolled, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final overlayStyle = isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            systemOverlayStyle: overlayStyle,
            forceMaterialTransparency: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: AnimatedBuilder(
              animation: _scrollController,
              builder: (context, child) {
                double offset = 0;
                if (_scrollController.hasClients) {
                  offset = _scrollController.offset * 0.8;
                }
                final opacity = (offset / 300).clamp(0.0, 1.0);

                return Opacity(
                  opacity: opacity,
                  child: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                );
              },
            ),
            title: _buildNetflixLogo(),
            centerTitle: false,
            actions: [
              // Category Chips
              _buildCategoryChips(),
              const SizedBox(width: 16),
            ],
          ),
          body: homeAsyncValue.when(
            data: (state) => _buildContent(state, heroMoviesAsync),
            loading: () => const _HomeScreenLoading(),
            error: (error, stack) => _HomeErrorWidget(error: error, ref: ref),
          ),
        );
      },
    );
  }

  Widget _buildContent(HomeState state, AsyncValue<List<dynamic>> heroAsync) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Hero Carousel
        SliverToBoxAdapter(
          child: heroAsync.when(
            data: (movies) {
              if (movies.isEmpty) return const SizedBox.shrink();
              return HeroCarousel(
                items: movies,
                scrollController: _scrollController,
              );
            },
            loading: () => const SizedBox(
              height: 500,
              child: ShimmerBox(width: double.infinity, height: 500),
            ),
            error: (err, stack) => SizedBox(
              height: 500,
              child: Center(child: Text('Error: $err')),
            ),
          ),
        ),

        // Continue Watching Section
        const SliverToBoxAdapter(
          child: ContinueWatchingSection(),
        ),

        // Popular on Netflix - Trending Movies
        SliverToBoxAdapter(
          child: _buildSection(
            title: 'Popular on Netflix',
            items: state.trendingMovies.take(10).toList(),
            viewAllRoute: 'movies-list',
            viewAllParams: {'feed': 'trending'},
          ),
        ),

        // Trending Now - Popular Movies
        SliverToBoxAdapter(
          child: _buildSection(
            title: 'Trending Now',
            items: state.popularMovies.take(10).toList(),
            viewAllRoute: 'movies-list',
            viewAllParams: {'feed': 'popular'},
          ),
        ),

        // New Releases - Now Playing
        SliverToBoxAdapter(
          child: _buildSection(
            title: 'New Releases',
            items: state.nowPlayingMovies.take(10).toList(),
            viewAllRoute: 'movies-list',
            viewAllParams: {'feed': 'now_playing'},
          ),
        ),

        // Top 10 TV Shows
        SliverToBoxAdapter(
          child: _buildSection(
            title: 'Top 10 TV Shows',
            items: state.trendingTvShows.take(10).toList(),
            viewAllRoute: 'tv-list',
            viewAllParams: {'feed': 'trending'},
            isTop10: true,
          ),
        ),

        // Bingeworthy TV Shows
        SliverToBoxAdapter(
          child: _buildSection(
            title: 'Bingeworthy TV Shows',
            items: state.popularTvShows.take(10).toList(),
            viewAllRoute: 'tv-list',
            viewAllParams: {'feed': 'popular'},
          ),
        ),

        // Critically Acclaimed - Top Rated Movies
        SliverToBoxAdapter(
          child: _buildSection(
            title: 'Critically Acclaimed',
            items: state.topRatedMovies.take(10).toList(),
            viewAllRoute: 'movies-list',
            viewAllParams: {'feed': 'top_rated'},
          ),
        ),

        // Award-Winning TV - Top Rated TV Shows
        SliverToBoxAdapter(
          child: _buildSection(
            title: 'Award-Winning TV',
            items: state.topRatedTvShows.take(10).toList(),
            viewAllRoute: 'tv-list',
            viewAllParams: {'feed': 'top_rated'},
          ),
        ),

        // Watch Tonight - Airing Today
        SliverToBoxAdapter(
          child: _buildSection(
            title: 'Watch Tonight',
            items: state.airingTodayTvShows.take(10).toList(),
            viewAllRoute: 'tv-list',
            viewAllParams: {'feed': 'airing_today'},
          ),
        ),

        // Bottom Spacer
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<dynamic> items,
    String? viewAllRoute,
    Map<String, String>? viewAllParams,
    bool isTop10 = false,
  }) {
    if (items.isEmpty) return const SizedBox.shrink();

    return MediaHorizontalList(
      title: title,
      items: items,
      viewAllRoute: viewAllRoute,
      viewAllParams: viewAllParams,
      heroTagPrefix: 'home',
      isTop10: isTop10,
    );
  }

  /// Netflix logo widget for app bar
  Widget _buildNetflixLogo() {
    return Text(
      'LET\'S STREAM',
      style: GoogleFonts.bebasNeue(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: NetflixColors.primaryRed,
        letterSpacing: 1.5,
      ),
    );
  }

  /// Netflix-style category chips for app bar
  Widget _buildCategoryChips() {
    final categories = ['TV Shows', 'Movies', 'Categories'];
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: categories.map((category) {
        return Padding(
          padding: const EdgeInsets.only(right: 16),
          child: TextButton(
            onPressed: () {
              // Navigate to category
              if (category == 'TV Shows') {
                context.pushNamed('tv-list', pathParameters: {'feed': 'popular'});
              } else if (category == 'Movies') {
                context.pushNamed('movies-list', pathParameters: {'feed': 'popular'});
              } else if (category == 'Categories') {
                context.pushNamed('hub');
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: NetflixColors.textPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              category,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: NetflixColors.textPrimary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _HomeScreenLoading extends StatelessWidget {
  const _HomeScreenLoading();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Hero shimmer
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 500,
            child: ShimmerBox(width: double.infinity, height: 500),
          ),
        ),
        // Section shimmers
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _buildSectionShimmer(context),
            childCount: 4,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionShimmer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title shimmer with blue accent
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                ShimmerBox(
                  width: 150,
                  height: 24,
                ),
                SizedBox(width: 8),
                ShimmerBox(
                  width: 20,
                  height: 3,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Cards shimmer
          SizedBox(
            height: 220,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, __) => const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: 120, height: 180),
                  SizedBox(height: 8),
                  ShimmerBox(width: 100, height: 14),
                ],
              ),
            ),
          ),
        ],
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

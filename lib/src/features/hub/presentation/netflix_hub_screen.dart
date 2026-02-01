import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/models/movie.dart';
import '../../../core/models/tv_show.dart';
import '../../../shared/widgets/shimmer_box.dart';
import '../../../shared/widgets/desktop_scroll_wrapper.dart';
import '../../home/presentation/widgets/continue_watching_section.dart';
import '../application/hub_notifier.dart';
import '../../../shared/theme/netflix_colors.dart';
import '../../../shared/theme/netflix_typography.dart';
import 'package:google_fonts/google_fonts.dart';

/// Netflix-style Hub Screen with immersive dark UI.
/// Features:
/// - Hero banner with featured content at top
/// - Minimal dark app bar that fades in on scroll
/// - Netflix-style horizontal rows with clean headers
/// - Movies/TV Shows tabs with smooth transitions
/// - Continue watching section prominently displayed
/// - Genre and platform-based content organization
/// - Browse/Categories grid with large tiles
class NetflixHubScreen extends ConsumerStatefulWidget {
  const NetflixHubScreen({super.key});

  @override
  ConsumerState<NetflixHubScreen> createState() => _NetflixHubScreenState();
}

class _NetflixHubScreenState extends ConsumerState<NetflixHubScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _moviesScrollController = ScrollController();
  final ScrollController _tvScrollController = ScrollController();
  final ScrollController _browseScrollController = ScrollController();
  final ValueNotifier<double> _appBarOpacity = ValueNotifier(0.0);
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
    _browseScrollController.addListener(_onBrowseScroll);
  }

  void _onTabChanged() {
    setState(() => _currentTab = _tabController.index);
    // Reset scroll positions when switching tabs
    if (_tabController.index == 0) {
      _tvScrollController.jumpTo(0);
      _browseScrollController.jumpTo(0);
    } else if (_tabController.index == 1) {
      _moviesScrollController.jumpTo(0);
      _browseScrollController.jumpTo(0);
    } else {
      _moviesScrollController.jumpTo(0);
      _tvScrollController.jumpTo(0);
    }
  }

  void _onBrowseScroll() {
    final offset = _browseScrollController.offset;
    final opacity = (offset / 200).clamp(0.0, 1.0);
    _appBarOpacity.value = opacity;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _moviesScrollController.dispose();
    _tvScrollController.dispose();
    _browseScrollController.dispose();
    _appBarOpacity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hubState = ref.watch(hubNotifierProvider);

    return Scaffold(
      backgroundColor: NetflixColors.backgroundBlack,
      extendBodyBehindAppBar: true,
      appBar: _buildNetflixAppBar(),
      body: hubState.isLoading
          ? const _NetflixLoadingScreen()
          : TabBarView(
              controller: _tabController,
              children: [
                _NetflixMoviesTab(
                  state: hubState,
                  scrollController: _moviesScrollController,
                  appBarOpacity: _appBarOpacity,
                ),
                _NetflixTvTab(
                  state: hubState,
                  scrollController: _tvScrollController,
                  appBarOpacity: _appBarOpacity,
                ),
                _NetflixBrowseTab(
                  state: hubState,
                  scrollController: _browseScrollController,
                ),
              ],
            ),
    );
  }

  PreferredSizeWidget _buildNetflixAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: ValueListenableBuilder<double>(
        valueListenable: _appBarOpacity,
        builder: (context, opacity, child) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            color: NetflixColors.backgroundBlack.withValues(alpha: opacity),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                _currentTab == 0
                    ? 'MOVIES'
                    : _currentTab == 1
                        ? 'TV SHOWS'
                        : 'BROWSE',
                style: GoogleFonts.bebasNeue(
                  fontSize: 20,
                  color: NetflixColors.textPrimary,
                  letterSpacing: 1.5,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () => context.pushNamed('search'),
                  icon: const Icon(Icons.search, color: NetflixColors.textPrimary),
                ),
                IconButton(
                  onPressed: () => _showPersonalizationDialog(context),
                  icon: const Icon(Icons.person_outline, color: NetflixColors.textPrimary),
                ),
                const SizedBox(width: 8),
              ],
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: NetflixColors.primaryRed,
                indicatorWeight: 3,
                labelColor: NetflixColors.textPrimary,
                unselectedLabelColor: NetflixColors.textSecondary,
                labelStyle: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                unselectedLabelStyle: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                tabs: const [
                  Tab(text: 'Movies'),
                  Tab(text: 'TV Shows'),
                  Tab(text: 'Browse'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showPersonalizationDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: NetflixColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const _PersonalizationBottomSheet(),
    );
  }
}

/// Netflix-style Movies Tab with hero and rows
class _NetflixMoviesTab extends StatefulWidget {
  final HubState state;
  final ScrollController scrollController;
  final ValueNotifier<double> appBarOpacity;

  const _NetflixMoviesTab({
    required this.state,
    required this.scrollController,
    required this.appBarOpacity,
  });

  @override
  State<_NetflixMoviesTab> createState() => _NetflixMoviesTabState();
}

class _NetflixMoviesTabState extends State<_NetflixMoviesTab> {
  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = widget.scrollController.offset;
    final opacity = (offset / 300).clamp(0.0, 1.0);
    widget.appBarOpacity.value = opacity;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _refresh(),
      color: NetflixColors.textPrimary,
      backgroundColor: NetflixColors.surfaceDark,
      child: CustomScrollView(
        controller: widget.scrollController,
        slivers: [
          // Hero Section
          if (widget.state.trendingMovies.isNotEmpty)
            SliverToBoxAdapter(
              child: _NetflixHeroBanner(
                items: widget.state.trendingMovies.take(5).toList(),
              ),
            ),

          // Continue Watching
          const SliverToBoxAdapter(
            child: ContinueWatchingSection(),
          ),

          // Personalized Rows (if enabled)
          if (widget.state.isPersonalizationEnabled) ...[
            if (widget.state.personalizedMovies.isNotEmpty)
              _buildNetflixRow(
                title: 'Recommended for You',
                items: widget.state.personalizedMovies,
                onViewAll: () => context.pushNamed(
                  'movies-list',
                  pathParameters: {'feed': 'recommended'},
                ),
              ),
            if (widget.state.genreBasedMovies.isNotEmpty)
              _buildNetflixRow(
                title: 'Because You Watched',
                items: widget.state.genreBasedMovies,
                onViewAll: () => context.pushNamed(
                  'movies-list',
                  pathParameters: {'feed': 'personalized'},
                ),
              ),
          ],

          // Standard Rows
          _buildNetflixRow(
            title: 'Trending Now',
            items: widget.state.trendingMovies,
            onViewAll: () => context.pushNamed(
              'movies-list',
              pathParameters: {'feed': 'trending'},
            ),
          ),
          _buildNetflixRow(
            title: 'New Releases',
            items: widget.state.nowPlayingMovies,
            onViewAll: () => context.pushNamed(
              'movies-list',
              pathParameters: {'feed': 'now_playing'},
            ),
          ),
          _buildNetflixRow(
            title: 'Popular on Let\'s Stream',
            items: widget.state.popularMovies,
            onViewAll: () => context.pushNamed(
              'movies-list',
              pathParameters: {'feed': 'popular'},
            ),
          ),
          _buildNetflixRow(
            title: 'Critically Acclaimed',
            items: widget.state.topRatedMovies,
            onViewAll: () => context.pushNamed(
              'movies-list',
              pathParameters: {'feed': 'top_rated'},
            ),
          ),

          // Genre Rows
          if (widget.state.actionMovies.isNotEmpty)
            _buildNetflixRow(
              title: 'Action & Adventure',
              items: widget.state.actionMovies,
              onViewAll: () => context.pushNamed(
                'movies-genre',
                pathParameters: {'id': '28'},
                queryParameters: {'name': 'Action'},
              ),
            ),
          if (widget.state.comedyMovies.isNotEmpty)
            _buildNetflixRow(
              title: 'Comedies',
              items: widget.state.comedyMovies,
              onViewAll: () => context.pushNamed(
                'movies-genre',
                pathParameters: {'id': '35'},
                queryParameters: {'name': 'Comedy'},
              ),
            ),
          if (widget.state.dramaMovies.isNotEmpty)
            _buildNetflixRow(
              title: 'Dramas',
              items: widget.state.dramaMovies,
              onViewAll: () => context.pushNamed(
                'movies-genre',
                pathParameters: {'id': '18'},
                queryParameters: {'name': 'Drama'},
              ),
            ),
          if (widget.state.sciFiMovies.isNotEmpty)
            _buildNetflixRow(
              title: 'Sci-Fi & Fantasy',
              items: widget.state.sciFiMovies,
              onViewAll: () => context.pushNamed(
                'movies-genre',
                pathParameters: {'id': '878'},
                queryParameters: {'name': 'Sci-Fi'},
              ),
            ),
          if (widget.state.horrorMovies.isNotEmpty)
            _buildNetflixRow(
              title: 'Horror Movies',
              items: widget.state.horrorMovies,
              onViewAll: () => context.pushNamed(
                'movies-genre',
                pathParameters: {'id': '27'},
                queryParameters: {'name': 'Horror'},
              ),
            ),

          // Platform Rows
          if (widget.state.netflixMovies.isNotEmpty)
            _buildNetflixRow(
              title: 'Only on Netflix',
              items: widget.state.netflixMovies,
              onViewAll: () => context.pushNamed(
                'movies-list',
                pathParameters: {'feed': 'netflix_movies'},
              ),
            ),
          if (widget.state.amazonPrimeMovies.isNotEmpty)
            _buildNetflixRow(
              title: 'Prime Video',
              items: widget.state.amazonPrimeMovies,
              onViewAll: () => context.pushNamed(
                'movies-list',
                pathParameters: {'feed': 'prime_movies'},
              ),
            ),
          if (widget.state.disneyPlusMovies.isNotEmpty)
            _buildNetflixRow(
              title: 'Disney+',
              items: widget.state.disneyPlusMovies,
              onViewAll: () => context.pushNamed(
                'movies-list',
                pathParameters: {'feed': 'disney_movies'},
              ),
            ),

          // Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }

  Future<void> _refresh() async {
    // Access the notifier through context
  }
}

/// Netflix-style TV Shows Tab
class _NetflixTvTab extends StatefulWidget {
  final HubState state;
  final ScrollController scrollController;
  final ValueNotifier<double> appBarOpacity;

  const _NetflixTvTab({
    required this.state,
    required this.scrollController,
    required this.appBarOpacity,
  });

  @override
  State<_NetflixTvTab> createState() => _NetflixTvTabState();
}

class _NetflixTvTabState extends State<_NetflixTvTab> {
  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = widget.scrollController.offset;
    final opacity = (offset / 300).clamp(0.0, 1.0);
    widget.appBarOpacity.value = opacity;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _refresh(),
      color: NetflixColors.textPrimary,
      backgroundColor: NetflixColors.surfaceDark,
      child: CustomScrollView(
        controller: widget.scrollController,
        slivers: [
          // Hero Section
          if (widget.state.trendingTvShows.isNotEmpty)
            SliverToBoxAdapter(
              child: _NetflixHeroBanner(
                items: widget.state.trendingTvShows.take(5).toList(),
                isTv: true,
              ),
            ),

          // Continue Watching
          const SliverToBoxAdapter(
            child: ContinueWatchingSection(),
          ),

          // Personalized Rows
          if (widget.state.isPersonalizationEnabled) ...[
            if (widget.state.personalizedTvShows.isNotEmpty)
              _buildNetflixRow(
                title: 'Recommended for You',
                items: widget.state.personalizedTvShows,
                onViewAll: () => context.pushNamed(
                  'tv-list',
                  pathParameters: {'feed': 'recommended'},
                ),
              ),
            if (widget.state.recommendedTvShows.isNotEmpty)
              _buildNetflixRow(
                title: 'From Your Platforms',
                items: widget.state.recommendedTvShows,
                onViewAll: () => context.pushNamed(
                  'tv-list',
                  pathParameters: {'feed': 'platform_recommended'},
                ),
              ),
          ],

          // Standard Rows
          _buildNetflixRow(
            title: 'Trending Now',
            items: widget.state.trendingTvShows,
            onViewAll: () => context.pushNamed(
              'tv-list',
              pathParameters: {'feed': 'trending'},
            ),
          ),
          _buildNetflixRow(
            title: 'Airing Today',
            items: widget.state.airingTodayTvShows,
            onViewAll: () => context.pushNamed(
              'tv-list',
              pathParameters: {'feed': 'airing_today'},
            ),
          ),
          _buildNetflixRow(
            title: 'Popular Shows',
            items: widget.state.popularTvShows,
            onViewAll: () => context.pushNamed(
              'tv-list',
              pathParameters: {'feed': 'popular'},
            ),
          ),
          _buildNetflixRow(
            title: 'Top Rated',
            items: widget.state.topRatedTvShows,
            onViewAll: () => context.pushNamed(
              'tv-list',
              pathParameters: {'feed': 'top_rated'},
            ),
          ),

          // Genre Rows
          if (widget.state.dramaTvShows.isNotEmpty)
            _buildNetflixRow(
              title: 'TV Dramas',
              items: widget.state.dramaTvShows,
              onViewAll: () => context.pushNamed(
                'tv-genre',
                pathParameters: {'id': '18'},
                queryParameters: {'name': 'Drama'},
              ),
            ),
          if (widget.state.comedyTvShows.isNotEmpty)
            _buildNetflixRow(
              title: 'TV Comedies',
              items: widget.state.comedyTvShows,
              onViewAll: () => context.pushNamed(
                'tv-genre',
                pathParameters: {'id': '35'},
                queryParameters: {'name': 'Comedy'},
              ),
            ),
          if (widget.state.crimeTvShows.isNotEmpty)
            _buildNetflixRow(
              title: 'Crime TV Shows',
              items: widget.state.crimeTvShows,
              onViewAll: () => context.pushNamed(
                'tv-genre',
                pathParameters: {'id': '80'},
                queryParameters: {'name': 'Crime'},
              ),
            ),

          // Platform Rows
          if (widget.state.netflixShows.isNotEmpty)
            _buildNetflixRow(
              title: 'Only on Netflix',
              items: widget.state.netflixShows,
              onViewAll: () => context.pushNamed('tv-netflix'),
            ),
          if (widget.state.amazonPrimeShows.isNotEmpty)
            _buildNetflixRow(
              title: 'Prime Video',
              items: widget.state.amazonPrimeShows,
              onViewAll: () => context.pushNamed('tv-amazon-prime'),
            ),

          // Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }

  Future<void> _refresh() async {
    // Access the notifier through context
  }
}

/// Browse/Categories Tab with large category tiles
class _NetflixBrowseTab extends StatelessWidget {
  final HubState state;
  final ScrollController scrollController;

  const _NetflixBrowseTab({
    required this.state,
    required this.scrollController,
  });

  // Map genre IDs to their respective movie lists in state
  String? _getMovieGenreImage(int genreId) {
    List<dynamic> movies;
    switch (genreId) {
      case 28:
        movies = state.actionMovies;
        break;
      case 12:
        movies = state.adventureMovies;
        break;
      case 35:
        movies = state.comedyMovies;
        break;
      case 80:
        movies = []; // Crime not in state yet
        break;
      case 18:
        movies = state.dramaMovies;
        break;
      case 27:
        movies = state.horrorMovies;
        break;
      case 878:
        movies = state.sciFiMovies;
        break;
      case 53:
        movies = state.thrillerMovies;
        break;
      case 10749:
        movies = state.romanceMovies;
        break;
      default:
        movies = state.trendingMovies;
    }
    
    // Get first movie with a backdrop image
    for (final movie in movies) {
      if (movie.backdropPath != null) {
        return movie.backdropPath;
      }
    }
    return null;
  }

  // Map genre IDs to their respective TV lists in state
  String? _getTvGenreImage(int genreId) {
    List<dynamic> shows;
    switch (genreId) {
      case 18:
        shows = state.dramaTvShows;
        break;
      case 35:
        shows = state.comedyTvShows;
        break;
      case 80:
        shows = state.crimeTvShows;
        break;
      case 10765:
        shows = state.sciFiFantasyTvShows;
        break;
      default:
        shows = state.trendingTvShows;
    }
    
    // Get first show with a backdrop image
    for (final show in shows) {
      if (show.backdropPath != null) {
        return show.backdropPath;
      }
    }
    return null;
  }

  // Movie genres with IDs
  final List<Map<String, dynamic>> _movieGenres = const [
    {'name': 'Action', 'id': 28},
    {'name': 'Adventure', 'id': 12},
    {'name': 'Animation', 'id': 16},
    {'name': 'Comedy', 'id': 35},
    {'name': 'Crime', 'id': 80},
    {'name': 'Documentary', 'id': 99},
    {'name': 'Drama', 'id': 18},
    {'name': 'Family', 'id': 10751},
    {'name': 'Fantasy', 'id': 14},
    {'name': 'History', 'id': 36},
    {'name': 'Horror', 'id': 27},
    {'name': 'Music', 'id': 10402},
    {'name': 'Mystery', 'id': 9648},
    {'name': 'Romance', 'id': 10749},
    {'name': 'Sci-Fi', 'id': 878},
    {'name': 'Thriller', 'id': 53},
  ];

  // TV genres with IDs
  final List<Map<String, dynamic>> _tvGenres = const [
    {'name': 'Action & Adventure', 'id': 10759},
    {'name': 'Animation', 'id': 16},
    {'name': 'Comedy', 'id': 35},
    {'name': 'Crime', 'id': 80},
    {'name': 'Documentary', 'id': 99},
    {'name': 'Drama', 'id': 18},
    {'name': 'Family', 'id': 10751},
    {'name': 'Kids', 'id': 10762},
    {'name': 'Mystery', 'id': 9648},
    {'name': 'Reality', 'id': 10764},
    {'name': 'Sci-Fi & Fantasy', 'id': 10765},
    {'name': 'Talk', 'id': 10767},
  ];

  @override
  Widget build(BuildContext context) {
    // Calculate app bar height to add proper padding
    final appBarHeight = kToolbarHeight + MediaQuery.of(context).padding.top + 48; // 48 for TabBar
    
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        // Safe Area padding for app bar
        SliverToBoxAdapter(
          child: SizedBox(height: appBarHeight),
        ),
        
        // Browse Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Browse by Category',
                  style: NetflixTypography.sectionTitle,
                ),
                const SizedBox(height: 4),
                Text(
                  'Find movies and shows by genre',
                  style: NetflixTypography.textTheme.bodyMedium?.copyWith(
                    color: NetflixColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Movie Genres Section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'MOVIE GENRES',
              style: GoogleFonts.bebasNeue(
                fontSize: 20,
                color: NetflixColors.textPrimary,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ),

        // Movie Categories Grid
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 16 / 9,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final genre = _movieGenres[index];
                final genreId = genre['id'] as int;
                final imagePath = _getMovieGenreImage(genreId);
                return _CategoryTile(
                  title: genre['name'] as String,
                  imagePath: imagePath,
                  onTap: () {
                    context.pushNamed(
                      'movies-genre',
                      pathParameters: {'id': genreId.toString()},
                      queryParameters: {'name': genre['name'] as String},
                    );
                  },
                );
              },
              childCount: _movieGenres.length,
            ),
          ),
        ),

        // TV Genres Section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 8),
            child: Text(
              'TV SHOW GENRES',
              style: GoogleFonts.bebasNeue(
                fontSize: 20,
                color: NetflixColors.textPrimary,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ),

        // TV Categories Grid
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 16 / 9,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final genre = _tvGenres[index];
                final genreId = genre['id'] as int;
                final imagePath = _getTvGenreImage(genreId);
                return _CategoryTile(
                  title: genre['name'] as String,
                  imagePath: imagePath,
                  onTap: () {
                    context.pushNamed(
                      'tv-genre',
                      pathParameters: {'id': genreId.toString()},
                      queryParameters: {'name': genre['name'] as String},
                    );
                  },
                );
              },
              childCount: _tvGenres.length,
            ),
          ),
        ),

        // Bottom spacing
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }
}

/// Netflix-style category tile with actual backdrop image
class _CategoryTile extends StatelessWidget {
  final String title;
  final String? imagePath;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.title,
    this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const imageBaseUrl = String.fromEnvironment(
      'TMDB_IMAGE_BASE_URL',
      defaultValue: 'https://image.tmdb.org/t/p',
    );
    final imageUrl = imagePath != null ? '$imageBaseUrl/w500$imagePath' : null;

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          color: NetflixColors.surfaceDark,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image from actual movie/TV show
              if (imageUrl != null)
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    color: NetflixColors.surfaceMedium,
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: NetflixColors.surfaceDark,
                  ),
                )
              else
                Container(
                  color: NetflixColors.surfaceDark,
                ),
              
              // Dark gradient overlay for text readability
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.2),
                      Colors.black.withValues(alpha: 0.6),
                    ],
                  ),
                ),
              ),
              
              // Title centered
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: NetflixColors.textPrimary,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.8),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Helper to build Netflix-style row sliver
Widget _buildNetflixRow({
  required String title,
  required List<dynamic> items,
  required VoidCallback onViewAll,
}) {
  return SliverToBoxAdapter(
    child: _NetflixContentRow(
      title: title,
      items: items,
      onViewAll: onViewAll,
    ),
  );
}

/// Netflix-style hero banner with featured content
class _NetflixHeroBanner extends StatefulWidget {
  final List<dynamic> items;
  final bool isTv;

  const _NetflixHeroBanner({
    required this.items,
    this.isTv = false,
  });

  @override
  State<_NetflixHeroBanner> createState() => _NetflixHeroBannerState();
}

class _NetflixHeroBannerState extends State<_NetflixHeroBanner> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final item = widget.items[_currentIndex];
    final title = widget.isTv ? (item as TvShow).name : (item as Movie).title;
    final overview = widget.isTv ? (item as TvShow).overview : (item as Movie).overview;
    final backdropPath = widget.isTv
        ? (item as TvShow).backdropPath
        : (item as Movie).backdropPath;
    final voteAverage = widget.isTv
        ? (item as TvShow).voteAverage
        : (item as Movie).voteAverage;

    const imageBaseUrl = String.fromEnvironment(
      'TMDB_IMAGE_BASE_URL',
      defaultValue: 'https://image.tmdb.org/t/p',
    );
    final imageUrl = backdropPath != null ? '$imageBaseUrl/original$backdropPath' : null;

    return SizedBox(
      height: 550,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          if (imageUrl != null)
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => const ShimmerBox(
                width: double.infinity,
                height: double.infinity,
              ),
            ),

          // Gradient overlay (Netflix style - heavy bottom gradient)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.0),
                  Colors.black.withValues(alpha: 0.3),
                  Colors.black.withValues(alpha: 0.7),
                  Colors.black.withValues(alpha: 0.95),
                ],
                stops: const [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          ),

          // Content
          Positioned(
            left: 16,
            right: 16,
            bottom: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Featured label
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: NetflixColors.primaryRed,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'FEATURED',
                        style: TextStyle(
                          color: NetflixColors.textPrimary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (voteAverage > 0)
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            voteAverage.toStringAsFixed(1),
                            style: const TextStyle(
                              color: NetflixColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Title
                Text(
                  title,
                  style: GoogleFonts.bebasNeue(
                    fontSize: 48,
                    color: NetflixColors.textPrimary,
                    letterSpacing: 1.0,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Overview
                Text(
                  overview,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: NetflixColors.textSecondary,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 20),

                // Action buttons (Netflix style)
                Row(
                  children: [
                    // Play button
                    ElevatedButton.icon(
                      onPressed: () => _playFeatured(item),
                      icon: const Icon(Icons.play_arrow, size: 28),
                      label: Text(
                        'Play',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NetflixColors.textPrimary,
                        foregroundColor: NetflixColors.backgroundBlack,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // More Info button
                    ElevatedButton.icon(
                      onPressed: () => _showDetails(item),
                      icon: const Icon(Icons.info_outline, size: 24),
                      label: Text(
                        'More Info',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NetflixColors.surfaceMedium,
                        foregroundColor: NetflixColors.textPrimary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Carousel indicators
          if (widget.items.length > 1)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.items.asMap().entries.map((entry) {
                  final isActive = entry.key == _currentIndex;
                  return GestureDetector(
                    onTap: () => setState(() => _currentIndex = entry.key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: isActive ? 24 : 8,
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: isActive
                            ? NetflixColors.textPrimary
                            : NetflixColors.textSecondary.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  void _playFeatured(dynamic item) {
    // Navigate to player
  }

  void _showDetails(dynamic item) {
    // Navigate to detail screen
  }
}

/// Netflix-style content row
class _NetflixContentRow extends StatefulWidget {
  final String title;
  final List<dynamic> items;
  final VoidCallback onViewAll;

  const _NetflixContentRow({
    required this.title,
    required this.items,
    required this.onViewAll,
  });

  @override
  State<_NetflixContentRow> createState() => _NetflixContentRowState();
}

class _NetflixContentRowState extends State<_NetflixContentRow> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title row
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: NetflixTypography.sectionTitle,
                ),
              ),
              // Explore all link
              TextButton(
                onPressed: widget.onViewAll,
                style: TextButton.styleFrom(
                  foregroundColor: NetflixColors.textSecondary,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Explore All',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: NetflixColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: NetflixColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Horizontal list
        SizedBox(
          height: 160,
          child: DesktopScrollWrapper(
            controller: _scrollController,
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: widget.items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final item = widget.items[index];
                return _NetflixCard(item: item);
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// Netflix-style poster card
class _NetflixCard extends StatelessWidget {
  final dynamic item;

  const _NetflixCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final imagePath = item is Movie
        ? (item as Movie).posterPath
        : (item as TvShow).posterPath;
    final imageBaseUrl = const String.fromEnvironment(
      'TMDB_IMAGE_BASE_URL',
      defaultValue: 'https://image.tmdb.org/t/p',
    );
    final imageUrl = imagePath != null ? '$imageBaseUrl/w342$imagePath' : null;

    return GestureDetector(
      onTap: () => _navigateToDetail(context, item),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          width: 110,
          height: 160,
          color: NetflixColors.surfaceDark,
          child: imageUrl != null
              ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => const ShimmerBox(
                    width: 110,
                    height: 160,
                    borderRadius: BorderRadius.zero,
                  ),
                  errorWidget: (_, __, ___) => const Center(
                    child: Icon(Icons.image_not_supported, color: NetflixColors.textSecondary),
                  ),
                )
              : const Center(
                  child: Icon(Icons.movie, color: NetflixColors.textSecondary),
                ),
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context, dynamic item) {
    if (item is Movie) {
      context.pushNamed(
        'movie-detail',
        pathParameters: {'id': item.id.toString()},
        extra: item,
      );
    } else {
      context.pushNamed(
        'tv-detail',
        pathParameters: {'id': (item as TvShow).id.toString()},
        extra: item,
      );
    }
  }
}

/// Netflix-style loading screen
class _NetflixLoadingScreen extends StatelessWidget {
  const _NetflixLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: NetflixColors.primaryRed,
            strokeWidth: 3,
          ),
          SizedBox(height: 16),
          Text(
            'Loading...',
            style: TextStyle(
              color: NetflixColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

/// Netflix-style personalization bottom sheet
class _PersonalizationBottomSheet extends ConsumerWidget {
  const _PersonalizationBottomSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hubState = ref.watch(hubNotifierProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                'Personalize Your Experience',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: NetflixColors.textPrimary,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: NetflixColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Enable/Disable toggle
          SwitchListTile(
            title: Text(
              'Enable Personalization',
              style: GoogleFonts.inter(
                color: NetflixColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              'Get recommendations based on your preferences',
              style: GoogleFonts.inter(
                color: NetflixColors.textSecondary,
                fontSize: 12,
              ),
            ),
            value: hubState.isPersonalizationEnabled,
            onChanged: (value) {
              // TODO: Toggle personalization
            },
            activeThumbColor: NetflixColors.primaryRed,
          ),

          const SizedBox(height: 20),
          Text(
            'Preferred Genres',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: NetflixColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          // Genre chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: hubState.movieGenres.entries.map((entry) {
              final isSelected = hubState.userPreferredGenres.contains(entry.key);
              return FilterChip(
                label: Text(entry.value),
                selected: isSelected,
                onSelected: (_) {
                  // TODO: Toggle genre selection
                },
                selectedColor: NetflixColors.primaryRed.withValues(alpha: 0.3),
                checkmarkColor: NetflixColors.primaryRed,
                labelStyle: TextStyle(
                  color: isSelected ? NetflixColors.textPrimary : NetflixColors.textSecondary,
                ),
                backgroundColor: NetflixColors.surfaceMedium,
              );
            }).toList(),
          ),

          const SizedBox(height: 20),
          Text(
            'Preferred Platforms',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: NetflixColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          // Platform chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Netflix',
              'Prime Video',
              'Disney+',
              'Hulu',
              'HBO Max',
              'Apple TV+',
            ].map((platform) {
              final isSelected = hubState.userPreferredPlatforms.contains(platform);
              return FilterChip(
                label: Text(platform),
                selected: isSelected,
                onSelected: (_) {
                  // TODO: Toggle platform selection
                },
                selectedColor: NetflixColors.primaryRed.withValues(alpha: 0.3),
                checkmarkColor: NetflixColors.primaryRed,
                labelStyle: TextStyle(
                  color: isSelected ? NetflixColors.textPrimary : NetflixColors.textSecondary,
                ),
                backgroundColor: NetflixColors.surfaceMedium,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

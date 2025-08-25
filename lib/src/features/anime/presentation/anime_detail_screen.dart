import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';
import 'package:lets_stream/src/core/models/video.dart';
import 'package:lets_stream/src/core/services/tmdb_repository_provider.dart';
import 'package:lets_stream/src/core/models/cast_member.dart';
import 'package:lets_stream/src/core/models/season.dart';
import 'package:lets_stream/src/core/models/episode.dart';
import 'package:lets_stream/src/shared/widgets/media_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lets_stream/src/shared/widgets/shimmer_box.dart';
import 'package:go_router/go_router.dart';

class AnimeDetailScreen extends ConsumerStatefulWidget {
  final Object? item; // Movie or TvShow

  const AnimeDetailScreen({super.key, required this.item});

  @override
  ConsumerState<AnimeDetailScreen> createState() => _AnimeDetailScreenState();
}

class _SeasonEpisodesView extends ConsumerStatefulWidget {
  final int tvId;
  final List<SeasonSummary> seasons;
  final int initialSeason;
  const _SeasonEpisodesView({
    required this.tvId,
    required this.seasons,
    required this.initialSeason,
  });
  @override
  ConsumerState<_SeasonEpisodesView> createState() => _SeasonEpisodesViewState();
}

class _SeasonEpisodesViewState extends ConsumerState<_SeasonEpisodesView> {
  late int _seasonNumber;
  List<EpisodeSummary>? _episodes;
  bool _loading = false;
  String? _error;

  Color _ratingColor(double rating) {
    if (rating >= 8.0) return Colors.green;
    if (rating >= 6.0) return Colors.orange;
    return Colors.red;
  }

  @override
  void initState() {
    super.initState();
    _seasonNumber = widget.initialSeason;
    _fetchEpisodes();
  }

  Future<void> _fetchEpisodes() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = ref.read(tmdbRepositoryProvider);
      final episodes = await repo.getSeasonEpisodes(widget.tvId, _seasonNumber);
      setState(() => _episodes = episodes);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String imageBaseUrl = dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.animation_outlined,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Episodes',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Season selector as modern chips
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.seasons.length,
            itemBuilder: (context, index) {
              final season = widget.seasons[index];
              final isSelected = season.seasonNumber == _seasonNumber;
              return Padding(
                padding: EdgeInsets.only(
                  right: 8,
                  left: index == 0 ? 0 : 0,
                ),
                child: FilterChip(
                  label: Text(
                    season.name.isNotEmpty 
                        ? season.name 
                        : 'Season ${season.seasonNumber}',
                    style: isSelected 
                        ? TextStyle(color: Theme.of(context).colorScheme.onPrimary)
                        : null,
                  ),
                  selected: isSelected,
                  onSelected: (sel) {
                    setState(() => _seasonNumber = season.seasonNumber);
                    _fetchEpisodes();
                  },
                  selectedColor: Theme.of(context).colorScheme.primary,
                  showCheckmark: false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        if (_loading)
          Column(
            children: List.generate(3, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: const ShimmerBox(width: 120, height: 68),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ShimmerBox(width: 100, height: 16),
                          const SizedBox(height: 8),
                          const ShimmerBox(width: double.infinity, height: 14),
                          const SizedBox(height: 4),
                          const ShimmerBox(width: 150, height: 14),
                        ],
                      ),
                    ),
                  ],
                ).animate(delay: Duration(milliseconds: 100 * index)).fadeIn(),
              );
            }),
          )
        else if (_error != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Failed to load episodes: $_error',
              style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
            ),
          )
        else if ((_episodes?.isEmpty ?? true))
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'No episodes available',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _episodes!.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final ep = _episodes![i];
              final thumb = ep.stillPath != null && ep.stillPath!.isNotEmpty
                  ? '$imageBaseUrl/w300${ep.stillPath}'
                  : null;
              
              return Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    context.pushNamed(
                      'episode-detail',
                      pathParameters: {
                        'id': widget.tvId.toString(),
                        'season': _seasonNumber.toString(),
                        'ep': ep.episodeNumber.toString(),
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Episode thumbnail
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 120,
                            height: 68,
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            child: thumb != null
                                ? Image.network(
                                    thumb,
                                    width: 120,
                                    height: 68,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const ShimmerBox(width: 120, height: 68);
                                    },
                                    errorBuilder: (context, error, stackTrace) => 
                                        const Icon(Icons.broken_image_outlined, size: 24),
                                  )
                                : const Icon(Icons.movie_outlined, size: 24),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Episode details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Episode title and number
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primaryContainer,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${ep.episodeNumber}',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      ep.name,
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              // Episode air date
                              if (ep.airDate != null) ...[
                                Text(
                                  ep.airDate!.toLocal().toIso8601String().split('T').first,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      ),
                                ),
                                const SizedBox(height: 4),
                              ],
                              // Episode rating
                              if (ep.voteAverage > 0) ...[
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 16,
                                      color: _ratingColor(ep.voteAverage),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      ep.voteAverage.toStringAsFixed(1),
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                              ],
                              // Episode overview
                              if (ep.overview != null && ep.overview!.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  ep.overview!,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                        height: 1.4,
                                      ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

class _AnimeDetailScreenState extends ConsumerState<AnimeDetailScreen>
    with TickerProviderStateMixin {
  late final AnimationController _backgroundController;
  late final AnimationController _contentController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scrollController = ScrollController();
    
    // Start animations
    _backgroundController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _contentController.forward();
    });
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _contentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String imageBaseUrl = dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';

    String title;
    String overview;
    String? posterPath;
    String? backdropPath;
    String subtitle;
    double voteAverage;
    int id;

    if (widget.item is Movie) {
      final m = widget.item as Movie;
      title = m.title;
      overview = m.overview;
      posterPath = m.posterPath;
      backdropPath = m.backdropPath;
      id = m.id;
      final date = m.releaseDate?.toLocal().toIso8601String().split('T').first;
      subtitle = date != null ? 'Release: $date' : '';
      voteAverage = m.voteAverage;
    } else if (widget.item is TvShow) {
      final t = widget.item as TvShow;
      title = t.name;
      overview = t.overview;
      posterPath = t.posterPath;
      backdropPath = t.backdropPath;
      id = t.id;
      final date = t.firstAirDate?.toLocal().toIso8601String().split('T').first;
      subtitle = date != null ? 'First air: $date' : '';
      voteAverage = t.voteAverage;
    } else {
      title = 'Details';
      overview = 'Unknown item type';
      posterPath = null;
      backdropPath = null;
      subtitle = '';
      voteAverage = 0.0;
      id = 0;
    }

    final fullPosterUrl = (posterPath != null && posterPath.isNotEmpty)
        ? '$imageBaseUrl/w500$posterPath'
        : null;

    final backdropUrl = (backdropPath != null && backdropPath.isNotEmpty)
        ? '$imageBaseUrl/w1280$backdropPath'
        : null;

    final repo = ref.read(tmdbRepositoryProvider);

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Custom App Bar with backdrop
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Backdrop image with parallax effect
                  if (backdropUrl != null)
                    AnimatedBuilder(
                      animation: _backgroundController,
                      builder: (context, child) => Transform.scale(
                        scale: 1.0 + (0.15 * _backgroundController.value),
                        child: CachedNetworkImage(
                          imageUrl: backdropUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const ShimmerBox(
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            child: const Icon(Icons.broken_image_outlined, size: 50),
                          ),
                        ),
                      ),
                    ),
                  // Gradient overlay for better text readability
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.6),
                          Colors.black.withValues(alpha: 0.3),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.1),
                          Colors.black.withValues(alpha: 0.7),
                        ],
                        stops: const [0.0, 0.2, 0.4, 0.8, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
              title: AnimatedBuilder(
                animation: _contentController,
                builder: (context, child) => Opacity(
                  opacity: _contentController.value,
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: const Offset(0, 1),
                              blurRadius: 3,
                              color: Colors.black.withValues(alpha: 0.5),
                            ),
                          ],
                        ),
                  ),
                ),
              ),
              centerTitle: true,
            ),
          ),
          
          // Content
          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: _contentController,
              builder: (context, child) => Transform.translate(
                offset: Offset(0, 20 * (1 - _contentController.value)),
                child: Opacity(
                  opacity: _contentController.value,
                  child: child,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero poster with floating effect
                    if (fullPosterUrl != null) ...[
                      Center(
                        child: Hero(
                          tag: 'poster_$id',
                          child: Material(
                            elevation: 8,
                            borderRadius: BorderRadius.circular(16),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                width: 180,
                                height: 270,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: fullPosterUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const ShimmerBox(
                                    width: 180,
                                    height: 270,
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                    child: const Icon(Icons.broken_image_outlined),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    
                    // Title and metadata in a clean card
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            if (subtitle.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    widget.item is Movie ? Icons.calendar_today : Icons.tv,
                                    size: 16,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    subtitle,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: 12),
                            
                            // Rating with modern design
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    voteAverage.toStringAsFixed(1),
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '/10',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Overview section with modern styling
                    _buildSection(
                      context,
                      'Overview',
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            overview,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  height: 1.6,
                                ),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Enhanced Trailers Section
                    _buildTrailersSection(context, repo, id),
                    
                    const SizedBox(height: 32),
                    
                    // Enhanced Cast Section
                    _buildCastSection(context, repo, id),
                    
                    const SizedBox(height: 32),
                    
                    // Seasons & Episodes (TV only) - Anime specific styling
                    if (widget.item is TvShow) ...[
                      _buildSeasonsSection(context, id),
                      const SizedBox(height: 32),
                    ],

                    // Enhanced Similar Section
                    _buildSimilarSection(context, repo, id),
                    
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeasonsSection(BuildContext context, int tvId) {
    final repo = ref.read(tmdbRepositoryProvider);
    return FutureBuilder<List<SeasonSummary>>(
      future: repo.getTvSeasons(tvId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Row(
            children: List.generate(3, (i) => const ShimmerBox(width: 100, height: 32))
                .animate()
                .fadeIn(),
          );
        }
        if (snapshot.hasError || (snapshot.data?.isEmpty ?? true)) {
          return const SizedBox.shrink();
        }
        final seasons = snapshot.data!;
        int selectedSeason = seasons.last.seasonNumber; // default to latest season
        return _SeasonEpisodesView(
          tvId: tvId,
          seasons: seasons,
          initialSeason: selectedSeason,
        );
      },
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getSectionIcon(title),
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        content,
      ],
    );
  }

  IconData _getSectionIcon(String title) {
    switch (title) {
      case 'Overview':
        return Icons.info_outline;
      case 'Trailers & Videos':
        return Icons.play_circle_outline;
      case 'Top Billed Cast':
        return Icons.people_outline;
      case 'More Like This':
        return Icons.recommend_outlined;
      default:
        return Icons.info_outline;
    }
  }

  Widget _buildTrailersSection(BuildContext context, repo, int id) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.play_circle_outline,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Trailers & Videos',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: FutureBuilder<List<Video>>(
            future: widget.item is Movie
                ? repo.getMovieVideos(id)
                : widget.item is TvShow
                    ? repo.getTvVideos(id)
                    : Future.value(const []),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: ShimmerBox(
                      width: 200,
                      height: 140,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                );
              }
              
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Theme.of(context).colorScheme.error,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Failed to load videos',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                );
              }
              
              final videos = (snapshot.data ?? const <Video>[])
                  .where((v) => v.site.toLowerCase() == 'youtube')
                  .toList();
              
              if (videos.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.video_library_outlined,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No trailers available',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              }
              
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  final video = videos[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _buildTrailerCard(context, video)
                        .animate(delay: Duration(milliseconds: 100 * index))
                        .slideX(begin: 0.2, duration: const Duration(milliseconds: 300))
                        .fadeIn(),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTrailerCard(BuildContext context, Video video) {
    final thumbUrl = 'https://img.youtube.com/vi/${video.key}/mqdefault.jpg';
    
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          final url = Uri.parse('https://www.youtube.com/watch?v=${video.key}');
          await launchUrl(url, mode: LaunchMode.externalApplication);
        },
        child: Container(
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: thumbUrl,
                      width: 200,
                      height: 112,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const ShimmerBox(
                        width: 200,
                        height: 112,
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 200,
                        height: 112,
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        child: const Icon(Icons.broken_image_outlined),
                      ),
                    ),
                    // Play button overlay
                    Positioned.fill(
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  video.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCastSection(BuildContext context, repo, int id) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.people_outline,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Top Billed Cast',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: FutureBuilder<List<CastMember>>(
            future: widget.item is Movie
                ? repo.getMovieCast(id)
                : widget.item is TvShow
                    ? repo.getTvCast(id)
                    : Future.value(const []),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Column(
                      children: [
                        ShimmerBox(
                          width: 90,
                          height: 90,
                          borderRadius: BorderRadius.circular(45),
                        ),
                        const SizedBox(height: 8),
                        const ShimmerBox(width: 80, height: 12),
                        const SizedBox(height: 4),
                        const ShimmerBox(width: 60, height: 12),
                      ],
                    ),
                  ),
                );
              }
              
              if (snapshot.hasError) {
                return const Center(child: Text('Failed to load cast'));
              }
              
              final cast = snapshot.data ?? const <CastMember>[];
              if (cast.isEmpty) {
                return const Center(child: Text('No cast available'));
              }
              
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: cast.length,
                itemBuilder: (context, index) {
                  final member = cast[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _buildCastCard(context, member)
                        .animate(delay: Duration(milliseconds: 100 * index))
                        .slideY(begin: 0.2, duration: const Duration(milliseconds: 300))
                        .fadeIn(),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCastCard(BuildContext context, CastMember member) {
    final String imageBaseUrl = dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';
    final imageUrl = (member.profilePath != null && member.profilePath!.isNotEmpty)
        ? '$imageBaseUrl/w185${member.profilePath}'
        : null;

    return SizedBox(
      width: 100,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 45,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
              child: imageUrl == null
                  ? Icon(
                      Icons.person_outline,
                      size: 32,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            member.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 4),
          if (member.character != null && member.character!.isNotEmpty)
            Text(
              member.character!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
        ],
      ),
    );
  }

  Widget _buildSimilarSection(BuildContext context, repo, int id) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.recommend_outlined,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'More Like This',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: FutureBuilder<List<dynamic>>(
            future: widget.item is Movie
                ? repo.getSimilarMovies(id)
                : widget.item is TvShow
                    ? repo.getSimilarTvShows(id)
                    : Future.value(const []),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: ShimmerBox(
                      width: 130,
                      height: 200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                );
              }
              
              if (snapshot.hasError) {
                return const Center(child: Text('Failed to load similar content'));
              }
              
              final items = snapshot.data ?? const [];
              if (items.isEmpty) {
                return const Center(child: Text('No similar titles available'));
              }
              
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _buildSimilarCard(context, item)
                        .animate(delay: Duration(milliseconds: 100 * index))
                        .slideX(begin: 0.2, duration: const Duration(milliseconds: 300))
                        .fadeIn(),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSimilarCard(BuildContext context, dynamic item) {
    if (item is Movie) {
      return MediaCard(
        title: item.title,
        imagePath: item.posterPath,
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  AnimeDetailScreen(item: item),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration: const Duration(milliseconds: 300),
            ),
          );
        },
      );
    } else if (item is TvShow) {
      return MediaCard(
        title: item.name,
        imagePath: item.posterPath,
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  AnimeDetailScreen(item: item),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration: const Duration(milliseconds: 300),
            ),
          );
        },
      );
    }
    return const SizedBox.shrink();
  }
}
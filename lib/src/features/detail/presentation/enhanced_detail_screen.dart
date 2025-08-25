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

class EnhancedDetailScreen extends ConsumerStatefulWidget {
  final Object? item; // Movie or TvShow

  const EnhancedDetailScreen({super.key, required this.item});

  @override
  ConsumerState<EnhancedDetailScreen> createState() => _EnhancedDetailScreenState();
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
            Icon(Icons.tv_outlined, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              'Seasons',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: widget.seasons.map((s) {
              final isSelected = s.seasonNumber == _seasonNumber;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(
                    '${(s.name.isNotEmpty ? s.name : 'Season ${s.seasonNumber}')}${s.episodeCount > 0 ? ' (${s.episodeCount} eps)' : ''}',
                  ),
                  selected: isSelected,
                  onSelected: (sel) {
                    setState(() => _seasonNumber = s.seasonNumber);
                    _fetchEpisodes();
                  },
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        if (_loading)
          Column(
            children: List.generate(4, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: const ShimmerBox(width: 100, height: 56),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          ShimmerBox(width: double.infinity, height: 14),
                          SizedBox(height: 8),
                          ShimmerBox(width: 200, height: 12),
                        ],
                      ),
                    ),
                  ],
                ).animate(delay: Duration(milliseconds: 100 * index)).fadeIn(),
              );
            }),
          )
        else if (_error != null)
          Text('Failed to load episodes: $_error')
        else if ((_episodes?.isEmpty ?? true))
          const Text('No episodes available')
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _episodes!.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final ep = _episodes![i];
              final thumb = ep.stillPath != null && ep.stillPath!.isNotEmpty
                  ? '$imageBaseUrl/w300${ep.stillPath}'
                  : null;
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      children: [
                        thumb != null
                            ? Image.network(thumb, width: 120, height: 68, fit: BoxFit.cover)
                            : Container(
                                width: 120,
                                height: 68,
                                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                child: const Icon(Icons.broken_image_outlined),
                              ),
                        Positioned(
                          top: 6,
                          left: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: _ratingColor(ep.voteAverage).withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star, size: 12, color: Colors.white),
                                const SizedBox(width: 3),
                                Text(
                                  ep.voteAverage.toStringAsFixed(1),
                                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  title: Text(
                    '${ep.episodeNumber}. ${ep.name}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    (ep.overview?.isNotEmpty ?? false) ? ep.overview! : 'No overview',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  children: [
                    const SizedBox(height: 8),
                    if (ep.overview != null && ep.overview!.isNotEmpty)
                      Text(
                        ep.overview!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
                      )
                    else
                      Text(
                        'No overview available.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                        const SizedBox(width: 6),
                        Text(
                          ep.airDate != null
                              ? ep.airDate!.toLocal().toIso8601String().split('T').first
                              : 'Unknown air date',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () {
                            context.pushNamed(
                              'episode-detail',
                              pathParameters: {
                                'id': widget.tvId.toString(),
                                'season': _seasonNumber.toString(),
                                'ep': ep.episodeNumber.toString(),
                              },
                            );
                          },
                          icon: const Icon(Icons.open_in_new),
                          label: const Text('Open details'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}

class _EnhancedDetailScreenState extends ConsumerState<EnhancedDetailScreen>
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
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Backdrop image
                  if (backdropUrl != null)
                    AnimatedBuilder(
                      animation: _backgroundController,
                      builder: (context, child) => Transform.scale(
                        scale: 1.0 + (0.1 * _backgroundController.value),
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
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.3),
                          Colors.black.withValues(alpha: 0.8),
                        ],
                        stops: const [0.0, 0.6, 1.0],
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
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
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
                    // Title and poster row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Poster
                        if (fullPosterUrl != null)
                          Hero(
                            tag: 'poster_$id',
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: SizedBox(
                                width: 120,
                                height: 180,
                                child: CachedNetworkImage(
                                  imageUrl: fullPosterUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const ShimmerBox(
                                    width: 120,
                                    height: 180,
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                    child: const Icon(Icons.broken_image_outlined),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(width: 16),
                        
                        // Title and metadata
                        Expanded(
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
                                Text(
                                  subtitle,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 12),
                              
                              // Rating with animated stars
                              Row(
                                children: [
                                  ...List.generate(5, (index) {
                                    final filled = index < (voteAverage / 2).floor();
                                    return AnimatedContainer(
                                      duration: Duration(milliseconds: 200 + (index * 100)),
                                      child: Icon(
                                        filled ? Icons.star : Icons.star_outline,
                                        color: filled ? Colors.amber : Colors.grey,
                                        size: 20,
                                      ),
                                    ).animate(delay: Duration(milliseconds: 100 * index))
                                      .scale(begin: const Offset(0, 0), duration: 200.ms)
                                      .fadeIn();
                                  }),
                                  const SizedBox(width: 8),
                                  Text(
                                    voteAverage.toStringAsFixed(1),
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Overview
                    _buildSection(
                      context,
                      'Overview',
                      Text(
                        overview,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.6,
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
                    
                    // Seasons & Episodes (TV only)
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
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        content,
      ],
    );
  }

  Widget _buildTrailersSection(BuildContext context, repo, int id) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.play_circle_outline,
              color: Theme.of(context).colorScheme.primary,
              size: 28,
            ),
            const SizedBox(width: 8),
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
          height: 140,
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
                      height: 120,
                      borderRadius: BorderRadius.circular(12),
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
                        .slideX(begin: 0.2, duration: 300.ms)
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
    final thumbUrl = 'https://img.youtube.com/vi/${video.key}/maxresdefault.jpg';
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          final url = Uri.parse('https://www.youtube.com/watch?v=${video.key}');
          await launchUrl(url, mode: LaunchMode.externalApplication);
        },
        child: Container(
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
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
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(8),
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
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  video.name,
                  maxLines: 1,
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
            Icon(
              Icons.people_outline,
              color: Theme.of(context).colorScheme.primary,
              size: 28,
            ),
            const SizedBox(width: 8),
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
          height: 180,
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
                          width: 80,
                          height: 80,
                          borderRadius: BorderRadius.circular(40),
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
                        .slideY(begin: 0.2, duration: 300.ms)
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
      width: 110,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 40,
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
            Icon(
              Icons.recommend_outlined,
              color: Theme.of(context).colorScheme.primary,
              size: 28,
            ),
            const SizedBox(width: 8),
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
          height: 200,
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
                      width: 120,
                      height: 180,
                      borderRadius: BorderRadius.circular(12),
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
                        .slideX(begin: 0.2, duration: 300.ms)
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
                  EnhancedDetailScreen(item: item),
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
                  EnhancedDetailScreen(item: item),
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

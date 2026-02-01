import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/models/movie.dart';
import '../../../core/models/tv_show.dart';
import '../../../core/models/cast_member.dart';
import '../../../core/models/video.dart';
import '../../../core/models/season.dart';
import '../../../shared/widgets/shimmer_box.dart';
import '../../../shared/widgets/desktop_scroll_wrapper.dart';
import '../application/detail_notifier.dart';

/// Netflix-style detail screen for movies and TV shows.
///
/// Features:
/// - Large immersive hero banner with backdrop
/// - Netflix-style action buttons (Play, Add to List, Rate, Share)
/// - Metadata row with year, duration, genres, rating
/// - Expandable synopsis
/// - Horizontal cast list with large avatars
/// - Episodes carousel for TV shows
/// - Multiple "More Like This" sections
/// - Dark Netflix theme throughout
class NetflixDetailScreen extends ConsumerStatefulWidget {
  final Movie? movie;
  final TvShow? tvShow;

  const NetflixDetailScreen({
    super.key,
    this.movie,
    this.tvShow,
  }) : assert(movie != null || tvShow != null, 'Must provide either movie or tvShow');

  @override
  ConsumerState<NetflixDetailScreen> createState() => _NetflixDetailScreenState();
}

class _NetflixDetailScreenState extends ConsumerState<NetflixDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _isSynopsisExpanded = ValueNotifier(false);
  final ValueNotifier<double> _appBarOpacity = ValueNotifier(0.0);

  bool get isMovie => widget.movie != null;
  Movie get movie => widget.movie!;
  TvShow get tvShow => widget.tvShow!;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    final opacity = (offset / 300).clamp(0.0, 1.0);
    _appBarOpacity.value = opacity;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _isSynopsisExpanded.dispose();
    _appBarOpacity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detailState = isMovie
        ? ref.watch(detailNotifierProvider(movie.id))
        : ref.watch(detailNotifierProvider(tvShow.id));

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: _buildNetflixAppBar(),
      body: _buildBody(detailState),
    );
  }

  Widget _buildBody(DetailState state) {
    if (state.isLoading) {
      return const _NetflixDetailLoading();
    }

    if (state.error != null) {
      return _NetflixDetailError(error: state.error!);
    }

    return _buildContent(context, state);
  }

  PreferredSizeWidget _buildNetflixAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: ValueListenableBuilder<double>(
        valueListenable: _appBarOpacity,
        builder: (context, opacity, child) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            color: Colors.black.withValues(alpha: opacity),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                onPressed: () => context.pop(),
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search, color: Colors.white),
                ),
                const SizedBox(width: 8),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, DetailState state) {
    final title = isMovie ? movie.title : tvShow.name;
    final overview = isMovie ? movie.overview : tvShow.overview;
    final backdropPath = isMovie ? movie.backdropPath : tvShow.backdropPath;
    final voteAverage = isMovie ? movie.voteAverage : tvShow.voteAverage;
    final releaseDate = isMovie ? movie.releaseDate : tvShow.firstAirDate;

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Hero Banner
        SliverToBoxAdapter(
          child: _NetflixHeroBanner(
            backdropPath: backdropPath,
            title: title,
            overview: overview,
            voteAverage: voteAverage,
            isMovie: isMovie,
            onPlay: () => _playContent(context),
            onAddToList: () => _toggleWatchlist(context),
            onRate: () => _showRatingDialog(context),
            onShare: () => _shareContent(context),
          ),
        ),

        // Metadata & Synopsis
        SliverToBoxAdapter(
          child: _NetflixMetadataSection(
            releaseDate: releaseDate,
            isMovie: isMovie,
            overview: overview,
            isExpandedNotifier: _isSynopsisExpanded,
          ),
        ),

        // Cast Section
        if (state.cast.isNotEmpty)
          _buildCastSliver(state.cast),

        // Episodes Section (TV only)
        if (!isMovie && state.seasons.isNotEmpty)
          _buildEpisodesSliver(state),

        // Trailers Section
        if (state.videos.isNotEmpty)
          _buildTrailersSliver(state.videos),

        // Similar Content
        if (state.similar.isNotEmpty)
          _buildSimilarSliver(state.similar),

        // Bottom spacing
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }

  Widget _buildCastSliver(List<CastMember> cast) {
    return SliverToBoxAdapter(
      child: _NetflixCastSection(cast: cast),
    );
  }

  Widget _buildEpisodesSliver(DetailState state) {
    return SliverToBoxAdapter(
      child: _NetflixEpisodesSection(
        tvShow: tvShow,
        seasons: state.seasons,
      ),
    );
  }

  Widget _buildTrailersSliver(List<Video> videos) {
    return SliverToBoxAdapter(
      child: _NetflixTrailersSection(videos: videos),
    );
  }

  Widget _buildSimilarSliver(List<dynamic> similar) {
    return SliverToBoxAdapter(
      child: _NetflixSimilarSection(
        items: similar,
        title: isMovie ? 'More Like This' : 'Similar TV Shows',
      ),
    );
  }

  void _playContent(BuildContext context) {
    if (isMovie) {
      context.pushNamed(
        'movie-player',
        pathParameters: {'id': movie.id.toString()},
      );
    } else {
      // Play first episode or resume
      context.pushNamed(
        'tv-player',
        pathParameters: {
          'id': tvShow.id.toString(),
          'season': '1',
          'episode': '1',
        },
      );
    }
  }

  void _toggleWatchlist(BuildContext context) {
    // TODO: Toggle watchlist
  }

  void _showRatingDialog(BuildContext context) {
    // TODO: Show rating dialog
  }

  void _shareContent(BuildContext context) {
    // TODO: Share functionality
  }
}

/// Netflix-style hero banner with gradient overlay
class _NetflixHeroBanner extends StatelessWidget {
  final String? backdropPath;
  final String title;
  final String? overview;
  final double voteAverage;
  final bool isMovie;
  final VoidCallback onPlay;
  final VoidCallback onAddToList;
  final VoidCallback onRate;
  final VoidCallback onShare;

  const _NetflixHeroBanner({
    required this.backdropPath,
    required this.title,
    this.overview,
    required this.voteAverage,
    required this.isMovie,
    required this.onPlay,
    required this.onAddToList,
    required this.onRate,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    const imageBaseUrl = String.fromEnvironment(
      'TMDB_IMAGE_BASE_URL',
      defaultValue: 'https://image.tmdb.org/t/p',
    );
    final imageUrl = backdropPath != null ? '$imageBaseUrl/original$backdropPath' : null;

    return SizedBox(
      height: 580,
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

          // Netflix-style gradient (heavy at bottom)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.0),
                  Colors.black.withValues(alpha: 0.0),
                  Colors.black.withValues(alpha: 0.4),
                  Colors.black.withValues(alpha: 0.8),
                  Colors.black.withValues(alpha: 0.98),
                ],
                stops: const [0.0, 0.3, 0.5, 0.75, 1.0],
              ),
            ),
          ),

          // Content
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title (centered, large)
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 20,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),

                // Rating badge
                if (voteAverage > 0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${voteAverage.toStringAsFixed(1)} Match',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 24),

                // Action Buttons (Netflix style)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Play Button (Primary)
                    Flexible(
                      child: ElevatedButton.icon(
                        onPressed: onPlay,
                        icon: const Icon(Icons.play_arrow, size: 28, color: Colors.black),
                        label: const Text(
                          'Play',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Add to List Button
                    Flexible(
                      child: ElevatedButton.icon(
                        onPressed: onAddToList,
                        icon: const Icon(Icons.add, size: 24, color: Colors.white),
                        label: const Text(
                          'My List',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Secondary Actions (Icon buttons)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ActionIconButton(
                      icon: Icons.thumb_up_outlined,
                      label: 'Rate',
                      onTap: onRate,
                    ),
                    const SizedBox(width: 32),
                    _ActionIconButton(
                      icon: Icons.share_outlined,
                      label: 'Share',
                      onTap: onShare,
                    ),
                    if (!isMovie) ...[
                      const SizedBox(width: 32),
                      _ActionIconButton(
                        icon: Icons.download_outlined,
                        label: 'Download',
                        onTap: () {},
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Netflix-style action icon button
class _ActionIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionIconButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// Netflix-style metadata and synopsis section
class _NetflixMetadataSection extends StatelessWidget {
  final DateTime? releaseDate;
  final bool isMovie;
  final String overview;
  final ValueNotifier<bool> isExpandedNotifier;

  const _NetflixMetadataSection({
    required this.releaseDate,
    required this.isMovie,
    required this.overview,
    required this.isExpandedNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final year = releaseDate?.year.toString() ?? 'N/A';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Metadata row
          Row(
            children: [
              Text(
                year,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '13+',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                isMovie ? '2h 15m' : '8 Seasons',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Expandable Synopsis
          ValueListenableBuilder<bool>(
            valueListenable: isExpandedNotifier,
            builder: (context, isExpanded, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    overview,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 14,
                      height: 1.5,
                    ),
                    maxLines: isExpanded ? 100 : 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (overview.length > 150)
                    TextButton(
                      onPressed: () {
                        isExpandedNotifier.value = !isExpanded;
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white.withValues(alpha: 0.7),
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        isExpanded ? 'Less' : 'More',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Netflix-style cast section
class _NetflixCastSection extends StatefulWidget {
  final List<CastMember> cast;

  const _NetflixCastSection({required this.cast});

  @override
  State<_NetflixCastSection> createState() => _NetflixCastSectionState();
}

class _NetflixCastSectionState extends State<_NetflixCastSection> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Row(
            children: [
              const Text(
                'Cast',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white.withValues(alpha: 0.7),
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('See all'),
                    SizedBox(width: 4),
                    Icon(Icons.chevron_right, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Horizontal cast list
        SizedBox(
          height: 140,
          child: DesktopScrollWrapper(
            controller: _scrollController,
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: widget.cast.take(10).length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final member = widget.cast[index];
                return _CastMemberCard(member: member);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _CastMemberCard extends StatelessWidget {
  final CastMember member;

  const _CastMemberCard({required this.member});

  @override
  Widget build(BuildContext context) {
    const imageBaseUrl = String.fromEnvironment(
      'TMDB_IMAGE_BASE_URL',
      defaultValue: 'https://image.tmdb.org/t/p',
    );
    final imageUrl = member.profilePath != null
        ? '$imageBaseUrl/w185${member.profilePath}'
        : null;

    return SizedBox(
      width: 80,
      child: Column(
        children: [
          // Avatar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 80,
              height: 80,
              color: Colors.grey[800],
              child: imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => const ShimmerBox(width: 80, height: 80),
                    )
                  : const Icon(Icons.person, color: Colors.grey, size: 40),
            ),
          ),
          const SizedBox(height: 8),

          // Name
          Text(
            member.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),

          // Character
          Text(
            member.character ?? '',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Netflix-style episodes section for TV shows
class _NetflixEpisodesSection extends StatefulWidget {
  final TvShow tvShow;
  final List<SeasonSummary> seasons;

  const _NetflixEpisodesSection({
    required this.tvShow,
    required this.seasons,
  });

  @override
  State<_NetflixEpisodesSection> createState() => _NetflixEpisodesSectionState();
}

class _NetflixEpisodesSectionState extends State<_NetflixEpisodesSection> {
  int _selectedSeason = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with season selector
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Row(
            children: [
              const Text(
                'Episodes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 12),

                // Season dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _selectedSeason,
                    dropdownColor: const Color(0xFF2A2A2A),
                    style: const TextStyle(color: Colors.white),
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                    items: widget.seasons.map((season) {
                      return DropdownMenuItem(
                        value: season.seasonNumber,
                        child: Text('Season ${season.seasonNumber}'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedSeason = value);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        // Episode list placeholder
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Season $_selectedSeason episodes coming soon...',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

/// Netflix-style trailers section
class _NetflixTrailersSection extends StatefulWidget {
  final List<Video> videos;

  const _NetflixTrailersSection({required this.videos});

  @override
  State<_NetflixTrailersSection> createState() => _NetflixTrailersSectionState();
}

class _NetflixTrailersSectionState extends State<_NetflixTrailersSection> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trailers = widget.videos.where((v) => v.type == 'Trailer').toList();
    if (trailers.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text(
            'Trailers & More',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Horizontal trailer list
        SizedBox(
          height: 120,
          child: DesktopScrollWrapper(
            controller: _scrollController,
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: trailers.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final video = trailers[index];
                return _TrailerCard(video: video);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _TrailerCard extends StatelessWidget {
  final Video video;

  const _TrailerCard({required this.video});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            // Thumbnail placeholder
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 200,
                height: 120,
                color: Colors.grey[700],
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
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

            // Title overlay
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: Text(
                video.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Netflix-style similar content section
class _NetflixSimilarSection extends StatefulWidget {
  final List<dynamic> items;
  final String title;

  const _NetflixSimilarSection({
    required this.items,
    required this.title,
  });

  @override
  State<_NetflixSimilarSection> createState() => _NetflixSimilarSectionState();
}

class _NetflixSimilarSectionState extends State<_NetflixSimilarSection> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Horizontal content list
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
                return _SimilarContentCard(item: item);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _SimilarContentCard extends StatelessWidget {
  final dynamic item;

  const _SimilarContentCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final imagePath = item is Movie
        ? (item as Movie).posterPath
        : (item as TvShow).posterPath;
    const imageBaseUrl = String.fromEnvironment(
      'TMDB_IMAGE_BASE_URL',
      defaultValue: 'https://image.tmdb.org/t/p',
    );
    final imageUrl = imagePath != null ? '$imageBaseUrl/w342$imagePath' : null;

    return GestureDetector(
      onTap: () {
        // Navigate to detail
        if (item is Movie) {
          context.pushNamed(
            'movie-detail',
            pathParameters: {'id': (item as Movie).id.toString()},
            extra: item,
          );
        } else {
          context.pushNamed(
            'tv-detail',
            pathParameters: {'id': (item as TvShow).id.toString()},
            extra: item,
          );
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          width: 110,
          height: 160,
          color: Colors.grey[900],
          child: imageUrl != null
              ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => const ShimmerBox(width: 110, height: 160),
                )
              : const Center(
                  child: Icon(Icons.movie, color: Colors.grey),
                ),
        ),
      ),
    );
  }
}

/// Netflix-style loading state
class _NetflixDetailLoading extends StatelessWidget {
  const _NetflixDetailLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: Colors.red,
            strokeWidth: 3,
          ),
          SizedBox(height: 16),
          Text(
            'Loading...',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

/// Netflix-style error state
class _NetflixDetailError extends StatelessWidget {
  final Object error;

  const _NetflixDetailError({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

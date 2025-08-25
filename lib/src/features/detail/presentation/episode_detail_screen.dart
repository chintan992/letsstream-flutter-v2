import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lets_stream/src/core/models/episode.dart';
import 'package:lets_stream/src/core/services/tmdb_repository_provider.dart';
import 'package:lets_stream/src/shared/widgets/shimmer_box.dart';

class EpisodeDetailScreen extends ConsumerStatefulWidget {
  final int tvId;
  final int seasonNumber;
  final int initialIndex;
  final List<EpisodeSummary>? initialEpisodes;

  const EpisodeDetailScreen({
    super.key,
    required this.tvId,
    required this.seasonNumber,
    required this.initialIndex,
    this.initialEpisodes,
  });

  @override
  ConsumerState<EpisodeDetailScreen> createState() => _EpisodeDetailScreenState();
}

class _EpisodeDetailScreenState extends ConsumerState<EpisodeDetailScreen> {
  List<EpisodeSummary>? _episodes;
  int _currentIndex = 0;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _episodes = widget.initialEpisodes;
    if (_episodes == null) {
      _fetchEpisodes();
    }
  }

  Future<void> _fetchEpisodes() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = ref.read(tmdbRepositoryProvider);
      final eps = await repo.getSeasonEpisodes(widget.tvId, widget.seasonNumber);
      setState(() => _episodes = eps);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _goPrev() {
    if (_episodes == null) return;
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
    }
  }

  void _goNext() {
    if (_episodes == null) return;
    if (_currentIndex < _episodes!.length - 1) {
      setState(() => _currentIndex++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String imageBaseUrl = dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';

    final episode = (_episodes != null && _episodes!.isNotEmpty)
        ? _episodes![_currentIndex]
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text('Season ${widget.seasonNumber}${episode != null ? ' • Ep ${episode.episodeNumber}' : ''}'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Failed to load episodes: $_error'))
              : episode == null
                  ? const Center(child: Text('No episode data'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: episode.stillPath != null && episode.stillPath!.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: '$imageBaseUrl/w780${episode.stillPath}',
                                    width: double.infinity,
                                    height: 220,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const ShimmerBox(
                                      width: double.infinity,
                                      height: 220,
                                    ),
                                    errorWidget: (context, url, error) => Container(
                                      width: double.infinity,
                                      height: 220,
                                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                      child: const Icon(Icons.broken_image_outlined),
                                    ),
                                  )
                                : Container(
                                    width: double.infinity,
                                    height: 220,
                                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                    child: const Icon(Icons.broken_image_outlined),
                                  ),
                          ),
                          const SizedBox(height: 16),
                          // Title and meta
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${episode.episodeNumber}. ${episode.name}',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                              const Icon(Icons.star, size: 18, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(episode.voteAverage.toStringAsFixed(1)),
                            ],
                          ),
                          if (episode.airDate != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Air date: ${episode.airDate!.toLocal().toIso8601String().split('T').first}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                          const SizedBox(height: 12),
                          Text(
                            (episode.overview?.isNotEmpty ?? false)
                                ? episode.overview!
                                : 'No overview available.',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              OutlinedButton.icon(
                                onPressed: _episodes != null && _currentIndex > 0 ? _goPrev : null,
                                icon: const Icon(Icons.chevron_left),
                                label: const Text('Previous'),
                              ),
                              OutlinedButton.icon(
                                onPressed: _episodes != null && _currentIndex < (_episodes!.length - 1) ? _goNext : null,
                                icon: const Icon(Icons.chevron_right),
                                label: const Text('Next'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (_episodes != null)
                            Center(
                              child: Text(
                                'Episode ${_currentIndex + 1} of ${_episodes!.length}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                        ],
                      ),
                    ),
    );
  }
}


import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lets_stream/src/features/hub/application/hub_notifier.dart';
import 'package:lets_stream/src/shared/widgets/media_carousel.dart';
import 'package:lets_stream/src/core/constants/content_constants.dart';

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
                actions: [
                  _PersonalizationButton(),
                  const _SearchButton(),
                ],
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
    return RefreshIndicator(
      onRefresh: () => ref.read(hubNotifierProvider.notifier).refresh(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Personalized sections (if enabled)
            if (state.isPersonalizationEnabled) ...[
              if (state.personalizedMovies.isNotEmpty)
                MediaCarousel(
                  title: 'Recommended for You',
                  items: state.personalizedMovies,
                  onViewAll: () => context.pushNamed('movies-list', pathParameters: {'feed': 'recommended'}),
                ),
              if (state.genreBasedMovies.isNotEmpty)
                MediaCarousel(
                  title: 'Based on Your Preferences',
                  items: state.genreBasedMovies,
                  onViewAll: () => context.pushNamed('movies-list', pathParameters: {'feed': 'personalized'}),
                ),
            ],
            
            // Standard movie sections
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
            
            // Expanded genre sections
            if (state.actionMovies.isNotEmpty)
              MediaCarousel(
                title: 'Action',
                items: state.actionMovies,
                onViewAll: () => context.pushNamed('movies-genre', pathParameters: {'id': '28'}, queryParameters: {'name': 'Action'}),
              ),
            if (state.comedyMovies.isNotEmpty)
              MediaCarousel(
                title: 'Comedy',
                items: state.comedyMovies,
                onViewAll: () => context.pushNamed('movies-genre', pathParameters: {'id': '35'}, queryParameters: {'name': 'Comedy'}),
              ),
            if (state.dramaMovies.isNotEmpty)
              MediaCarousel(
                title: 'Drama',
                items: state.dramaMovies,
                onViewAll: () => context.pushNamed('movies-genre', pathParameters: {'id': '18'}, queryParameters: {'name': 'Drama'}),
              ),
            if (state.sciFiMovies.isNotEmpty)
              MediaCarousel(
                title: 'Sci-Fi',
                items: state.sciFiMovies,
                onViewAll: () => context.pushNamed('movies-genre', pathParameters: {'id': '878'}, queryParameters: {'name': 'Sci-Fi'}),
              ),
            if (state.horrorMovies.isNotEmpty)
              MediaCarousel(
                title: 'Horror',
                items: state.horrorMovies,
                onViewAll: () => context.pushNamed('movies-genre', pathParameters: {'id': '27'}, queryParameters: {'name': 'Horror'}),
              ),
            if (state.adventureMovies.isNotEmpty)
              MediaCarousel(
                title: 'Adventure',
                items: state.adventureMovies,
                onViewAll: () => context.pushNamed('movies-genre', pathParameters: {'id': '12'}, queryParameters: {'name': 'Adventure'}),
              ),
            if (state.thrillerMovies.isNotEmpty)
              MediaCarousel(
                title: 'Thriller',
                items: state.thrillerMovies,
                onViewAll: () => context.pushNamed('movies-genre', pathParameters: {'id': '53'}, queryParameters: {'name': 'Thriller'}),
              ),
            if (state.romanceMovies.isNotEmpty)
              MediaCarousel(
                title: 'Romance',
                items: state.romanceMovies,
                onViewAll: () => context.pushNamed('movies-genre', pathParameters: {'id': '10749'}, queryParameters: {'name': 'Romance'}),
              ),
              
            // Platform-based movie sections
            if (state.netflixMovies.isNotEmpty)
              MediaCarousel(
                title: 'Netflix Movies',
                items: state.netflixMovies,
                onViewAll: () => context.pushNamed('movies-list', pathParameters: {'feed': 'netflix_movies'}),
              ),
            if (state.amazonPrimeMovies.isNotEmpty)
              MediaCarousel(
                title: 'Prime Video Movies',
                items: state.amazonPrimeMovies,
                onViewAll: () => context.pushNamed('movies-list', pathParameters: {'feed': 'prime_movies'}),
              ),
            if (state.disneyPlusMovies.isNotEmpty)
              MediaCarousel(
                title: 'Disney+ Movies',
                items: state.disneyPlusMovies,
                onViewAll: () => context.pushNamed('movies-list', pathParameters: {'feed': 'disney_movies'}),
              ),
          ],
        ),
      ),
    );
  }
}

class _TvHubBody extends ConsumerWidget {
  final HubState state;

  const _TvHubBody({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () => ref.read(hubNotifierProvider.notifier).refresh(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Personalized sections (if enabled)
            if (state.isPersonalizationEnabled) ...[
              if (state.personalizedTvShows.isNotEmpty)
                MediaCarousel(
                  title: 'Recommended for You',
                  items: state.personalizedTvShows,
                  onViewAll: () => context.pushNamed('tv-list', pathParameters: {'feed': 'recommended'}),
                ),
              if (state.recommendedTvShows.isNotEmpty)
                MediaCarousel(
                  title: 'From Your Preferred Platforms',
                  items: state.recommendedTvShows,
                  onViewAll: () => context.pushNamed('tv-list', pathParameters: {'feed': 'platform_recommended'}),
                ),
            ],
            
            // Standard TV sections
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
            
            // Expanded genre sections
            if (state.dramaTvShows.isNotEmpty)
              MediaCarousel(
                title: 'Drama',
                items: state.dramaTvShows,
                onViewAll: () => context.pushNamed('tv-genre', pathParameters: {'id': '18'}, queryParameters: {'name': 'Drama'}),
              ),
            if (state.comedyTvShows.isNotEmpty)
              MediaCarousel(
                title: 'Comedy',
                items: state.comedyTvShows,
                onViewAll: () => context.pushNamed('tv-genre', pathParameters: {'id': '35'}, queryParameters: {'name': 'Comedy'}),
              ),
            if (state.crimeTvShows.isNotEmpty)
              MediaCarousel(
                title: 'Crime',
                items: state.crimeTvShows,
                onViewAll: () => context.pushNamed('tv-genre', pathParameters: {'id': '80'}, queryParameters: {'name': 'Crime'}),
              ),
            if (state.sciFiFantasyTvShows.isNotEmpty)
              MediaCarousel(
                title: 'Sci-Fi & Fantasy',
                items: state.sciFiFantasyTvShows,
                onViewAll: () => context.pushNamed('tv-genre', pathParameters: {'id': '10765'}, queryParameters: {'name': 'Sci-Fi & Fantasy'}),
              ),
            if (state.documentaryTvShows.isNotEmpty)
              MediaCarousel(
                title: 'Documentary',
                items: state.documentaryTvShows,
                onViewAll: () => context.pushNamed('tv-genre', pathParameters: {'id': '99'}, queryParameters: {'name': 'Documentary'}),
              ),
            
            // Expanded platform sections
            if (state.netflixShows.isNotEmpty)
              MediaCarousel(
                title: 'Netflix',
                items: state.netflixShows,
                onViewAll: () => context.pushNamed('tv-list', pathParameters: {'feed': 'netflix'}),
              ),
            if (state.amazonPrimeShows.isNotEmpty)
              MediaCarousel(
                title: 'Amazon Prime Video',
                items: state.amazonPrimeShows,
                onViewAll: () => context.pushNamed('tv-list', pathParameters: {'feed': 'amazon_prime'}),
              ),
            if (state.disneyPlusShows.isNotEmpty)
              MediaCarousel(
                title: 'Disney+',
                items: state.disneyPlusShows,
                onViewAll: () => context.pushNamed('tv-list', pathParameters: {'feed': 'disney_plus'}),
              ),
            if (state.huluShows.isNotEmpty)
              MediaCarousel(
                title: 'Hulu',
                items: state.huluShows,
                onViewAll: () => context.pushNamed('tv-list', pathParameters: {'feed': 'hulu'}),
              ),
            if (state.hboMaxShows.isNotEmpty)
              MediaCarousel(
                title: 'HBO Max',
                items: state.hboMaxShows,
                onViewAll: () => context.pushNamed('tv-list', pathParameters: {'feed': 'hbo_max'}),
              ),
            if (state.appleTvShows.isNotEmpty)
              MediaCarousel(
                title: 'Apple TV+',
                items: state.appleTvShows,
                onViewAll: () => context.pushNamed('tv-list', pathParameters: {'feed': 'apple_tv'}),
              ),
          ],
        ),
      ),
    );
  }
}

class _PersonalizationButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hubState = ref.watch(hubNotifierProvider);
    final hubNotifier = ref.read(hubNotifierProvider.notifier);
    
    return IconButton(
      onPressed: () => _showPersonalizationDialog(context, hubState, hubNotifier),
      icon: Icon(
        hubState.isPersonalizationEnabled 
          ? Icons.person 
          : Icons.person_outline,
        color: hubState.isPersonalizationEnabled 
          ? Theme.of(context).colorScheme.primary 
          : null,
      ),
      tooltip: hubState.isPersonalizationEnabled 
        ? 'Personalization enabled' 
        : 'Enable personalization',
    );
  }

  void _showPersonalizationDialog(
    BuildContext context, 
    HubState state, 
    HubNotifier notifier,
  ) {
    showDialog(
      context: context,
      builder: (context) => _PersonalizationDialog(
        currentState: state,
        notifier: notifier,
      ),
    );
  }
}

class _PersonalizationDialog extends StatefulWidget {
  final HubState currentState;
  final HubNotifier notifier;

  const _PersonalizationDialog({
    required this.currentState,
    required this.notifier,
  });

  @override
  State<_PersonalizationDialog> createState() => _PersonalizationDialogState();
}

class _PersonalizationDialogState extends State<_PersonalizationDialog> {
  late bool _personalizationEnabled;
  late Set<int> _selectedGenres;
  late Set<int> _selectedPlatforms;

  @override
  void initState() {
    super.initState();
    _personalizationEnabled = widget.currentState.isPersonalizationEnabled;
    _selectedGenres = widget.currentState.userPreferredGenres.toSet();
    _selectedPlatforms = widget.currentState.userPreferredPlatforms.toSet();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Personalization Settings'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('Enable Personalization'),
              subtitle: const Text('Show recommendations based on your preferences'),
              value: _personalizationEnabled,
              onChanged: (value) {
                setState(() {
                  _personalizationEnabled = value;
                });
              },
            ),
            
            if (_personalizationEnabled) ...[
              const Divider(),
              const Text(
                'Preferred Genres',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ContentConstants.popularMovieGenres.entries.map((entry) {
                  final isSelected = _selectedGenres.contains(entry.key);
                  return FilterChip(
                    label: Text(entry.value),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedGenres.add(entry.key);
                        } else {
                          _selectedGenres.remove(entry.key);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 16),
              const Text(
                'Preferred Platforms',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ContentConstants.streamingPlatforms.entries.take(8).map((entry) {
                  final isSelected = _selectedPlatforms.contains(entry.key);
                  return FilterChip(
                    label: Text(entry.value),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedPlatforms.add(entry.key);
                        } else {
                          _selectedPlatforms.remove(entry.key);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            await widget.notifier.updatePreferences(
              personalizationEnabled: _personalizationEnabled,
              preferredGenres: _selectedGenres.toList(),
              preferredPlatforms: _selectedPlatforms.toList(),
            );
            if (context.mounted) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Preferences updated successfully!'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
          child: const Text('Save'),
        ),
      ],
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

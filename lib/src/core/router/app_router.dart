import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/detail/presentation/enhanced_detail_screen.dart';
import '../../features/movies/presentation/movies_list_screen.dart';
import '../../features/tv_shows/presentation/tv_list_screen.dart';
import '../../features/hub/presentation/hub_screens.dart';
import '../../features/anime/presentation/anime_screen.dart';
import '../../features/anime/presentation/anime_detail_screen.dart';
import '../../features/anime/presentation/anime_player_screen.dart';
import '../../features/profile/presentation/profile_screen.dart'
    as feature_profile;
import '../../features/search/presentation/search_screen.dart';
import '../../features/watchlist/presentation/watchlist_screen.dart';
import '../../features/movies/presentation/movies_genre_list_screen.dart';
import '../../features/tv_shows/presentation/tv_genre_list_screen.dart';
import '../../features/detail/presentation/episode_detail_screen.dart';
import '../../features/video_player/presentation/video_player_screen.dart';
import '../../core/models/movie.dart';
import '../../core/models/tv_show.dart';

// Global navigator key for deep link handling
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// Router configuration for the Let's Stream app
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  // Configure deep link handling
  debugLogDiagnostics: true,
  // Handle deep link URLs with custom schemes
  navigatorKey: rootNavigatorKey,
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainNavigationScreen(child: child),
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/hub',
          name: 'hub',
          builder: (context, state) => const HubScreen(),
        ),
        GoRoute(
          path: '/movies/:feed',
          name: 'movies-list',
          builder: (context, state) {
            final feed = state.pathParameters['feed'] ?? 'popular';
            return MoviesListScreen(feed: feed);
          },
        ),
        GoRoute(
          path: '/movies/genre/:id',
          name: 'movies-genre',
          builder: (context, state) {
            final idStr = state.pathParameters['id'];
            final name = state.uri.queryParameters['name'] ?? 'Genre';
            final id = int.tryParse(idStr ?? '0') ?? 0;
            return MoviesGenreListScreen(
              genreId: id,
              genreName: name,
              feed: 'popular',
            );
          },
        ),
        GoRoute(
          path: '/tv-shows/:feed',
          name: 'tv-list',
          builder: (context, state) {
            final feed = state.pathParameters['feed'] ?? 'popular';
            return TvListScreen(feed: feed);
          },
        ),
        GoRoute(
          path: '/tv-shows/genre/:id',
          name: 'tv-genre',
          builder: (context, state) {
            final idStr = state.pathParameters['id'];
            final name = state.uri.queryParameters['name'] ?? 'Genre';
            final id = int.tryParse(idStr ?? '0') ?? 0;
            return TvGenreListScreen(genreId: id, genreName: name);
          },
        ),
        GoRoute(
          path: '/tv-shows/netflix',
          name: 'tv-netflix',
          builder: (context, state) => const TvListScreen(feed: 'netflix'),
        ),
        GoRoute(
          path: '/tv-shows/amazon_prime',
          name: 'tv-amazon-prime',
          builder: (context, state) => const TvListScreen(feed: 'amazon_prime'),
        ),
        GoRoute(
          path: '/anime',
          name: 'anime',
          builder: (context, state) => const AnimeScreen(),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const feature_profile.ProfileScreen(),
        ),
        GoRoute(
          path: '/search',
          name: 'search',
          builder: (context, state) => const SearchScreen(),
        ),
        GoRoute(
          path: '/watchlist',
          name: 'watchlist',
          builder: (context, state) => const WatchlistScreen(),
        ),
        // Detail routes
        GoRoute(
          path: '/movie/:id',
          name: 'movie-detail',
          builder: (context, state) {
            final item = state.extra; // Expecting a Movie
            // Check if it's an anime movie (genre 16) to use the anime detail screen
            if (item is Movie && (item.genreIds?.contains(16) ?? false)) {
              return AnimeDetailScreen(item: item);
            }
            return EnhancedDetailScreen(item: item);
          },
        ),
        GoRoute(
          path: '/tv/:id',
          name: 'tv-detail',
          builder: (context, state) {
            final item = state.extra; // Expecting a TvShow
            // Check if it's an anime TV show (genre 16) to use the anime detail screen
            if (item is TvShow && (item.genreIds?.contains(16) ?? false)) {
              return AnimeDetailScreen(item: item);
            }
            return EnhancedDetailScreen(item: item);
          },
        ),
        // Deep link for TV episode detail
        GoRoute(
          path: '/tv/:id/season/:season/episode/:ep',
          name: 'episode-detail',
          builder: (context, state) {
            final tvId = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
            final season =
                int.tryParse(state.pathParameters['season'] ?? '1') ?? 1;
            final epNumber =
                int.tryParse(state.pathParameters['ep'] ?? '1') ?? 1;
            // We don't have the list here; EpisodeDetailScreen will fetch the season if needed
            final idx = epNumber - 1;
            final safeIndex = idx < 0 ? 0 : idx;
            return EpisodeDetailScreen(
              tvId: tvId,
              seasonNumber: season,
              initialIndex: safeIndex,
              initialEpisodes: null,
            );
          },
        ),
      ],
    ),
    // OAuth callback route - TOP LEVEL (handles deep links)
    GoRoute(
      path: '/oauth/callback',
      name: 'oauth-callback',
      builder: (context, state) {
        final code = state.uri.queryParameters['code'];
        final error = state.uri.queryParameters['error'];
        final errorDescription = state.uri.queryParameters['error_description'];

        // Handle the callback
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (!context.mounted) return;

          if (code != null && code.isNotEmpty) {
            // Success case - process the authorization code
            await _handleOAuthCallback(context, code);
          } else if (error != null) {
            // Error case - show error message
            _handleOAuthError(context, error, errorDescription);
          } else {
            // No code or error - show generic message
            if (!context.mounted) return;
            _showSnackBar(context, 'Authentication was cancelled or failed');
            if (context.mounted) {
              context.goNamed('profile');
            }
          }
        });

        return const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Processing authentication...'),
              ],
            ),
          ),
        );
      },
    ),
    // Video player route (movie) - TOP LEVEL
    GoRoute(
      path: '/watch/movie/:id',
      name: 'watch-movie',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
        return VideoPlayerScreen(tmdbId: id, isMovie: true);
      },
    ),
    // Video player route (tv episode) - TOP LEVEL
    GoRoute(
      path: '/watch/tv/:id/season/:season/episode/:ep',
      name: 'watch-tv',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
        final season = int.tryParse(state.pathParameters['season'] ?? '1') ?? 1;
        final ep = int.tryParse(state.pathParameters['ep'] ?? '1') ?? 1;
        return VideoPlayerScreen(
          tmdbId: id,
          isMovie: false,
          season: season,
          episode: ep,
        );
      },
    ),
    // Anime player route - TOP LEVEL
    GoRoute(
      path: '/watch/anime/:animeId/:episodeId?',
      name: 'watch-anime',
      builder: (context, state) {
        final animeId = state.pathParameters['animeId'] ?? '';
        final episodeId = state.pathParameters['episodeId'];
        return AnimePlayerScreen(
          animeId: animeId,
          episodeId: episodeId,
        );
      },
    ),
  ],
);

/// Main navigation shell with bottom navigation bar
class MainNavigationScreen extends StatelessWidget {
  final Widget child;

  const MainNavigationScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) => _onItemTapped(index, context),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.video_library_outlined),
            selectedIcon: Icon(Icons.video_library),
            label: 'Hub',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border_outlined),
            selectedIcon: Icon(Icons.bookmark),
            label: 'Watchlist',
          ),
          NavigationDestination(
            icon: Icon(Icons.animation_outlined),
            selectedIcon: Icon(Icons.animation),
            label: 'Anime',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/hub')) return 1;
    if (location.startsWith('/watchlist')) return 2;
    if (location.startsWith('/anime')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.goNamed('home');
        break;
      case 1:
        context.goNamed('hub');
        break;
      case 2:
        context.goNamed('watchlist');
        break;
      case 3:
        context.goNamed('anime');
        break;
      case 4:
        context.goNamed('profile');
        break;
    }
  }
}

/// Handle OAuth callback with authorization code
Future<void> _handleOAuthCallback(BuildContext context, String code) async {
  try {
    // For now, just show success and redirect to profile
    // TODO: Implement generic OAuth handling if needed
    if (!context.mounted) return;

    _showSnackBar(context, 'Authentication successful!');
    context.goNamed('profile');
  } catch (e) {
    debugPrint('OAuth callback error: $e');
    if (context.mounted) {
      _showSnackBar(context, 'Authentication error occurred.');
      context.goNamed('profile');
    }
  }
}

/// Handle OAuth error callback
void _handleOAuthError(
  BuildContext context,
  String error,
  String? errorDescription,
) {
  debugPrint('OAuth error: $error, description: $errorDescription');
  if (context.mounted) {
    _showSnackBar(
      context,
      'Authentication failed: ${errorDescription ?? error}',
    );
    context.goNamed('profile');
  }
}

/// Show snackbar message
void _showSnackBar(BuildContext context, String message) {
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
    );
  }
}

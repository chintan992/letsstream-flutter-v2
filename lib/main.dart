import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'src/shared/theme/theme_providers.dart';
import 'src/core/services/cache_service.dart';
import 'src/core/services/offline_service.dart';
import 'src/core/models/hive_adapters.dart';
import 'src/features/home/presentation/home_screen.dart';
import 'src/features/detail/presentation/enhanced_detail_screen.dart';
import 'src/features/movies/presentation/movies_list_screen.dart';
import 'src/features/tv_shows/presentation/tv_list_screen.dart';
import 'src/features/hub/presentation/hub_screens.dart';
import 'src/features/anime/presentation/anime_screen.dart';
import 'src/features/anime/presentation/anime_detail_screen.dart';
import 'src/features/profile/presentation/profile_screen.dart'
    as feature_profile;
import 'src/features/search/presentation/search_screen.dart';
import 'src/features/movies/presentation/movies_genre_list_screen.dart';
import 'src/features/tv_shows/presentation/tv_genre_list_screen.dart';
import 'src/features/detail/presentation/episode_detail_screen.dart';
import 'src/features/video_player/presentation/video_player_screen.dart';
import 'src/core/models/movie.dart';
import 'src/core/models/tv_show.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Firebase (Android auto-config via google-services.json)
  await Firebase.initializeApp();

  // Initialize Hive and services
  await _initializeServices();

  runApp(const ProviderScope(child: LetsStreamApp()));
}

/// Initialize all required services
Future<void> _initializeServices() async {
  try {
    // Initialize Hive
    await Hive.initFlutter();

    // Register Hive adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(MovieAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TvShowAdapter());
    }

    // Initialize services
    await CacheService.instance.initialize();
    await OfflineService().initialize();

    debugPrint('All services initialized successfully');
  } catch (e) {
    debugPrint('Failed to initialize services: $e');
    // Continue with app startup even if services fail to initialize
  }
}

class LetsStreamApp extends ConsumerWidget {
  const LetsStreamApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(currentThemeProvider);

    return MaterialApp.router(
      title: 'Let\'s Stream',
      debugShowCheckedModeBanner: false,
      theme: currentTheme,
      routerConfig: _router,
    );
  }
}

// Basic router configuration

// Basic router configuration
final _router = GoRouter(
  initialLocation: '/',
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
  ],
);

// Main navigation shell with bottom navigation bar
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
    if (location.startsWith('/anime')) return 2;
    if (location.startsWith('/profile')) return 3;
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
        context.goNamed('anime');
        break;
      case 3:
        context.goNamed('profile');
        break;
    }
  }
}
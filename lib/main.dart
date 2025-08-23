import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'src/shared/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services here (Firebase, Hive, etc.)
  // await initializeServices();
  
  runApp(
    const ProviderScope(
      child: LetsStreamApp(),
    ),
  );
}

class LetsStreamApp extends ConsumerWidget {
  const LetsStreamApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Let\'s Stream',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Default to dark mode
      routerConfig: _router,
    );
  }
}

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
          path: '/movies',
          name: 'movies',
          builder: (context, state) => const MoviesScreen(),
        ),
        GoRoute(
          path: '/tv-shows',
          name: 'tv-shows',
          builder: (context, state) => const TvShowsScreen(),
        ),
        GoRoute(
          path: '/anime',
          name: 'anime',
          builder: (context, state) => const AnimeScreen(),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
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
            icon: Icon(Icons.movie_outlined),
            selectedIcon: Icon(Icons.movie),
            label: 'Movies',
          ),
          NavigationDestination(
            icon: Icon(Icons.tv_outlined),
            selectedIcon: Icon(Icons.tv),
            label: 'TV Shows',
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
    if (location.startsWith('/movies')) return 1;
    if (location.startsWith('/tv-shows')) return 2;
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
        context.goNamed('movies');
        break;
      case 2:
        context.goNamed('tv-shows');
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

// Placeholder screens - to be moved to their respective feature folders
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Let\'s Stream'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Welcome to Let\'s Stream!\nYour media discovery journey starts here.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class MoviesScreen extends StatelessWidget {
  const MoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Movies Section - Coming Soon!'),
      ),
    );
  }
}

class TvShowsScreen extends StatelessWidget {
  const TvShowsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TV Shows'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('TV Shows Section - Coming Soon!'),
      ),
    );
  }
}

class AnimeScreen extends StatelessWidget {
  const AnimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anime'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Anime Section - Coming Soon!'),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Profile Section - Coming Soon!'),
      ),
    );
  }
}

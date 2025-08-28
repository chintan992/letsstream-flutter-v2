# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

**Let's Stream** is a modern Flutter-based media discovery application for movies, TV shows, and anime. It integrates with The Movie Database (TMDB) API and uses Firebase (planned) for user authentication and data storage.

## Plan Alignment and Current Status (Phase 1 - COMPLETED)

**STATUS: Phase 1 fully implemented, UI/UX modernization in progress, moving to Phase 2 (Firebase & Auth)**

Current implementation status against the development plan:
- ✅ Foundation and Navigation (Phase 1 • Week 1):
  - **COMPLETED**: GoRouter with ShellRoute and persistent bottom navigation
  - **COMPLETED**: Home, Movies, TV Shows, Anime, and Profile screens fully implemented
- ✅ API Integration and Sections (Phase 1 • Week 2):
  - **COMPLETED**: Full TMDB integration via `TmdbApi` (Dio) and `TmdbRepository` with comprehensive logging
  - **COMPLETED**: Home carousels for Trending Movies, Now Playing Movies, Trending TV Shows, and Airing Today TV Shows (via `HomeNotifier`)
  - **COMPLETED**: Movies and TV hubs with multiple genre rows and "View All" buttons routing to paginated genre list screens
  - **COMPLETED**: Anime hub with anime movies and TV rows and "View All" by genre
  - **COMPLETED**: Popular/Top Rated feeds and paginated list screens with infinite scroll + "Load more" and null-safe poster placeholders
- ✅ Detail + Search (Phase 1 • Week 3):
  - **COMPLETED**: Debounced, paginated Search with filter toggle (All/Movies/TV) and query persistence
  - **COMPLETED**: Detail screen enhanced with Trailers (YouTube), Similar titles, and Top Billed Cast sections
  - **COMPLETED**: Full navigation flow from media cards to detail screens
- ✅ State Management & UI/UX (Phase 1):
  - **COMPLETED**: Riverpod throughout application (StateNotifier + AsyncValue pattern)
  - **COMPLETED**: Comprehensive shared widget system (MediaCard, MediaCarousel, ShimmerBox, EmptyState, ErrorState)
  - **COMPLETED**: Material 3 theming with design tokens (Tokens class)
  - **COMPLETED**: Loading states, error handling, and retry functionality
- 🔄 Authentication & Backend (Phase 2 - NEXT):
  - **READY**: Firebase packages installed and configured
  - **PENDING**: Firebase initialization and Auth flows (commented in `main.dart`)
  - **PENDING**: User authentication (Google Sign-in, Apple Sign-in)
  - **PENDING**: User preferences and watchlist sync
- 📋 Advanced Features & Polish (Phase 3 - FUTURE):
  - **IN PROGRESS**: UI/UX modernization and design system implementation
  - **PENDING**: Advanced search filters and sorting options
  - **PENDING**: Local caching with Hive (packages installed)
  - **PENDING**: Offline support and data persistence
  - **PENDING**: Advanced settings and customization

**Next Priority Steps:**
1. Initialize Firebase and implement basic authentication flows
2. Wire up Profile screen sign-in functionality
3. Implement user preferences and theme switching
4. Add watchlist and favorites functionality

## Common Development Commands

### Basic Flutter Operations
```bash
# Install dependencies
flutter pub get

# Run the app (debug)
flutter run

# Run with a specific device
flutter run -d chrome        # Web
flutter run -d android       # Android emulator
flutter run -d windows       # Windows desktop

# Clean build artifacts
flutter clean && flutter pub get

# Analyze code for issues
flutter analyze

# Run all tests
flutter test

# Format code
dart format .
```

### Tests: Run a single file or a single test
```bash
# Run a single test file
flutter test test/widget_test.dart

# Run a single test by name (matches substring)
flutter test --plain-name "App launches successfully" test/widget_test.dart
```

### Code Generation
```bash
# Generate code (build_runner, freezed, json_serializable)
dart run build_runner build

# Delete conflicting outputs then build
dart run build_runner build --delete-conflicting-outputs

# Watch for changes and rebuild incrementally
dart run build_runner watch
```
Note: Generators are configured in dev_dependencies, but current models are hand-written. Add annotations before relying on generators.

### Building for Production
```bash
# Android
flutter build apk
flutter build appbundle

# iOS (on macOS)
flutter build ios

# Web
flutter build web

# Windows
flutter build windows
```

## Architecture Overview

Feature-first architecture with clear separation of concerns:

- `lib/src/core/`
  - `api/` – TMDB API client (`TmdbApi`) using Dio
  - `models/` – Data models (`Movie`, `TvShow`, `Video`, `CastMember`, `TmdbResponse<T>`) with JSON parsing
  - `services/` – Repository layer (`TmdbRepository`) + provider
- `lib/src/features/`
  - Feature modules (e.g., `home/`) with `application/` (providers/notifiers) and `presentation/` (UI)
- `lib/src/shared/`
  - Reusable UI (`MediaCard`, `MediaCarousel`) and theming (`AppTheme` with Material 3)

State management: Riverpod `StateNotifier` + `AsyncValue` for async loading/error/data states.

Navigation: GoRouter with a ShellRoute providing persistent bottom navigation; named routes defined in `main.dart`.

API integration: Repository pattern over a singleton API client; generic TMDB responses via `TmdbResponse<T>`.

## Environment and Startup

This app reads TMDB config from environment variables via `flutter_dotenv`.
- Ensure dotenv is loaded before first API/image usage (e.g., at app start):
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: LetsStreamApp()));
}
```
- Bundle the `.env` file for runtime access (especially for mobile/desktop/web): add it to `pubspec.yaml` assets:
```yaml
flutter:
  uses-material-design: true
  assets:
    - .env
```
- Repository hygiene: prefer committing an `.env.example` and ignoring the real `.env` in version control.

## Development Workflow Tips

- When adding new feeds (e.g., Popular/Top Rated):
  1) Add endpoint calls in `TmdbApi` → 2) expose from `TmdbRepository` → 3) extend `HomeNotifier` to fetch → 4) render in `HomeScreen` via `MediaCarousel`.
- For detail navigation: wire `onTap` in `MediaCard` to a detail route with an ID param.
- For search: create a `search` feature folder with providers for querying TMDB’s multi-search.

## Ongoing Implementation Log

  - 2025-08-27: **FEATURE - Video Player UX Enhancements**
    - Added a back button to the video player screen for easier navigation.
    - Implemented next/previous episode navigation controls for TV shows, allowing users to switch episodes without leaving the player.
    - Updated the video player's state management to track the current episode and total number of episodes in a season.
    - Refined the UI to conditionally display episode navigation only for TV shows.
    - Fixed all analysis warnings related to the changes.

[Feature Request: Video Playback Integration]

- **Implement Video Playback:**
  - Integrate an iframe-based video player to stream movies and series within the app.
  - Fetch video source URLs from a custom API endpoint (see below for details).
  - Implement a source-switching dropdown menu overlaying the video player, which auto-hides after 5 seconds of inactivity.
  - Secure the iframe to only allow navigation to video URLs (prevent navigation outside video domains).
  - Use the following custom video sources API to fetch available video providers and their URL patterns:
    - Endpoint: `https://raw.githubusercontent.com/chintan992/letsstream2/refs/heads/main/src/utils/video-sources.json`
    - The response contains a `videoSources` array, each with `key`, `name`, `movieUrlPattern`, and `tvUrlPattern` fields. Use `{id}`, `{season}`, and `{episode}` placeholders for TMDB IDs and episode info.
  - Example usage:
    - For a movie: Replace `{id}` in `movieUrlPattern` with the TMDB movie ID.
    - For a TV episode: Replace `{id}`, `{season}`, and `{episode}` in `tvUrlPattern` with the TMDB show ID, season, and episode numbers.
  - See user prompt for full JSON structure and example patterns.
  - Fetch video source URLs from the provided custom API endpoint.
  - Implement a source-switching dropdown menu that overlays the video player and auto-hides after 5 seconds of inactivity.
  - Secure the iframe to only allow navigation to video URLs.
  - Iframe which uses custom API to fetch video sources for movie/TV shows:
      ${seriesId} = TMDB_ID
      ${movieId} = TMDB_ID
      Custom Video Sources to fetch iframe video url from https://raw.githubusercontent.com/chintan992/letsstream2/refs/heads/main/src/utils/video-sources.json 
        - Response
        ```
        {
            "videoSources": [
            {
            "key": "vidlink",
            "name": "VidLink",
            "movieUrlPattern": "https://vidlink.pro/movie/{id}?autoplay=true&title=true",
            "tvUrlPattern": "https://vidlink.pro/tv/{id}/{season}/{episode}?autoplay=true&title=true"
            },
            {
            "key": "pstream",
            "name": "PStream",
            "movieUrlPattern": "https://iframe.pstream.org/embed/tmdb-movie-{id}&logo=false",
            "tvUrlPattern": "https://iframe.pstream.org/embed/tmdb-tv-{id}/{season}/{episode}&logo=false"
            },
            {
            "key": "autoembed",
            "name": "AutoEmbed",
            "movieUrlPattern": "https://player.autoembed.cc/embed/movie/{id}?autoplay=true",
            "tvUrlPattern": "https://player.autoembed.cc/embed/tv/{id}/{season}/{episode}?autoplay=true"
            },
            {
            "key": "2embed",
            "name": "2Embed",
            "movieUrlPattern": "https://www.2embed.cc/embed/{id}",
            "tvUrlPattern": "https://www.2embed.cc/embed/tv/{id}&s={season}&e={episode}"
            },
            {
            "key": "multiembed",
            "name": "MultiEmbed",
            "movieUrlPattern": "https://multiembed.mov/video_id={id}&tmdb=1",
            "tvUrlPattern": "https://multiembed.mov/video_id={id}&tmdb=1&s={season}&e={episode}"
            },
            {
            "key": "2embed-org",
            "name": "2Embed.org",
            "movieUrlPattern": "https://2embed.org/embed/movie/{id}",
            "tvUrlPattern": "https://2embed.org/embed/tv/{id}/{season}/{episode}"
            },
            {
            "key": "autoembed-co",
            "name": "AutoEmbed.co",
            "movieUrlPattern": "https://autoembed.co/movie/tmdb/{id}",
            "tvUrlPattern": "https://autoembed.co/tv/tmdb/{id}-{season}-{episode}"
            },
            {
            "key": "vidsrc-xyz",
            "name": "VidSrc.xyz",
            "movieUrlPattern": "https://vidsrc.xyz/embed/movie?tmdb={id}&ds_lang=en",
            "tvUrlPattern": "https://vidsrc.xyz/embed/tv?tmdb={id}&season={season}&episode={episode}&ds_lang=en"
            },
            {
            "key": "moviesapi",
            "name": "MoviesAPI",
            "movieUrlPattern": "https://moviesapi.club/movie/{id}",
            "tvUrlPattern": "https://moviesapi.club/tv/{id}-{season}-{episode}"
            },
            {
            "key": "nontongo",
            "name": "NontonGo",
            "movieUrlPattern": "https://www.NontonGo.win/embed/movie/{id}",
            "tvUrlPattern": "https://www.NontonGo.win/embed/tv/{id}/{season}/{episode}"
            },
            {
            "key": "111movies",
            "name": "111Movies",
            "movieUrlPattern": "https://111movies.com/movie/{id}",
            "tvUrlPattern": "https://111movies.com/tv/{id}/{season}/{episode}"
            },
            {
            "key": "flicky",
            "name": "Flicky",
            "movieUrlPattern": "https://flicky.host/embed/movie?id={id}",
            "tvUrlPattern": "https://flicky.host/embed/tv?id={id}/{season}/{episode}"
            },
            {
            "key": "vidjoy",
            "name": "VidJoy",
            "movieUrlPattern": "https://vidjoy.pro/embed/movie/{id}",
            "tvUrlPattern": "https://vidjoy.pro/embed/tv/{id}/{season}/{episode}"
            },
            {
            "key": "embed-su",
            "name": "Embed.su",
            "movieUrlPattern": "https://embed.su/embed/movie/{id}",
            "tvUrlPattern": "https://embed.su/embed/tv/{id}/{season}/{episode}"
            },
            {
            "key": "primewire",
            "name": "PrimeWire",
            "movieUrlPattern": "https://www.primewire.tf/embed/movie?tmdb={id}",
            "tvUrlPattern": "https://www.primewire.tf/embed/tv?tmdb={id}&season={season}&episode={episode}"
            },
            {
            "key": "smashystream",
            "name": "SmashyStream",
            "movieUrlPattern": "https://embed.smashystream.com/playere.php?tmdb={id}",
            "tvUrlPattern": "https://embed.smashystream.com/playere.php?tmdb={id}&season={season}&episode={episode}"
            },
            {
            "key": "vidstream",
            "name": "VidStream",
            "movieUrlPattern": "https://vidstream.site/embed/movie/{id}",
            "tvUrlPattern": "https://vidstream.site/embed/tv/{id}/{episode}"
            },
            {
            "key": "videasy",
            "name": "Videasy",
            "movieUrlPattern": "https://player.videasy.net/movie/{id}",
            "tvUrlPattern": "https://player.videasy.net/tv/{id}/{season}/{episode}"
            },
            {
            "key": "vidsrc-wtf-2",
            "name": "VidSrc.wtf (API 2)",
            "movieUrlPattern": "https://vidsrc.wtf/api/2/movie?id={id}",
            "tvUrlPattern": "https://vidsrc.wtf/api/2/tv?id={id}&s={season}&e={episode}"
            },
            {
            "key": "vidsrc-wtf-3",
            "name": "VidSrc.wtf (API 3)",
            "movieUrlPattern": "https://vidsrc.wtf/api/3/movie?id={id}",
            "tvUrlPattern": "https://vidsrc.wtf/api/3/tv?id={id}&s={season}&e={episode}"
            },
            {
            "key": "vidfast",
            "name": "VidFast",
            "movieUrlPattern": "https://vidfast.pro/movie/{id}?autoPlay=true",
            "tvUrlPattern": "https://vidfast.pro/tv/{id}/{season}/{episode}?autoPlay=true"
            },
            {
            "key": "vidbinge",
            "name": "VidBinge",
            "movieUrlPattern": "https://vidbinge.dev/embed/movie/{id}",
            "tvUrlPattern": "https://vidbinge.dev/embed/tv/{id}/{season}/{episode}"
            }
            ]
          }
        ```

**Acceptance Criteria:**
- Video player is embedded via iframe and supports switching between multiple sources.
- Source dropdown overlays the player and auto-hides after 5 seconds of inactivity.
- Only video URLs from the fetched sources are allowed in the iframe (navigation is restricted).
- Video sources are fetched dynamically from the provided API endpoint.

---
- 2025-08-25: **UI/UX MODERNIZATION - Anime and TV Detail Screens Enhanced**
  - **AnimeDetailScreen**: Completely redesigned with modern Material Design 3 principles:
    - Floating hero poster with elevation effects
    - Parallax animated backdrop with gradient overlays
    - Modern card-based section organization with icon headers
    - Enhanced episode listing with thumbnail images, color-coded ratings, and clear information hierarchy
    - FilterChip-based season selector with visual feedback
    - Improved trailer cards with play button overlays
    - Enhanced cast display with circular avatars and better styling
    - Smooth animations and transitions throughout
  - **EnhancedDetailScreen**: Unified design language applied to regular TV shows:
    - Consistent episode view matching anime screen design
    - Modern season selection with FilterChips
    - Improved visual hierarchy and spacing
    - Better error states and loading indicators
  - **Cross-cutting Improvements**:
    - Fixed all Dart analysis errors and syntax issues
    - Standardized animation durations using const Duration
    - Enhanced accessibility with proper contrast and touch targets
    - Performance optimizations for smoother scrolling
  - **Technical Debt Resolution**:
    - Resolved syntax errors in animation duration specifications
    - Fixed missing parentheses in widget trees
    - Improved code structure and readability

- 2025-08-25: **BRANDING - Logo Design and Implementation**
  - **Logo Creation**: Designed comprehensive logo system for Let's Stream:
    - Primary logo mark with purple play button and streaming waves
    - Full logo with "Let's Stream" text
    - App icon variants for different use cases
  - **Implementation**: 
    - Created reusable Flutter AppLogo widget
    - Added SVG logo files for scalability
    - Integrated logo into Home and Profile screens
    - Updated app bar to use branded logo
  - **Assets Management**:
    - Created assets/images directory structure
    - Added logo design specifications and documentation
    - Updated pubspec.yaml to include asset directories
  - **Design System**:
    - Defined color palette (#6200EE primary purple, #1A1A1A dark background)
    - Established streaming wave visual language
    - Created comprehensive usage guidelines

- 2025-08-25: TV seasons/episodes implemented and detail routing unified
  - EnhancedDetailScreen now supports TV seasons and episodes with:
    - Season chips (labels like "Season N (X eps)") and switching
    - Episode list with thumbnails, rating badges (color-coded), and expandable full overview with air date
    - Deep link navigation to an EpisodeDetailScreen with prev/next episode controls
  - Deep links via GoRouter:
    - name: episode-detail, path: /tv/:id/season/:season/episode/:ep
  - Router changes:
    - movie-detail and tv-detail both route to EnhancedDetailScreen for a unified experience
  - API and repository additions:
    - getTvSeasons(tvId), getSeasonEpisodes(tvId, seasonNumber) in TmdbApi
    - Corresponding pass-throughs in TmdbRepository and SimpleCachedRepository
  - UI polish:
    - Shimmer placeholders while loading episode lists
    - Lint fixes and small refactors

- 2025-08-24: **MAJOR UPDATE - Complete Application Foundation Implemented**
  - **Profile Screen**: Added complete Profile Screen with Account (Sign in option), Preferences (Theme, Clear cache), and About sections using sectioned ListView design.
  - **Enhanced Widget System**: Implemented comprehensive shared widget system including:
    - `MediaCard`: Reusable card component for displaying movies/TV shows with tap handling
    - `MediaCarousel`: Horizontal scrolling carousel for media items
    - `ShimmerBox` & `ShimmerRow`: Loading placeholder components for better UX
    - `EmptyState` & `ErrorState`: Consistent state management widgets with retry functionality
  - **Theme System Enhancement**: Added `Tokens` class with standardized spacing (XS to XL), radius (S/M), durations (Fast/Med/Slow), and media-specific constants (poster dimensions)
  - **Complete Search Implementation**: 
    - `SearchNotifier` with debounced input handling and pagination
    - `SearchState` with filtering (All/Movies/TV), sorting by popularity, and state management
    - Full search screen with suggestions, loading states, error handling, and infinite scroll
  - **Movies & TV Shows Features**:
    - Complete Movies hub with genre-based rows and "View All" functionality
    - TV Shows hub with similar genre organization
    - Dedicated list screens for both movies and TV shows with pagination
    - Genre-specific list screens for filtered browsing
  - **Architecture Completion**: 
    - Comprehensive TMDB API integration with all endpoints (movies, TV, search, genres, videos, cast, similar)
    - Repository pattern fully implemented with proper error handling and logging
    - Riverpod state management throughout with AsyncValue patterns
    - GoRouter navigation with shell route and bottom navigation
  - **Model System**: Complete data models for Movie, TvShow, CastMember, Video, and TmdbResponse with null-safe implementations
  - **Detail Screen**: Enhanced with trailers (YouTube integration), similar content carousel, and cast information
  - **Anime Section**: Dedicated anime screen with movies and TV show rows filtered by genre

- 2025-08-24: Added shimmer loading placeholders for carousels and grid/list screens and pull-to-refresh to Movies/TV genre and feed list screens and Search. Improved accessibility with semantics labels for tiles and list items, and added Retry buttons on initial error states.

- 2025-08-24: Movies hub: genre "View All" now routes to MoviesGenreListScreen (Action 28, Comedy 35, Drama 18, Sci‑Fi 878). Improved MoviesListScreen and MoviesGenreListScreen pagination with _hasMore guards, infinite scroll + "Load more", and null-safe poster placeholders.
- 2025-08-24: TV hub: genre "View All" now routes to TvGenreListScreen (Action & Adventure 10759, Comedy 35, Drama 18, Sci‑Fi & Fantasy 10765). Improved TvListScreen and TvGenreListScreen pagination similarly and null-safe posters.
- 2025-08-24: Anime: wired "View All" for Anime Movies and Anime TV to MoviesGenreListScreen/TvGenreListScreen with genre 16.

- 2025-08-24: DetailScreen enhancements: added Trailers (YouTube thumbnails launching externally), Similar titles carousel, and Top Billed Cast section. Introduced API and repository methods for videos/similar/credits and a new CastMember model.
- 2025-08-24: Search UX expanded: filter toggle (All/Movies/TV), poster thumbnails, clear button, results count and rating/year subtitle, persisted last query/filter, empty-state suggestions, and a "Load more" button alongside infinite scroll.

- 2025-08-24: Debounced, paginated Search implemented. Added Riverpod SearchNotifier/SearchState, updated SearchScreen to debounce input, merge Movies+TV by popularity, and support infinite scrolling with loading/error states.

- 2025-08-24: Environment bootstrapping and detail routing added. Home now loads multiple feeds (movies and TV). Detail screen created and wired. Warnings cleaned.
- 2025-08-24: Movies/TV hubs implemented with MediaCarousel rows and View All buttons. Search screen added and wired. Anime screen added with anime movies/TV rows.
- 2025-08-24: Added pagination for View All list screens (movies and TV). API and repository now support paging and genre-based discover endpoints. Home and hubs use consistent MediaCarousel pattern.
- 2025-08-24: Fixed runtime errors on Anime and Search screens by:
  - Making Movie and TvShow model fields null-safe (posterPath/backdropPath/release/firstAir dates).
  - Updating MediaCard and Anime list builder to handle null/empty image paths safely.
  - Hardening SearchScreen to avoid null string casts.
- 2025-08-24: Added genre-based rows to Movies and TV hubs (Action, Comedy, Drama, Sci‑Fi, etc.), created paginated View All screens by genre, and added routes `/movies/genre/:id` and `/tv-shows/genre/:id`.
- 2025-08-24: Fixed syntax errors in Anime screen itemBuilder (dangling comma/semicolon) and removed redundant non-null assertion in DetailScreen; ensured null-safe image/date rendering.

## Troubleshooting and Platform Setup

- Android toolchain: if builds fail locally, ensure Android SDK command-line tools are installed and licenses accepted:
```bash
flutter doctor
flutter doctor --android-licenses
```
- Windows desktop builds require the “Desktop development with C++” workload in Visual Studio Build Tools.
- API issues: verify `.env` values are loaded (see Environment and Startup) and network connectivity.

## Project Structure Reference (Current Implementation)

```
lib/
├── src/
│   ├── core/
│   │   ├── api/
│   │   │   └── tmdb_api.dart               # Complete TMDB API client
│   │   ├── models/
│   │   │   ├── movie.dart                  # Movie data model
│   │   │   ├── tv_show.dart               # TV Show data model
│   │   │   ├── cast_member.dart           # Cast/crew data model
│   │   │   ├── video.dart                 # Video/trailer data model
│   │   │   └── tmdb_response.dart         # Generic API response wrapper
│   │   └── services/
│   │       ├── tmdb_repository.dart       # Repository pattern implementation
│   │       └── tmdb_repository_provider.dart # Riverpod provider
│   ├── features/
│   │   ├── home/
│   │   │   ├── application/
│   │   │   │   ├── home_notifier.dart     # Home state management
│   │   │   │   └── home_state.dart        # Home state definition
│   │   │   └── presentation/
│   │   │       └── home_screen.dart       # Home UI with carousels
│   │   ├── movies/
│   │   │   └── presentation/
│   │   │       ├── movies_list_screen.dart      # Movies feed lists
│   │   │       └── movies_genre_list_screen.dart # Genre-filtered movies
│   │   ├── tv_shows/
│   │   │   └── presentation/
│   │   │       ├── tv_list_screen.dart          # TV shows feed lists
│   │   │       └── tv_genre_list_screen.dart    # Genre-filtered TV shows
│   │   ├── anime/
│   │   │   └── presentation/
│   │   │       └── anime_screen.dart       # Anime hub with movies/TV
│   │   ├── search/
│   │   │   ├── application/
│   │   │   │   ├── search_notifier.dart   # Search state management
│   │   │   │   └── search_state.dart      # Search state with filters
│   │   │   └── presentation/
│   │   │       └── search_screen.dart     # Search UI with debouncing
│   │   ├── detail/
│   │   │   └── presentation/
│   │   │       └── detail_screen.dart     # Enhanced detail view
│   │   ├── profile/
│   │   │   └── presentation/
│   │   │       └── profile_screen.dart    # User profile and settings
│   │   └── hub/
│   │       └── presentation/
│   │           └── hub_screens.dart       # Movies/TV hub screens
│   └── shared/
│       ├── theme/
│       │   ├── app_theme.dart             # Material 3 theming
│       │   └── tokens.dart                # Design system tokens
│       └── widgets/
│           ├── media_card.dart            # Reusable media item card
│           ├── media_carousel.dart        # Horizontal media carousel
│           ├── shimmer_box.dart           # Loading placeholder
│           ├── shimmer_row.dart           # Loading placeholder row
│           ├── empty_state.dart           # Empty state component
│           └── error_state.dart           # Error state with retry
└── main.dart                              # App entry point with routing
```

## Technology Stack Summary

- Flutter 3.35.1+
- Dart
- Riverpod
- Dio
- GoRouter
- Material 3 theming
- Firebase (planned)
- Hive + Shared Preferences (planned usage)
- Build Runner + Flutter Lints

This guide is tailored to this repository’s actual structure and current implementation so future Warp instances can ramp up quickly without re-discovering architectural intent.


# Project Rules

- Record implementation progress in warp.md
 - User wants to record what is implemented in warp.md file as they go on from now onwards after each iteration.

- Do not build releaseapk until requested and always run on connected android device
 - Do not build releaseapk until explicitly requested. Always run the releaseapk on an Android device that is connected.
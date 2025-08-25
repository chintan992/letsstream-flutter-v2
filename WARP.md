# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

**Let's Stream** is a modern Flutter-based media discovery application for movies, TV shows, and anime. It integrates with The Movie Database (TMDB) API and uses Firebase (planned) for user authentication and data storage.

## Plan Alignment and Current Status (Phase 0)

A quick map of the current implementation against the development plan:
- Foundation and Navigation (Phase 1 • Week 1):
  - Implemented: GoRouter with a ShellRoute and bottom navigation; placeholder routes for Movies, TV Shows, Anime, and Profile.
  - Implemented: Home screen scaffold.
- API Integration and Sections (Phase 1 • Week 2):
  - Implemented: TMDB integration via `TmdbApi` (Dio) and `TmdbRepository` with logging.
  - Implemented: Home carousels for Trending Movies, Now Playing Movies, Trending TV Shows, and Airing Today TV Shows (via `HomeNotifier`).
  - Implemented: Movies and TV hubs with multiple genre rows and "View All" buttons routing to paginated genre list screens; Anime hub with anime movies and TV rows and "View All" by genre.
  - Implemented: Popular/Top Rated feeds and paginated list screens with infinite scroll + "Load more" and null-safe poster placeholders.
- Detail + Search (Phase 1 • Week 3):
  - Implemented: Debounced, paginated Search with filter toggle and persistence.
  - Implemented: Detail screen enhanced with Trailers (YouTube), Similar titles, and Top Billed Cast sections.
- State Management & Auth (Phase 2):
  - Implemented: Riverpod across the Home feature (StateNotifier + AsyncValue).
  - Pending: Firebase initialization and Auth flows (packages present; initialization commented in `main.dart`).
- Advanced Features & Polishing (Phase 3):
  - Pending: Advanced search/filters, caching (Hive in deps but not wired), settings, trailers/similar titles.

Suggested next small steps:
- Wire Popular/Top Rated lists through `TmdbApi` → `TmdbRepository` → `HomeNotifier` → `HomeScreen`.
- Add a basic search feature and a details page; route from media cards.
- Initialize Firebase and implement sign-in flows when ready.

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

## Project Structure Reference (high level)

```
lib/
├── src/
│   ├── core/
│   │   ├── api/
│   │   ├── services/
│   │   └── models/
│   ├── features/
│   │   └── home/
│   └── shared/
└── main.dart
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
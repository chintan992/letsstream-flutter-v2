
# User Flow Diagram

This document outlines the primary user navigation paths within the Let's Stream application.

## 1. Initial Entry

- **App Start** → **Home Screen (`/`)**

## 2. Main Navigation (Bottom Navigation Bar)

The user can switch between the five main sections of the app at any time from the root of the navigation shell.

- **Home (`/`)**: Main dashboard displaying a mix of content.
- **Movies (`/movies`)**: Hub for movie content.
- **TV Shows (`/tv-shows`)**: Hub for TV show content.
- **Anime (`/anime`)**: Dedicated section for anime content.
- **Profile (`/profile`)**: User profile, settings, and authentication actions.

## 3. Core Journeys

### Journey A: Discovering and Watching a Movie

1.  **Home Screen** → Taps on a movie poster → **Movie Detail Screen (`/movie/:id`)**
2.  **Movies Hub** → Selects a category (e.g., "Popular") → **Movies List Screen (`/movies/popular`)**
3.  **Movies List Screen** → Taps on a movie poster → **Movie Detail Screen (`/movie/:id`)**
4.  **Movie Detail Screen** → Taps "Watch Now" button → **Video Player Screen (`/watch/movie/:id`)**

### Journey B: Discovering and Watching a TV Show Episode

1.  **TV Shows Hub** → Selects a category (e.g., "Top Rated") → **TV List Screen (`/tv-shows/top_rated`)**
2.  **TV List Screen** → Taps on a TV show poster → **TV Detail Screen (`/tv/:id`)**
3.  **TV Detail Screen** → Selects a season and episode → **Episode Detail Screen (`/tv/:id/season/:season/episode/:ep`)**
4.  **Episode Detail Screen** → Taps "Play" button → **Video Player Screen (`/watch/tv/:id/season/:season/episode/:ep`)**

### Journey C: Using Search

1.  **Any main screen** → Taps Search Icon (likely in AppBar) → **Search Screen (`/search`)**
2.  **Search Screen** → Enters query and gets results → Taps on a result → **Appropriate Detail Screen** (e.g., `/movie/:id` or `/tv/:id`)

## 4. Authentication

- Authentication is likely handled within the **Profile Screen (`/profile`)**.
- Actions on this screen would include:
    - Login (e.g., Google Sign-In, Apple Sign-In)
    - Logout
    - Viewing user-specific information (e.g., watchlist).

This flow provides the foundation for the UI refinement process. I will proceed by polishing screens in an order that follows these core user journeys.

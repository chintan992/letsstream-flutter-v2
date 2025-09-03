# Project Reference: Let's Stream

## 1. Implemented Features

Based on the directory structure in `lib/src/features`, the following core features are implemented:

*   **Hub**: Likely a central dashboard or entry point.
*   **Auth**: User authentication (login, logout, sign-up).
*   **Home**: The main home screen of the application.
*   **Anime**: Dedicated section for anime content.
*   **Detail**: Generic detail screens for movies, TV shows, or anime.
*   **Movies**: Hub for movie content.
*   **Search**: Functionality to search for content.
*   **Profile**: User profile management and settings.
*   **TV Shows**: Hub for TV show content.
*   **Video Player**: For playing video content.

## 2. UI Designs and Assets

The `pubspec.yaml` and `assets/images` directory provide insights into the UI and design elements:

### Dependencies for UI/UX:
*   `cached_network_image`: For efficient loading and caching of network images.
*   `shimmer`: Likely used for loading placeholders and visual feedback.
*   `flutter_animate`: For animations and dynamic UI elements.
*   `flutter_svg`: For rendering scalable vector graphics (SVGs), as seen with `app_icon.svg` and `app_logo.svg`.
*   `google_fonts`: For custom typography using Google Fonts.

### Assets:
*   `.env`: Environment configuration.
*   `assets/images/app_icon.svg`: Application icon.
*   `assets/images/app_logo.svg`: Application logo.
*   `assets/images/logo_design_spec.txt`: Likely contains specifications for the logo design.
*   `assets/images/LOGO_DOCUMENTATION.md`: Documentation related to the application logo.

These suggest a modern UI with an emphasis on visual appeal, smooth animations, and custom branding.

## 3. User Flow

The `USER_FLOW.md` file comprehensively describes the user navigation:

### Initial Entry
*   **App Start** → **Home Screen (`/`)**

### Main Navigation (Bottom Navigation Bar)
Users can navigate between the following main sections:
*   **Home (`/`)**: Main dashboard.
*   **Movies (`/movies`)**: Movie content.
*   **TV Shows (`/tv-shows`)**: TV show content.
*   **Anime (`/anime`)**: Anime content.
*   **Profile (`/profile`)**: User profile, settings, and authentication.

### Core Journeys

#### Journey A: Discovering and Watching a Movie
*   **Home Screen** → **Movie Detail Screen (`/movie/:id`)**
*   **Movies Hub** → **Movies List Screen (`/movies/popular`)**
*   **Movies List Screen** → **Movie Detail Screen (`/movie/:id`)**
*   **Movie Detail Screen** → **Video Player Screen (`/watch/movie/:id`)**

#### Journey B: Discovering and Watching a TV Show Episode
*   **TV Shows Hub** → **TV List Screen (`/tv-shows/top_rated`)**
*   **TV List Screen** → **TV Detail Screen (`/tv/:id`)**
*   **TV Detail Screen** → **Episode Detail Screen (`/tv/:id/season/:season/episode/:ep`)**
*   **Episode Detail Screen** → **Video Player Screen (`/watch/tv/:id/season/:season/episode/:ep`)**

#### Journey C: Using Search
*   **Any main screen** → **Search Screen (`/search`)**
*   **Search Screen** → **Appropriate Detail Screen** (e.g., `/movie/:id` or `/tv/:id`)

### Authentication
*   Handled within the **Profile Screen (`/profile`)**.
*   Includes Login (Google, Apple), Logout, and viewing user-specific information.

## 4. Necessary Stuff (Dependencies and Architecture)

### State Management
*   `flutter_riverpod`: For robust and scalable state management.
*   `riverpod_annotation`: Likely for code generation with Riverpod.

### Network & API
*   `dio`: A powerful HTTP client for making network requests.
*   `json_annotation`: For JSON serialization/deserialization.
*   `connectivity_plus`: For checking network connectivity.
*   `http`: Another HTTP client.

### Firebase
*   `firebase_core`: Core Firebase functionalities.
*   `firebase_auth`: For user authentication with Firebase.
*   `cloud_firestore`: For NoSQL cloud database.
*   `google_sign_in`: For Google authentication.
*   `sign_in_with_apple`: For Apple authentication.

### Local Storage
*   `hive`: A fast, lightweight, and powerful NoSQL database for Flutter.
*   `hive_flutter`: Flutter integration for Hive.
*   `shared_preferences`: For storing simple key-value pairs locally.

### Navigation
*   `go_router`: A declarative routing package for Flutter.

### Utilities
*   `intl`: Internationalization and localization.
*   `url_launcher`: For launching URLs.
*   `flutter_dotenv`: For loading environment variables from a `.env` file.
*   `logger`: For logging.
*   `webview_flutter`: For embedding web views.
*   `flutter_inappwebview`: For advanced WebView functionalities.
*   `freezed_annotation`: For code generation of data classes.

### Development Dependencies (Code Generation)
*   `build_runner`: For running code generators.
*   `json_serializable`: For generating `fromJson` and `toJson` methods.
*   `hive_generator`: For generating Hive adapters.
*   `freezed`: For generating boilerplate code for data classes.

### Architectural Overview
The project appears to follow a layered architecture, with features organized into distinct modules. The use of Riverpod for state management, Dio for networking, Firebase for backend services, and GoRouter for navigation suggests a modern and well-structured approach to Flutter development. The presence of code generation tools (json_serializable, hive_generator, freezed) indicates an emphasis on reducing boilerplate and improving maintainability.

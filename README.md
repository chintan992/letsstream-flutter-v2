# Let's Stream

**Let's Stream** is a modern, feature-rich media discovery application built with Flutter. It allows users to explore, search, and stream movies, TV shows, and anime, leveraging The Movie Database (TMDB) for metadata and a custom API for video streaming sources.

## 🌟 Features

- **Media Discovery**: Browse extensive catalogs of movies, TV shows, and anime.
- **Dynamic Home Screen**: Discover trending, now playing, and airing today content through interactive carousels.
- **Advanced Search**: Find any media with debounced, paginated search, including filters for movies and TV shows.
- **Detailed Views**: Get in-depth information with rich detail screens showing trailers, cast, similar titles, and TV show seasons/episodes.
- **In-App Video Playback**: Stream content directly within the app using a secure, iframe-based video player.
- **Multi-Source Streaming**: Switch between over 20+ different video sources for reliable playback.
- **Modern UI/UX**: A sleek, responsive interface built with Material Design 3, featuring smooth animations, shimmer loading effects, and a polished design system.
- **State Management**: Robust state handling with Riverpod, ensuring a predictable and maintainable codebase.
- **Navigation**: Seamless navigation powered by GoRouter, including persistent bottom navigation and deep linking.

## 🚀 Current Status

The project has successfully completed its foundational phase (Phase 1) and is actively under development.

- **Phase 1 (Completed)**: Core features such as API integration, navigation, all major screens (Home, Movies, TV, Anime, Search, Detail), and the complete UI/UX foundation are fully implemented.
- **Phase 2 (In Progress)**: Focus is on integrating Firebase for user authentication (Google & Apple Sign-In), watchlist synchronization, and user preferences.
- **Phase 3 (Future)**: Plans include advanced search filters, local caching with Hive for offline support, and further UI/UX polish.

## 🛠️ Technology Stack

- **Framework**: Flutter
- **Language**: Dart
- **State Management**: Riverpod
- **HTTP Client**: Dio
- **Navigation**: GoRouter
- **Design**: Material 3
- **Backend Integration**: TMDB API, Firebase (planned), Custom Video Source API
import 'package:freezed_annotation/freezed_annotation.dart';

part 'watchlist_item.freezed.dart';
part 'watchlist_item.g.dart';

/// Represents an item in a user's personal watchlist for movies and TV shows.
///
/// This model encapsulates all information needed to manage a user's watchlist,
/// including content metadata, user preferences, viewing status, and organizational
/// categories. It supports both movies and TV shows with a unified interface.
///
/// The model includes features for:
/// - Content identification and metadata
/// - User ratings and notes
/// - Viewing status tracking
/// - Priority management
/// - Category-based organization
/// - Timestamps for tracking additions and updates
///
/// ```dart
/// // Create a watchlist item from a movie
/// final movieItem = WatchlistItem.fromMovie(
///   movie,
///   categories: ['Want to Watch', 'Marvel Movies']
/// );
///
/// // Create a watchlist item from a TV show
/// final tvItem = WatchlistItem.fromTvShow(
///   tvShow,
///   categories: ['Currently Watching']
/// );
///
/// // Mark as watched
/// final watchedItem = movieItem.copyWith(
///   isWatched: true,
///   watchedAt: DateTime.now()
/// );
/// ```
@freezed
class WatchlistItem with _$WatchlistItem {
  const factory WatchlistItem({
    /// Unique identifier for the item
    required String id,

    /// Content ID (movie or TV show ID)
    required int contentId,

    /// Content type (movie or tv)
    required String contentType,

    /// Title of the content
    required String title,

    /// Poster path for the content
    String? posterPath,

    /// Overview/description
    String? overview,

    /// Release date
    DateTime? releaseDate,

    /// Vote average/rating
    double? voteAverage,

    /// Categories this item belongs to
    @Default([]) List<String> categories,

    /// User rating (1-10, null if not rated)
    double? userRating,

    /// User notes
    String? notes,

    /// Priority level (1-5, higher = more priority)
    @Default(3) int priority,

    /// When the item was added to watchlist
    required DateTime addedAt,

    /// When the item was last updated
    DateTime? updatedAt,

    /// Whether the item has been watched
    @Default(false) bool isWatched,

    /// When the item was marked as watched
    DateTime? watchedAt,
  }) = _WatchlistItem;

  factory WatchlistItem.fromJson(Map<String, dynamic> json) =>
      _$WatchlistItemFromJson(json);

  /// Creates a new watchlist item from a movie with default categorization.
  ///
  /// This factory method simplifies the creation of watchlist entries for movies
  /// by automatically generating the unique ID and setting appropriate defaults.
  /// The movie object should have the standard properties (id, title, posterPath, etc.).
  ///
  /// [movie] The movie object to create a watchlist item from.
  /// [categories] Optional list of categories to assign to this item.
  ///              Defaults to ['Watch Later'] if not specified.
  ///
  /// Returns a new WatchlistItem configured for the specified movie.
  ///
  /// ```dart
  /// final movie = Movie(/* ... movie data ... */);
  /// final watchlistItem = WatchlistItem.fromMovie(
  ///   movie,
  ///   categories: ['Want to Watch', 'Action Movies']
  /// );
  /// ```
  factory WatchlistItem.fromMovie(
    dynamic movie, {
    List<String> categories = const ['Watch Later'],
  }) {
    return WatchlistItem(
      id: 'movie_${movie.id}',
      contentId: movie.id,
      contentType: 'movie',
      title: movie.title ?? 'Unknown Movie',
      posterPath: movie.posterPath,
      overview: movie.overview,
      releaseDate: movie.releaseDate,
      voteAverage: movie.voteAverage?.toDouble(),
      categories: categories,
      addedAt: DateTime.now(),
    );
  }

  /// Creates a new watchlist item from a TV show with default categorization.
  ///
  /// This factory method simplifies the creation of watchlist entries for TV shows
  /// by automatically generating the unique ID and setting appropriate defaults.
  /// The TV show object should have the standard properties (id, name, posterPath, etc.).
  ///
  /// [tvShow] The TV show object to create a watchlist item from.
  /// [categories] Optional list of categories to assign to this item.
  ///              Defaults to ['Watch Later'] if not specified.
  ///
  /// Returns a new WatchlistItem configured for the specified TV show.
  ///
  /// ```dart
  /// final tvShow = TvShow(/* ... TV show data ... */);
  /// final watchlistItem = WatchlistItem.fromTvShow(
  ///   tvShow,
  ///   categories: ['Currently Watching', 'Drama Series']
  /// );
  /// ```
  factory WatchlistItem.fromTvShow(
    dynamic tvShow, {
    List<String> categories = const ['Watch Later'],
  }) {
    return WatchlistItem(
      id: 'tv_${tvShow.id}',
      contentId: tvShow.id,
      contentType: 'tv',
      title: tvShow.name ?? 'Unknown TV Show',
      posterPath: tvShow.posterPath,
      overview: tvShow.overview,
      releaseDate: tvShow.firstAirDate,
      voteAverage: tvShow.voteAverage?.toDouble(),
      categories: categories,
      addedAt: DateTime.now(),
    );
  }
}

/// Provides predefined categories for organizing watchlist items.
///
/// This class contains standard categories that can be used to organize
/// movies and TV shows in a user's watchlist. These categories help users
/// manage their viewing priorities and track different types of content.
///
/// Categories are used to:
/// - Organize content by viewing priority
/// - Track viewing status (watched, currently watching)
/// - Group content by user preferences (favorites, recommendations)
/// - Separate content by intended viewing time (watch later, want to watch)
///
/// ```dart
/// // Use predefined categories
/// final categories = WatchlistCategories.all;
///
/// // Use only default categories
/// final defaultCategories = WatchlistCategories.defaultCategories;
///
/// // Access individual categories
/// final watchLater = WatchlistCategories.watchLater;
/// final favorites = WatchlistCategories.favorites;
/// ```
class WatchlistCategories {
  /// Category for content the user wants to watch at a later time.
  static const String watchLater = 'Watch Later';

  /// Category for the user's favorite movies and TV shows.
  static const String favorites = 'Favorites';

  /// Category for content that has already been watched.
  static const String watched = 'Watched';

  /// Category for content the user is currently watching.
  static const String currentlyWatching = 'Currently Watching';

  /// Category for content the user wants to watch but hasn't started yet.
  static const String wantToWatch = 'Want to Watch';

  /// Category for content recommended to the user.
  static const String recommended = 'Recommended';

  /// Complete list of all available predefined categories.
  ///
  /// This list contains all standard categories that can be used
  /// for organizing watchlist items. Applications can extend this
  /// list with custom categories as needed.
  static const List<String> all = [
    watchLater,
    favorites,
    watched,
    currentlyWatching,
    wantToWatch,
    recommended,
  ];

  /// Default categories recommended for new watchlist installations.
  ///
  /// This subset of categories provides a good starting point for
  /// users who are new to watchlist organization. It includes the
  /// most commonly used categories for basic content management.
  static const List<String> defaultCategories = [
    watchLater,
    favorites,
    watched,
  ];
}

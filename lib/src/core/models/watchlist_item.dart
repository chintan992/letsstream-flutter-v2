import 'package:freezed_annotation/freezed_annotation.dart';

part 'watchlist_item.freezed.dart';
part 'watchlist_item.g.dart';

/// Model for watchlist items with categories
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

  /// Create a new watchlist item from a movie
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

  /// Create a new watchlist item from a TV show
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

/// Predefined watchlist categories
class WatchlistCategories {
  static const String watchLater = 'Watch Later';
  static const String favorites = 'Favorites';
  static const String watched = 'Watched';
  static const String currentlyWatching = 'Currently Watching';
  static const String wantToWatch = 'Want to Watch';
  static const String recommended = 'Recommended';

  static const List<String> all = [
    watchLater,
    favorites,
    watched,
    currentlyWatching,
    wantToWatch,
    recommended,
  ];

  static const List<String> defaultCategories = [
    watchLater,
    favorites,
    watched,
  ];
}

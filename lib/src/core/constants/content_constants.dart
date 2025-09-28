/// Constants for content discovery and categorization
class ContentConstants {
  // Popular Movie Genres (TMDB Genre IDs)
  static const Map<int, String> popularMovieGenres = {
    28: 'Action',
    12: 'Adventure',
    16: 'Animation',
    35: 'Comedy',
    80: 'Crime',
    18: 'Drama',
    10751: 'Family',
    14: 'Fantasy',
    27: 'Horror',
    9648: 'Mystery',
    10749: 'Romance',
    878: 'Sci-Fi',
    53: 'Thriller',
    37: 'Western',
  };

  // Popular TV Show Genres (TMDB Genre IDs)
  static const Map<int, String> popularTvGenres = {
    10759: 'Action & Adventure',
    16: 'Animation',
    35: 'Comedy',
    80: 'Crime',
    99: 'Documentary',
    18: 'Drama',
    10751: 'Family',
    10762: 'Kids',
    9648: 'Mystery',
    10763: 'News',
    10764: 'Reality',
    10765: 'Sci-Fi & Fantasy',
    10766: 'Soap',
    10767: 'Talk',
    10768: 'War & Politics',
  };

  // Major Streaming Platforms (TMDB Watch Provider IDs)
  static const Map<int, String> streamingPlatforms = {
    8: 'Netflix',
    9: 'Amazon Prime Video',
    15: 'Hulu',
    337: 'Disney Plus',
    384: 'HBO Max',
    2: 'Apple TV Plus',
    531: 'Paramount Plus',
    350: 'Apple TV',
    283: 'Crunchyroll',
    387: 'Peacock',
    386: 'Peacock Premium',
    1899: 'Max',
    619: 'Discovery Plus',
    546: 'Showtime',
    26: 'AMC Plus',
  };

  // Default personalization suggestions
  static const List<int> defaultMovieGenres = [28, 35, 18, 878, 27]; // Action, Comedy, Drama, Sci-Fi, Horror
  static const List<int> defaultTvGenres = [18, 35, 80, 10765]; // Drama, Comedy, Crime, Sci-Fi & Fantasy
  static const List<int> defaultPlatforms = [8, 9, 337, 15]; // Netflix, Prime, Disney+, Hulu

  // Genre combinations for mixed content
  static const Map<String, List<int>> genreCombinations = {
    'Action & Adventure': [28, 12],
    'Comedy & Romance': [35, 10749],
    'Sci-Fi & Fantasy': [878, 14],
    'Crime & Thriller': [80, 53],
    'Horror & Mystery': [27, 9648],
  };

  // Content type identifiers
  static const String contentTypeMovie = 'movie';
  static const String contentTypeTv = 'tv';
  
  // Personalized section titles
  static const List<String> personalizedSectionTitles = [
    'Based on Your Preferences',
    'Recommended for You',
    'Your Favorite Genres',
    'From Your Preferred Platforms',
    'Trending in Your Genres',
    'Popular on Your Platforms',
  ];

  // Maximum items per carousel
  static const int maxItemsPerCarousel = 20;
  
  // Cache keys for personalized content
  static const String cacheKeyPersonalizedMovies = 'personalized_movies';
  static const String cacheKeyPersonalizedTv = 'personalized_tv';
  static const String cacheKeyRecommendedMovies = 'recommended_movies';
  static const String cacheKeyRecommendedTv = 'recommended_tv';
}
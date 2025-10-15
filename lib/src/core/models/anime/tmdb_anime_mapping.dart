/// Represents a mapping between TMDB anime ID and Anime API ID.
///
/// This model is used to cache successful mappings between TMDB anime entries
/// and their corresponding Anime API entries to avoid repeated API calls.
class TmdbAnimeMapping {
  /// The TMDB ID for the anime.
  final int tmdbId;

  /// The Anime API ID for the anime.
  final String animeApiId;

  /// The title of the anime (for display purposes).
  final String animeTitle;

  /// When this mapping was cached.
  final DateTime cachedAt;

  /// Whether this mapping was manually selected by the user.
  final bool isManualMapping;

  /// Creates a new TmdbAnimeMapping instance.
  const TmdbAnimeMapping({
    required this.tmdbId,
    required this.animeApiId,
    required this.animeTitle,
    required this.cachedAt,
    this.isManualMapping = false,
  });

  /// Creates a TmdbAnimeMapping instance from a JSON map.
  ///
  /// [json] A map containing mapping data.
  factory TmdbAnimeMapping.fromJson(Map<String, dynamic> json) {
    return TmdbAnimeMapping(
      tmdbId: json['tmdbId'] as int,
      animeApiId: json['animeApiId'] as String,
      animeTitle: json['animeTitle'] as String,
      cachedAt: DateTime.parse(json['cachedAt'] as String),
      isManualMapping: json['isManualMapping'] as bool? ?? false,
    );
  }

  /// Converts the TmdbAnimeMapping instance to a JSON-serializable map.
  Map<String, dynamic> toJson() {
    return {
      'tmdbId': tmdbId,
      'animeApiId': animeApiId,
      'animeTitle': animeTitle,
      'cachedAt': cachedAt.toIso8601String(),
      'isManualMapping': isManualMapping,
    };
  }

  /// Creates a copy of this mapping with updated fields.
  TmdbAnimeMapping copyWith({
    int? tmdbId,
    String? animeApiId,
    String? animeTitle,
    DateTime? cachedAt,
    bool? isManualMapping,
  }) {
    return TmdbAnimeMapping(
      tmdbId: tmdbId ?? this.tmdbId,
      animeApiId: animeApiId ?? this.animeApiId,
      animeTitle: animeTitle ?? this.animeTitle,
      cachedAt: cachedAt ?? this.cachedAt,
      isManualMapping: isManualMapping ?? this.isManualMapping,
    );
  }

  /// Returns true if this mapping is older than the specified duration.
  bool isOlderThan(Duration duration) {
    return DateTime.now().difference(cachedAt) > duration;
  }

  /// Returns true if this mapping should be refreshed (older than 30 days).
  bool get shouldRefresh {
    return isOlderThan(const Duration(days: 30));
  }

  @override
  String toString() {
    return 'TmdbAnimeMapping(tmdbId: $tmdbId, animeApiId: $animeApiId, title: $animeTitle)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TmdbAnimeMapping &&
        other.tmdbId == tmdbId &&
        other.animeApiId == animeApiId;
  }

  @override
  int get hashCode => Object.hash(tmdbId, animeApiId);
}
